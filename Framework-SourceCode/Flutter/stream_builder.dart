enum ConnectionState {
  none, waiting, active, done,
}
class AsyncSnapshot<T> {


 const AsyncSnapshot._(this.connectionState, this.data, this.error, this.stackTrace)...
 const AsyncSnapshot.nothing() : this._(ConnectionState.none, null, null, null);
 const AsyncSnapshot.waiting() : this._(ConnectionState.waiting, null, null, null);
 const AsyncSnapshot.withData(ConnectionState state, T data) : this._(state, data, null, null);


 const AsyncSnapshot.withError(ConnectionState state, Object error,[ StackTrace stackTrace) :..
 final ConnectionState connectionState;


 final T? data;


 T get requireData {
   if (hasData) {
     return data!;
   }
   if (hasError) {
     Error.throwWithStackTrace(error!, stackTrace!);
   }
   throw StateError('Snapshot has neither data nor error');
 }
 final Object? error;
 final StackTrace? stackTrace;
 AsyncSnapshot<T> inState(ConnectionState state) =>  AsyncSnapshot<T>._(state, data, error, stackTrace);
 bool get hasData => data != null;
 bool get hasError => error != null;
}




abstract class StreamBuilderBase<T, S> extends StatefulWidget {
  /// Creates a [StreamBuilderBase] connected to the specified [stream].
  const StreamBuilderBase({super.key, required this.stream});

  final Stream<T>? stream;
  S initial();
  S afterConnected(S current) => current;
  S afterData(S current, T data);
  S afterError(S current, Object error, StackTrace stackTrace) => current;
  S afterDone(S current) => current;
  S afterDisconnected(S current) => current;
  Widget build(BuildContext context, S currentSummary);

  @override
  State<StreamBuilderBase<T, S>> createState() => _StreamBuilderBaseState<T, S>();
}

/// State for [StreamBuilderBase].
class _StreamBuilderBaseState<T, S> extends State<StreamBuilderBase<T, S>> {
  StreamSubscription<T>? _subscription;
  late S _summary;

  @override
  void initState() {
    super.initState();
    _summary = widget.initial();
    _subscribe();
  }

  @override
  void didUpdateWidget(StreamBuilderBase<T, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      if (_subscription != null) {
        _unsubscribe();
        _summary = widget.afterDisconnected(_summary);
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(context, _summary);

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (widget.stream != null) {
      _subscription = widget.stream!.listen(
        (T data) {
          setState(() {
            _summary = widget.afterData(_summary, data);
          });
        },
        onError: (Object error, StackTrace stackTrace) {
          setState(() {
            _summary = widget.afterError(_summary, error, stackTrace);
          });
        },
        onDone: () {
          setState(() {
            _summary = widget.afterDone(_summary);
          });
        },
      );
      _summary = widget.afterConnected(_summary);
    }
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
  }
}



class StreamBuilder<T> extends StreamBuilderBase<T, AsyncSnapshot<T>> {

  const StreamBuilder({super.key, this.initialData, required super.stream, required this.builder});

  final AsyncWidgetBuilder<T> builder;

  final T? initialData;

  @override
  AsyncSnapshot. initial() =>initialData == null  ? AsyncSnapshot.nothing() : AsyncSnapshot.withData(ConnectionState.none, initialData as T);

  @override
  AsyncSnapshot. afterConnected(AsyncSnapshot<T> current) =>current.inState(ConnectionState.waiting);

  @override
  AsyncSnapshot. afterData(AsyncSnapshot<T> current, T data)=>AsyncSnapshot<T>.withData(ConnectionState.active, data);
  
  @override
  AsyncSnapshot.afterError(AsyncSnapshot<T> current, Object error, StackTrace stackTrace)=> AsyncSnapshot<T>.withError(ConnectionState.active, error, stackTrace);

  @override
  AsyncSnapshot. afterDone(AsyncSnapshot<T> current) => current.inState(ConnectionState.done);

  @override
  AsyncSnapshot. afterDisconnected(AsyncSnapshot<T> current) =>  current.inState(ConnectionState.none);

  @override
  Widget build(BuildContext context, AsyncSnapshot<T> currentSummary) =>  builder(context, currentSummary);
}
