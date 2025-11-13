part of dart.async;

typedef void _TimerCallback();

abstract mixin class Stream<T> {
  const Stream();

  const factory Stream.empty({@Since("3.2") bool broadcast}) = _EmptyStream<T>;

  factory Stream.value(T value) =>
      (_AsyncStreamController<T>(null, null, null, null)
            .._add(value)
            .._closeUnchecked())
          .stream;

  factory Stream.error(Object error, [StackTrace? stackTrace]) {
    AsyncError(:error, :stackTrace) = _interceptUserError(error, stackTrace);
    return (_AsyncStreamController<T>(null, null, null, null)
          .._addError(error, stackTrace)
          .._closeUnchecked())
        .stream;
  }

  factory Stream.fromFuture(Future<T> future) {
    _StreamController<T> controller = _SyncStreamController<T>(
      null,
      null,
      null,
      null,
    );
    future.then(
      (value) {
        controller._add(value);
        controller._closeUnchecked();
      },
      onError: (error, stackTrace) {
        controller._addError(error, stackTrace);
        controller._closeUnchecked();
      },
    );
    return controller.stream;
  }

  factory Stream.fromFutures(Iterable<Future<T>> futures) {
    _StreamController<T> controller = _SyncStreamController<T>(
      null,
      null,
      null,
      null,
    );
    int count = 0;
    void onValue(T value) {
      if (!controller.isClosed) {
        controller._add(value);
        if (--count == 0) controller._closeUnchecked();
      }
    }

    void onError(Object error, StackTrace stack) {
      if (!controller.isClosed) {
        controller._addError(error, stack);
        if (--count == 0) controller._closeUnchecked();
      }
    }

    for (var future in futures) {
      count++;
      future.then(onValue, onError: onError);
    }
    if (count == 0) scheduleMicrotask(controller.close);
    return controller.stream;
  }

  factory Stream.fromIterable(Iterable<T> elements) =>
      Stream<T>.multi((controller) {
        Iterator<T> iterator;
        try {
          iterator = elements.iterator;
        } catch (e, s) {
          var error = _interceptCaughtError(e, s);
          controller.addError(error.error, error.stackTrace);
          controller.close();
          return;
        }
        var zone = Zone.current;
        var isScheduled = true;

        void next() {
          if (!controller.hasListener || controller.isPaused) {
            isScheduled = false;
            return;
          }
          bool hasNext;
          try {
            hasNext = iterator.moveNext();
          } catch (e, s) {
            var error = _interceptCaughtError(e, s);
            controller.addErrorSync(error.error, error.stackTrace);
            controller.closeSync();
            return;
          }
          if (hasNext) {
            try {
              controller.addSync(iterator.current);
            } catch (e, s) {
              var error = _interceptCaughtError(e, s);
              controller.addErrorSync(error.error, error.stackTrace);
            }
            if (controller.hasListener && !controller.isPaused) {
              zone.scheduleMicrotask(next);
            } else {
              isScheduled = false;
            }
          } else {
            controller.closeSync();
          }
        }

        controller.onResume = () {
          if (!isScheduled) {
            isScheduled = true;
            zone.scheduleMicrotask(next);
          }
        };

        zone.scheduleMicrotask(next);
      });

  factory Stream.multi(
    void Function(MultiStreamController<T>) onListen, {
    bool isBroadcast = false,
  }) {
    return _MultiStream<T>(onListen, isBroadcast);
  }

  factory Stream.periodic(
    Duration period, [
    T computation(int computationCount)?,
  ]) {
    if (computation == null && !typeAcceptsNull<T>()) {
      throw ArgumentError.value(
        null,
        "computation",
        "Must not be omitted when the event type is non-nullable",
      );
    }
    var controller = _SyncStreamController<T>(null, null, null, null);
    Stopwatch watch = Stopwatch();
    controller.onListen = () {
      int computationCount = 0;
      void sendEvent(_) {
        watch.reset();
        if (computation != null) {
          T event;
          try {
            event = computation(computationCount++);
          } catch (e, s) {
            var error = _interceptCaughtError(e, s);
            controller.addError(error.error, error.stackTrace);
            return;
          }
          controller.add(event);
        } else {
          controller.add(null as T);
        }
      }

      Timer timer = Timer.periodic(period, sendEvent);
      controller
        ..onCancel = () {
          timer.cancel();
          return Future._nullFuture;
        }
        ..onPause = () {
          watch.stop();
          timer.cancel();
        }
        ..onResume = () {
          Duration elapsed = watch.elapsed;
          watch.start();
          timer = Timer(period - elapsed, () {
            timer = Timer.periodic(period, sendEvent);
            sendEvent(null);
          });
        };
    };
    return controller.stream;
  }

  factory Stream.eventTransformed(
    Stream<dynamic> source,
    EventSink<dynamic> mapSink(EventSink<T> sink),
  ) {
    return _BoundSinkStream(source, mapSink);
  }

  static Stream<T> castFrom<S, T>(Stream<S> source) => CastStream<S, T>(source);

  bool get isBroadcast => false;

  Stream<T> asBroadcastStream({
    void onListen(StreamSubscription<T> subscription)?,
    void onCancel(StreamSubscription<T> subscription)?,
  }) {
    return _AsBroadcastStream<T>(this, onListen, onCancel);
  }

  StreamSubscription<T> listen(
    void onData(T event)?, {
    Function? onError,
    void onDone()?,
    bool? cancelOnError,
  });

  Stream<T> where(bool test(T event)) {
    return _WhereStream<T>(this, test);
  }

  Stream<S> map<S>(S convert(T event)) {
    return _MapStream<T, S>(this, convert);
  }

  Stream<E> asyncMap<E>(FutureOr<E> convert(T event)) {
    _StreamControllerBase<E> controller;
    if (isBroadcast) {
      controller = _SyncBroadcastStreamController<E>(null, null);
    } else {
      controller = _SyncStreamController<E>(null, null, null, null);
    }

    controller.onListen = () {
      StreamSubscription<T> subscription = this.listen(
        null,
        onError: controller._addError,
        onDone: controller.close,
      );
      FutureOr<Null> add(E value) {
        controller.add(value);
      }

      final addError = controller._addError;
      final resume = subscription.resume;
      subscription.onData((T event) {
        FutureOr<E> newValue;
        try {
          newValue = convert(event);
        } catch (e, s) {
          var error = _interceptCaughtError(e, s);
          controller.addError(error.error, error.stackTrace);
          return;
        }
        if (newValue is Future<E>) {
          subscription.pause();
          newValue.then(add, onError: addError).whenComplete(resume);
        } else {
          controller.add(newValue);
        }
      });
      controller.onCancel = subscript