import 'package:features/payment_controller.dart';
import 'package:features/payment_repository_impl.dart';
import 'package:get/get.dart';
import '_payment_models.dart';
import '_payment_repository.dart';
import 'core/language/core_language.dart';

class CardPayControllerImpl implements CardPayController, PayEventObserver {
  PaymentRepository? _repository;

  @override
  Rx<SocketState> state = Rx(const SocketStateNone());
  late final className = runtimeType.toString();

  CardPayControllerImpl._() {
    _init();
  }

  void _init() {
    try {
      final type = 2;
      _repository = PaymentRepositoryImpl.create(type, this);
    } catch (e) {
      Logger.errorCaught(className, '_init()', e, null);
    }
  }

  void _onError(String message) {
    state.value = SocketState.error(message);
    state.refresh();
  }

  static CardPayController create() => CardPayControllerImpl._();

  @override
  bool isConnected() {
    try {
      final repo = _repositoryOrThrow();
      return repo.isConnected();
    } catch (e) {
      Logger.errorCaught(className, 'isConnected()', e, null);
      // ErrorController.showSnackBarOrSkip(e);
      return false;
    }
  }

  @override
  Future<void> cancelTransaction() async {
    try {
      final repo = _repositoryOrThrow();
      repo.cancelTransaction();
    } catch (e) {
      Logger.errorCaught(className, 'cancelTransaction()', e, null);
      //  ErrorController.showSnackBarOrSkip(e);
    }
  }

  @override
  void connect() async {
    try {
      final repo = _repositoryOrThrow();
    repo.connectRPC(ip: "ip", port: "port", tid: "tid", pairCode: "paircode");
    } catch (e) {
      Logger.errorCaught(className, 'connect()', e, null);
      //    ErrorController.showSnackBarOrSkip(e);
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      final repo = _repositoryOrThrow();
      repo.disconnectTry();
    } catch (e) {
      Logger.errorCaught(className, 'disconnect()', e, null);
      //     ErrorController.showSnackBarOrSkip(e);
    }
  }

  @override
  void dispose() async {
    try {
      final repo = _repositoryOrThrow();
      repo.unRegister();
    } catch (e) {
      Logger.errorCaught(className, 'dispose()', e, null);
      //   ErrorController.showSnackBarOrSkip(e);
    }
  }

  @override
  void observerEvent(PayEventObserver observer) async {
    try {
      final repo = _repositoryOrThrow();
      repo.register(observer);
    } catch (e) {
      Logger.errorCaught(className, 'observerEvent()', e, null);
   //   ErrorController.showSnackBarOrSkip(e);
    }
  }

  @override
  void startTransaction({
    required double amount,
    required double discount,
    required double cashback,
    required double gratuity,
  }) async {
    try {
      final repo = _repositoryOrThrow();
      repo.startTransaction(
        amount: amount,
        discount: discount,
        cashback: cashback,
        gratuity: gratuity,
      );
    } catch (e) {
      Logger.errorCaught(className, 'startTransaction()', e, null);
      //  ErrorController.showSnackBarOrSkip(e);
    }
  }

  PaymentRepository _repositoryOrThrow() {
    final snapshot = _repository;
    _init();
    if (snapshot == null) {
      _onError('Missing Repository');
      throw CustomException(
        message: 'Missing Repository',
        debugMessage: className,
      );
    }
    return snapshot;
  }

  @override
  onEvent(SocketState state) {
    Logger.off(
      className,
      method: 'onEvent',
      '${currentMinuteSecondMillisecond()}->$state',
    );
    this.state.value = state;
    this.state.refresh();
  }
}
