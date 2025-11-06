part of '../../core_presentation_logic.dart';
abstract class CoreController {
  Stream<bool> get isLoading;
  Stream<MessageToUi?> get statusMessage;
}
// CoreControllerMixin implementing CoreController properties
mixin CoreControllerMixin implements CoreController {
  final _isLoading = MutableStateFlow<bool>(false);
  final _statusMessage = MutableStateFlow<MessageToUi?>(null);

  // Expose as Streams to match CoreController
  @override
  Stream<bool> get isLoading => _isLoading.asStateFlow();

  @override
  Stream<MessageToUi?> get statusMessage => _statusMessage.asStateFlow();

  void startLoading() {
    _isLoading.update(true);
  }

  void stopLoading() {
    _isLoading.update(false);
  }

  void onException(Object exception) {
    if (exception is CustomException) {
      updateMessage(MessageToUi.error(exception.message));
    } else {
      updateMessage(MessageToUi.error("Something went wrong!"));
    }
  }

  void updateMessage(MessageToUi message) {
    _statusMessage.update(message);

    // Define base delay values
    const int minimumDelaySeconds = 3;
    const int lengthFactor = 8; // Factor to scale delay based on message length,
    //total delay=multiple of 8 +3 sec

    // Calculate dynamic delay based on message length
    int messageLength = message.message.length;
    int calculatedDelay = (messageLength / lengthFactor).ceil();
    int totalDelaySeconds = minimumDelaySeconds + calculatedDelay;

    Future.delayed(Duration(seconds: totalDelaySeconds), () {
      _statusMessage.update(null);
    });
  }

  void disposeCore() {
    _isLoading.dispose();
    _statusMessage.dispose();
  }
}
