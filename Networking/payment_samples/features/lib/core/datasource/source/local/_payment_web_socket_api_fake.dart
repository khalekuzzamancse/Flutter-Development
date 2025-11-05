

import '../../../language/core_language.dart';
import '../../api/apis.dart';
import '../remote/_payment_remote_api.dart';

final class PaymentFake extends PaymentWebSocketApiImpl {
  @override
  late final tag = runtimeType.toString();
  final duration = 2;
  bool _shouldSimulate = false;
  var _connected = false;
  static final Map<String, PaymentConnectionObserver> _observers = {};

  PaymentFake();

  @override
  void registerAsListener(PaymentConnectionObserver listener) {
    final observerName = listener.runtimeType.toString();
    _observers[observerName] = listener;
    Logger.on(
        '$tag::registerAsListener', "observers: ${_observers.keys.join(', ')}");
    if (isConnected()) {
      _onEachConnectionObserver((observer) {
        observer.onConnected();
      });
    }
  }

  @override
  void unregister(PaymentEventObserver listener) {
    final observerName = listener.runtimeType.toString();
    _observers.remove(observerName);
    Logger.on('$tag::unRegister', "observers: ${_observers.keys.join(', ')}");
  }
  @override
  void connectWebSocket({required String softwareHouseId, required String deviceUid, required String apiVersion, required String apiKey, required String tid}) {
    _connected=true;
    _onEachConnectionObserver((listener) {
      listener.onConnected();
    });
  }


  @override
  bool isConnected() => _connected;

  @override
  Future<void> cancelTransaction() async {
    _shouldSimulate = false;
    _onEachPayEventObserver((listener) {
      listener.onTransactionCancelled();
    });
  }

  void emitEventWithSuccess() =>
      _emitEvent(() async {
        _onEachPayEventObserver((listener) {
          listener.onTransactionSuccess();
        });
      });

  void emitEventWithCancel() =>
      _emitEvent(() async {
        _onEachPayEventObserver((listener) {
          listener.onTransactionCancelled();
        });
      });

  void emitEventWithError() =>
      _emitEvent(() async {
        _onEachPayEventObserver((listener) {
          listener.onError("An error was occurred");
        });
      });

  void _emitEvent(Future<void> Function() finalEvent) async {
    if (_shouldSimulate) {
      _onEachPayEventObserver((listener) {
        listener.onTransactionRequesting();
      });

      await delayInSecond(duration);
      final steps = [
            () =>
            _onEachPayEventObserver((listener) {
              listener.onTransactionInProgress('Started', cancellable: true);
            }),
            () =>
            _onEachPayEventObserver((listener) {
              listener.onTransactionInProgress(
                  'Card Pushed', cancellable: true);
            }),
            () =>
            _onEachPayEventObserver((listener) {
              listener.onTransactionInProgress(
                  'GetCard Screen Displayed', cancellable: false);
            }),

            () =>
            _onEachPayEventObserver((listener) {
              listener.onTransactionInProgress(
                  'Screen Displayed', cancellable: false);
            }),

            () => finalEvent()
      ];

      for (final step in steps) {
        if (!_shouldSimulate) return;
        step();
        await delayInSecond(duration);
      }
    }
  }


  @override
  Future<void> disconnectOrThrow() async {}

  @override
  void startTransaction({required double amount,
    required double discount,
    required double cashback,
    required double gratuity}) async {
    _shouldSimulate = true;
    emitEventWithSuccess();
  }


  void _onEachConnectionObserver(Function(PaymentConnectionObserver) callback) {
    for (final observer in _observers.values) {
      callback(observer);
    }
  }

  void _onEachPayEventObserver(Function(PaymentEventObserver) callback) {
    for (final observer in _observers.values) {
      if (observer is PaymentEventObserver) {
        callback(observer);
      }
    }
  }
}
