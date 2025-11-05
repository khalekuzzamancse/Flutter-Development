part of core_language;

class BackGroundLogger implements ILogger {
  Isolate? _isolate;
  final _mainIsolateLooperProxy = ReceivePort();
  late final _mainIsolateMsgQueueProxy = _mainIsolateLooperProxy.sendPort;
  SendPort? _workerIsolateMsgQueueProxy;
  Future<void>? _isIsolateCreated;
  static int levelAll = 1;
  static int levelError = 2;
  static int levelDebug = 3;

  BackGroundLogger();

  late final tag = runtimeType.toString();

  @override
  void log(String tag, String msg) async {
    logCore(tag, msg, levelAll);
  }

  @override
  void errorCaught(String tag, String msg) {
    logCore(tag, msg, levelError);
  }

  @override
  void debug(String tag, String msg) {
    logCore(tag, msg, levelDebug);
  }

  void logCore(String tag, String msg, int level) async {
    if (_workerIsolateMsgQueueProxy == null) {
      await init();
    }
    final logLine = '[$tag]:$msg';
    _workerIsolateMsgQueueProxy!.send(Pair(logLine, level));
  }

   //@formatter:off
  static void onWorkerIsolate1stEvent(message) async {
    final firstMsg = message as FirstMessage;
    final SendPort mainIsolateMsgQueueProxy = firstMsg.sendPort;
    final workerIsolateLooperProxy = ReceivePort();

    mainIsolateMsgQueueProxy.send(workerIsolateLooperProxy.sendPort);

    final writerAll =  TextWriter.create(File(firstMsg.pathAllLog));
    final writerError = TextWriter.create(File(firstMsg.pathErrorLog));
    final writerDebug = TextWriter.create(File(firstMsg.pathDebugLog));

    workerIsolateLooperProxy.listen((msg) {
      final message=msg as Pair<String,int>;
      final level=message.second;
      final timeStamp='[${DateTime.now().toIso8601String()}]';
      final levelLog=getLevel(level);
      final log ='$timeStamp:$levelLog->${message.first}';
      _printConsole(log);
      writerAll.append(log);
      if(level==levelError){
        writerError.append(log);
      }
      if(level==levelDebug){
        writerDebug.append(log);
      }

    });
  }
  static String getLevel(int level){
    if(level==levelError){
      return '[ERROR]';
    }
    if(level==levelDebug){
      return '[DEBUG]';
    }
    return '';
  }

  Future<void> init() {
    if (_isIsolateCreated != null) return _isIsolateCreated!;
    _isIsolateCreated = _createIsolate();
    return _isIsolateCreated!;
  }

  //main isolate scope
  Future<void> _createIsolate() async {
    final completer = Completer<void>();
    _mainIsolateLooperProxy.listen((message) {
      //main isolate scope
      if (message is SendPort && _workerIsolateMsgQueueProxy == null) {
        _workerIsolateMsgQueueProxy = message;
        completer.complete();
      }
    });
    try{
      final directory = await DirectoryProvider.getLogFileDirectoryOrThrow();
      final firstMessage = FirstMessage(
          _mainIsolateMsgQueueProxy,
          pathAllLog: ILogger.fileNameLogAll(directory),
          pathDebugLog: ILogger.fileNameLogDebug(directory),
          pathErrorLog: ILogger.fileNameLogError((directory))
      );
      _isolate = await Isolate.spawn(onWorkerIsolate1stEvent, firstMessage, debugName: 'worker-1');
    }
    catch(_){

    }
    return completer.future;
  }

  static void _printConsole(String msg) {
    print(msg);
  }
}
class FirstMessage {
  final SendPort sendPort;
  final String pathAllLog, pathErrorLog, pathDebugLog;

  FirstMessage(this.sendPort,
      {required this.pathAllLog,
        required this.pathDebugLog,
        required this.pathErrorLog});
}
