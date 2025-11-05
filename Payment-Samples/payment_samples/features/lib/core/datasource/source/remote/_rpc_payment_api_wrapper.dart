part of remote_data_source;

///Singleton
class RPCPaymentApiWrapper implements PaymentApi {
  late RPCPayCoreApi? _api;
  late String? _uti;
  late final className = runtimeType.toString();
  static final _instance = RPCPaymentApiWrapper._();
  static late RPCPayCoreApi Function() _factory;
  var _cancellable = true;
  static bool _connected = false;

  RPCPaymentApiWrapper._() {
    _consumeOnGoingState();
  }

  static final Map<String, PaymentConnectionObserver> _observers = {};

  static RPCPaymentApiWrapper getInstance(
      {required PaymentConnectionObserver listener,
      required RPCPayCoreApi Function() factory}) {
    _instance.registerAsListener(listener);
    _factory = factory;
    return _instance;
  }

  @override
  bool isConnected() {
    return _connected;
  }

  @override
  void registerAsListener(PaymentConnectionObserver listener) {
    final observerName = listener.runtimeType.toString();
    _observers[observerName] = listener;
    Logger.on('$className::registerAsListener', "observers: ${_observers.keys.join(', ')}");
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
    Logger.on('$className::unRegister', "observers: ${_observers.keys.join(', ')}");
  }

  Future<void> connectOrThrow(
      {required String ip,
      required String port,
      required String tid,
      required String pairCode}) async {
    _onEachConnectionObserver((listener) {
      listener.onConnecting();
    });
    try {
      _api = _factory();
      final api = _rpcApiOrThrow();
      final token = await api.pairRequestOrThrow(ip: ip, port: port, tid: tid, pairCode: pairCode);
      Logger.keyValueOn(className,'connect', 'auth-token',token);

      _onEachConnectionObserver((listener) {
        listener.onConnected();
      });
      _connected = true;
    } catch (e) {
      Logger.errorCaught(className, 'connectOrThrow()',e,null);
      _onEachConnectionObserver((listener) {
        listener.onDisconnected();
      });
      _connected = false;
      rethrow;
    }
  }

  @override
  Future<void> cancelTransaction() async {
    final api = _rpcApiOrThrow();
    await api.cancelRequestOrThrow();
    _consumeOnGoingState();
  }

  @override
  Future<void> disconnectOrThrow() async {
    Logger.on(className, 'disconnectOrThrow');
    _onEachConnectionObserver((listener) {
      listener.onDisconnected();
    });
    _connected = false;
  }

  @override
  void startTransaction(
      {required double amount,
      required double discount,
      required double cashback,
      required double gratuity}) async {
    _onEachPayEventObserver((listener) {
      listener.onTransactionRequesting();
    });

    try {
      final uti = await _rpcApiOrThrow().startTransactionOrThrow(
          amount: amount,
          discount: discount,
          cashback: cashback,
          gratuity: gratuity);
      _uti = uti;
      _consumeOnGoingState();
    } catch (e) {
      Logger.errorCaught(className, 'startTransaction()',e,null);
      _onEachConnectionObserver((listener) {
        listener.onError('Failed to start transaction');
      });
    }
  }

  ////async to avoid blocking call
  Future<void> _consumeOnGoingState() async {
    Logger.on(className, '_consumeOnGoingState');
    while (true) {
      try {
        final statues = await _rpcApiOrThrow()
            .readTransactionStatusOrThrow(uti: utiOrThrow());
        if (statues.isNotEmpty) {
          final status = statues.last;

          if (StatusHelper.isSuccess(status)) {
            _onEachPayEventObserver((listener) {
              listener.onTransactionSuccess();
            });
            break;
          } else if (StatusHelper.isCancelled(status)) {
            _onEachPayEventObserver((listener) {
              listener.onTransactionCancelled();
            });
            break;
          } else if (StatusHelper.isDisconnected(status)) {
            _onEachConnectionObserver((listener) {
              listener.onDisconnected();
            });
            break;
          } else if (StatusHelper.isError(status)) {
            _onEachConnectionObserver((listener) {
              listener.onError(status);
            });
            break;
          } else {
            _onEachPayEventObserver((listener) {
              listener.onTransactionInProgress(status,
                  cancellable: _cancellable);
            });
          }
          //after card disable should not be cancel
          final cardScreenDisplayed = (status == "GetCard Screen Displayed");
          if (cardScreenDisplayed) {
            _cancellable = false;
          }
        }
      } catch (e) {
        Logger.errorCaught(className, '_consumeOnGoingState()',e,null);
        break;
      }
      await delayInMs(100);
    }
  }

  RPCPayCoreApi _rpcApiOrThrow() {
    final snapshot = _api;
    if (snapshot == null) {
      throw CustomException(message: 'Pair code does not exits', debugMessage: className);
    }
    return snapshot;
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

  String utiOrThrow() {
    final snapshot = _uti;
    if (snapshot == null) {
      throw CustomException(message: 'Uti does not exits', debugMessage: className);
    }
    return snapshot;
  }
}
