part of 'remote_data_source.dart';

abstract interface class RPCTokenManager {
  Future<String> getRPCTokenOrThrow();

  Future<void> saveRPCToken(String token);
}

class RPCPaymentApiImpl implements RPCPayCoreApi {
  late final _base = 'POSitiveWebLink';
  late final className = runtimeType.toString();
  String? _ip, _port, _tid;
  final RPCTokenManager tokenManger;

  RPCPaymentApiImpl(this.tokenManger);

  @override
  Future<String> pairRequestOrThrow(
      {required String ip,
      required String port,
      required String tid,
      required String pairCode}) async {
    _ip = ip;
    _port = port;
    _tid = tid;
    final url = '${_buildBaseUrl()}/pair?tid=$tid&pairingCode=$pairCode';
    Logger.keyValueOn(className, 'connect', 'url', url);
    try {
      final client = NetworkClient.createBaseClient();
      final response = await client.getOrThrow(url: url);
      final token = RPCEventParser.parseTokenOrThrow(response);
      tokenManger.saveRPCToken(token);
      Logger.keyValueOn(className, 'pairRequestOrThrow', 'auth-token', token);
      return token;
    } catch (e) {
      Logger.errorCaught(className, 'pairRequestOrThrow()',e,null);
      throw CustomException(message: 'Unable to connect RPC', debugMessage: className);
    }
  }

  @override
  Future<String> terminalStatusRequestOrThrow() async {
    final url = '${_buildBaseUrl()}/status?tid=${tidOrThrow()}';
    Logger.keyValueOn(className, 'statusRequestOrThrow', 'url',url);
    final client = NetworkClient.createBaseClient();
    final response = await client.getOrThrow(url: url, headers: await _headerOrThrow());
    final status = RPCEventParser.parseTokenOrThrow(response);
    Logger.keyValueOn(className, 'statusRequestOrThrow',  'response', status);
    return status;
  }

  String _buildBaseUrl() {
    final address = '${ipOrThrow()}:${portOrThrow()}';
    return 'https://$address/$_base/1.0.0/rest';
  }

  @override
  Future<dynamic> cancelRequestOrThrow() async {
    final url = '${_buildBaseUrl()}/transaction?tid=${tidOrThrow()}';
    Logger.keyValueOn(className,'cancelRequestOrThrow',  'url',url);
    final client = NetworkClient.createBaseClient();
    final response =
        await client.deleteOrThrow(url: url, headers: await _headerOrThrow());
    Logger.keyValueOn(className, 'cancelRequestOrThrow', 'response', response);
  }

  @override
  Future<String> startTransactionOrThrow(
      {required double amount,
      required double discount,
      required double cashback,
      required double gratuity}) async {
    final url =
        '${_buildBaseUrl()}/transaction?tid=${tidOrThrow()}&disablePrinting=true';
    final payload = {
      "transType": "SALE",
      "amountTrans": (amount * 100).round(),
      "amountGratuity": gratuity,
      "amountCashback": cashback,
      "reference": "TEST CARD"
    };
    Logger.on(className, 'startTransaction::payload:$payload');
    final client = NetworkClient.createBaseClient();
    final response = await client.postOrThrow(
        url: url, payload: payload, headers: await _headerOrThrow());
    final message = 'startTransaction::response$response';
    Logger.on(className, message);

    return RPCEventParser.parseUtiOrThrow(response);
  }

  @override
  Future<List<String>> readTransactionStatusOrThrow(
      {required String uti, bool reversal = false}) async {
    if (reversal) {
      return _validRequestReversalOrThrow(uti: uti);
    }

    try{
      final url =
          '${_buildBaseUrl()}/transaction?tid=${tidOrThrow()}&uti=4624E2C4-F6F1-46CC-873E-0A8A0F673442';
      final client = NetworkClient.createBaseClient();
      final response =
      await client.getOrThrow(url: url, headers: await _headerOrThrow());
      final status = RPCEventParser.parseStatusOr(response);
      return status;
    }
    catch(e){
      Logger.errorCaught(className, 'readTransactionStatusOrThrow', e, null);
      rethrow;
    }



  }

  Future<List<String>> _validRequestReversalOrThrow(
      {required String uti}) async {
    final url =
        '${_buildBaseUrl()}/transaction?tid=${tidOrThrow()}&disablePrinting=false';
    final client = NetworkClient.createBaseClient();
    final payload = {"uti": uti, "transType": "REVERSAL"};
    final response = await client.postOrThrow(
        url: url, payload: payload, headers: await _headerOrThrow());
    final status = RPCEventParser.parseStatusOr(response);
    //final message = 'validRequestOrThrow::status=$status';
    // showSnackBar(message);
    return status;
  }

  Future<Headers> _headerOrThrow() async {
    final token = await tokenManger.getRPCTokenOrThrow();
    return Headers.createAuthHeader(token);
  }

  String ipOrThrow() {
    final snapshot = _ip;
    if (snapshot == null) {
      throw CustomException(message: 'IP not found', debugMessage: className);
    }
    return snapshot;
  }

  String portOrThrow() {
    final snapshot = _port;
    if (snapshot == null) {
      throw CustomException(message: 'Port not found', debugMessage: className);
    }
    return snapshot;
  }

  String tidOrThrow() {
    final snapshot = _tid;
    if (snapshot == null) {
      throw CustomException(message: 'TID not found', debugMessage: className);
    }
    return snapshot;
  }
}

final class RPCEventParser {
  late final tag = runtimeType.toString();

  RPCEventParser();

  static String parseTokenOrThrow(Json response) {
    return response['authToken'];
  }

  static String parseStatusOrThrow(Json response) {
    return response['todo'];
  }

  static String parseUtiOrThrow(Json response) {
    return response['uti'];
  }

  static List<String> parseStatusOr(Map<String, dynamic> response) {
    final raw = response['Statuses'];
    if (raw == null || raw is! String) return [];

    final List<dynamic> decoded = json.decode(raw);
    return decoded
        .map((e) => e['statusDescription']?.toString() ?? '')
        .where((desc) => desc.isNotEmpty)
        .toList();
  }
}

class StatusHelper {
  static bool isSuccess(String status) =>
      status.trim().toLowerCase() == 'transaction finished';

  static bool isCancelled(String status) =>
      status.trim().toLowerCase() == 'transaction cancelled';

  static bool isError(String status) =>
      status.trim().toLowerCase() == 'transaction failed' ||
      status.trim().toLowerCase() == 'error' ||
      status.toLowerCase().contains('failed');

  static bool isTimeout(String status) =>
      status.trim().toLowerCase() == 'transaction timeout';

  static bool isCardRemoved(String status) =>
      status.trim().toLowerCase() == 'card removed';

  static bool isDeclined(String status) =>
      status.trim().toLowerCase() == 'transaction declined';

  static bool isAborted(String status) =>
      status.trim().toLowerCase() == 'transaction aborted';

  static bool isDisconnected(String status) =>
      status.trim().toLowerCase() == 'disconnected';

  static bool isTerminal(String status) =>
      isSuccess(status) ||
      isCancelled(status) ||
      isError(status) ||
      isTimeout(status) ||
      isDeclined(status) ||
      isAborted(status);
}
