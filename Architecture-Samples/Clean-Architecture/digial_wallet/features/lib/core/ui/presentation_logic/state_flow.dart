part of '../../core_presentation_logic.dart';


/// A simple caching stream controller, inspired by RxDart's `BehaviorSubject` and Kotlin’s `MutableStateFlow`,
/// designed to emit the latest value to new subscribers and prevent unwanted behavior caused by missing initial events.
///
/// Unlike a standard Dart `StreamController`, which does not cache the latest emitted value, this class provides
/// a mechanism to store and emit the latest value to new subscribers, ensuring consistency even if they subscribe late.
///
/// ### Problem Context
/// In a standard `StreamController`, any event emitted while there are no subscribers is discarded. This design makes
/// it difficult to decide the exact point at which a subscription should be added, particularly in cases where both
/// the latest and upcoming events are needed. Mismanagement of the subscription point can lead to unintended behaviors,
/// such as a progress bar not appearing due to missing a `startLoading` event that occurred before the subscription.
///
/// ### Solution
/// By caching the latest event, `MutableStateFlow` ensures that subscribers receive the most recent value immediately upon
/// subscribing, eliminating the need to control the subscription timing precisely and helping avoid missed updates.
/// This simple caching mechanism is achieved without external dependencies like RxDart, focusing instead on the
/// basic requirements of state caching and delivery.
///
/// ### Implementation
/// - Initializes with an optional initial value.
/// - On subscription, emits the latest cached value (if available) to the new subscriber immediately.
/// - Allows new values to be added via the `update` method, which both caches and emits the latest value to all active subscribers.
/// - The `dispose` method closes the controller to free up resources.
///
/// ### Usage Example
/// ```dart
/// final loadingState = MutableStateFlow<bool>(false);
/// loadingState.update(true); // Start loading
///
/// loadingState.asStateFlow().listen((isLoading) {
///   print(isLoading ? "Loading..." : "Not Loading");
/// });
///
/// loadingState.update(false); // Stop loading
/// loadingState.dispose();
/// ```
///
/// This class is ideal for scenarios where caching the last emitted value is necessary for consistent state tracking,
/// such as UI loading states, without needing an external library dependency.
///
/// **Caution**: This is an early-stage implementation and should be used carefully, as it may change in future iterations.
class MutableStateFlow<T> {
  final _controller = StreamController<T>.broadcast();
  T? _latestValue;

  /// Initializes the `MutableStateFlow` with an optional initial value.
  /// If an initial value is provided, it will be immediately emitted to any new subscriber upon subscription.
  MutableStateFlow([this._latestValue]) {
    _controller.onListen = () {
      if (_latestValue != null) {
        _controller.sink.add(_latestValue!);
      }
    };
  }

  /// Returns the cached stream which emits the latest value to new subscribers immediately on subscription.
  Stream<T> asStateFlow() => _controller.stream;

  /// Updates the state with a new value, which is then cached and emitted to all active subscribers.
  void update(T newValue) {
    try{
      _latestValue = newValue;
      _controller.sink.add(_latestValue!);
    }
    catch(e){

    }

  }

  /// Disposes of the stream controller, closing all active connections.
  void dispose() {
    _controller.close();
  }
}
