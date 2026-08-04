// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// @docImport 'value_listenable_builder.dart';
library;

import 'dart:async' show StreamSubscription;

import 'package:flutter/foundation.dart';

import 'framework.dart';


abstract class StreamBuilderBase<T, S> extends StatefulWidget {
  /// Creates a [StreamBuilderBase] connected to the specified [stream].
  const StreamBuilderBase({super.key, required this.stream});

  /// The asynchronous computation to which this builder is currently connected,
  /// possibly null. When changed, the current summary is updated using
  /// [afterDisconnected], if the previous stream was not null, followed by
  /// [afterConnected], if the new stream is not null.
  final Stream<T>? stream;

  /// Returns the initial summary of stream interaction, typically representing
  /// the fact that no interaction has happened at all.
  ///
  /// Sub-classes must override this method to provide the initial value for
  /// the fold computation.
  S initial();

  /// Returns an updated version of the [current] summary reflecting that we
  /// are now connected to a stream.
  ///
  /// The default implementation returns [current] as is.
  S afterConnected(S current) => current;

  /// Returns an updated version of the [current] summary following a data event.
  ///
  /// Sub-classes must override this method to specify how the current summary
  /// is combined with the new data item in the fold computation.
  S afterData(S current, T data);

  /// Returns an updated version of the [current] summary following an error
  /// with a stack trace.
  ///
  /// The default implementation returns [current] as is.
  S afterError(S current, Object error, StackTrace stackTrace) => current;

  /// Returns an updated version of the [current] summary following stream
  /// termination.
  ///
  /// The default implementation returns [current] as is.
  S afterDone(S current) => current;

  /// Returns an updated version of the [current] summary reflecting that we
  /// are no longer connected to a stream.
  ///
  /// The default implementation returns [current] as is.
  S afterDisconnected(S current) => current;

  /// Returns a Widget based on the [currentSummary].
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

/// The state of connection to an asynchronous computation.
///
/// The usual flow of state is as follows:
///
/// 1. [none], maybe with some initial data.
/// 2. [waiting], indicating that the asynchronous operation has begun,
///    typically with the data being null.
/// 3. [active], with data being non-null, and possible changing over time.
/// 4. [done], with data being non-null.
///
/// See also:
///
///  * [AsyncSnapshot], which augments a connection state with information
///    received from the asynchronous computation.
enum ConnectionState {
  /// Not currently connected to any asynchronous computation.
  ///
  /// For example, a [FutureBuilder] whose [FutureBuilder.future] is null.
  none,

  /// Connected to an asynchronous computation and awaiting interaction.
  waiting,

  /// Connected to an active asynchronous computation.
  ///
  /// For example, a [Stream] that has returned at least one value, but is not
  /// yet done.
  active,

  /// Connected to a terminated asynchronous computation.
  done,
}

/// Immutable representation of the most recent interaction with an asynchronous
/// computation.
///
/// See also:
///
///  * [StreamBuilder], which builds itself based on a snapshot from interacting
///    with a [Stream].
///  * [FutureBuilder], which builds itself based on a snapshot from interacting
///    with a [Future].
@immutable
class AsyncSnapshot<T> {
  /// Creates an [AsyncSnapshot] with the specified [connectionState],
  /// and optionally either [data] or [error] with an optional [stackTrace]
  /// (but not both data and error).
  const AsyncSnapshot._(this.connectionState, this.data, this.error, this.stackTrace)
    : assert(data == null || error == null),
      assert(stackTrace == null || error != null);

  /// Creates an [AsyncSnapshot] in [ConnectionState.none] with null data and error.
  const AsyncSnapshot.nothing() : this._(ConnectionState.none, null, null, null);

  /// Creates an [AsyncSnapshot] in [ConnectionState.waiting] with null data and error.
  const AsyncSnapshot.waiting() : this._(ConnectionState.waiting, null, null, null);

  /// Creates an [AsyncSnapshot] in the specified [state] and with the specified [data].
  const AsyncSnapshot.withData(ConnectionState state, T data) : this._(state, data, null, null);

  /// Creates an [AsyncSnapshot] in the specified [state] with the specified [error]
  /// and a [stackTrace].
  ///
  /// If no [stackTrace] is explicitly specified, [StackTrace.empty] will be used instead.
  const AsyncSnapshot.withError(
    ConnectionState state,
    Object error, [
    StackTrace stackTrace = StackTrace.empty,
  ]) : this._(state, null, error, stackTrace);

  /// Current state of connection to the asynchronous computation.
  final ConnectionState connectionState;

  /// The latest data received by the asynchronous computation.
  ///
  /// If this is non-null, [hasData] will be true.
  ///
  /// If [error] is not null, this will be null. See [hasError].
  ///
  /// If the asynchronous computation has never returned a value, this may be
  /// set to an initial data value specified by the relevant widget. See
  /// [FutureBuilder.initialData] and [StreamBuilder.initialData].
  final T? data;

  /// Returns latest data received, failing if there is no data.
  ///
  /// Throws [error], if [hasError]. Throws [StateError], if neither [hasData]
  /// nor [hasError].
  T get requireData {
    if (hasData) {
      return data!;
    }
    if (hasError) {
      Error.throwWithStackTrace(error!, stackTrace!);
    }
    throw StateError('Snapshot has neither data nor error');
  }

  /// The latest error object received by the asynchronous computation.
  ///
  /// If this is non-null, [hasError] will be true.
  ///
  /// If [data] is not null, this will be null.
  final Object? error;

  /// The latest stack trace object received by the asynchronous computation.
  ///
  /// This will not be null iff [error] is not null. Consequently, [stackTrace]
  /// will be non-null when [hasError] is true.
  ///
  /// However, even when not null, [stackTrace] might be empty. The stack trace
  /// is empty when there is an error but no stack trace has been provided.
  final StackTrace? stackTrace;

  /// Returns a snapshot like this one, but in the specified [state].
  ///
  /// The [data], [error], and [stackTrace] fields persist unmodified, even if
  /// the new state is [ConnectionState.none].
  AsyncSnapshot<T> inState(ConnectionState state) =>
      AsyncSnapshot<T>._(state, data, error, stackTrace);

  /// Returns whether this snapshot contains a non-null [data] value.
  ///
  /// This can be false even when the asynchronous computation has completed
  /// successfully, if the computation did not return a non-null value. For
  /// example, a [Future<void>] will complete with the null value even if it
  /// completes successfully.
  bool get hasData => data != null;

  /// Returns whether this snapshot contains a non-null [error] value.
  ///
  /// This is always true if the asynchronous computation's last result was
  /// failure.
  bool get hasError => error != null;

  @override
  String toString() =>
      '${objectRuntimeType(this, 'AsyncSnapshot')}($connectionState, $data, $error, $stackTrace)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AsyncSnapshot<T> &&
        other.connectionState == connectionState &&
        other.data == data &&
        other.error == error &&
        other.stackTrace == stackTrace;
  }

  @override
  int get hashCode => Object.hash(connectionState, data, error);
}

/// Signature for strategies that build widgets based on asynchronous
/// interaction.
///
/// See also:
///
///  * [StreamBuilder], which delegates to an [AsyncWidgetBuilder] to build
///    itself based on a snapshot from interacting with a [Stream].
///  * [FutureBuilder], which delegates to an [AsyncWidgetBuilder] to build
///    itself based on a snapshot from interacting with a [Future].
typedef AsyncWidgetBuilder<T> = Widget Function(BuildContext context, AsyncSnapshot<T> snapshot);

/// Widget that builds itself based on the latest snapshot of interaction with
/// a [Stream].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=MkKEWHfy99Y}
///
/// ## Managing the stream
///
/// The [stream] must have been obtained earlier, e.g. during [State.initState],
/// [State.didUpdateWidget], or [State.didChangeDependencies]. It must not be
/// created during the [State.build] or [StatelessWidget.build] method call when
/// constructing the [StreamBuilder]. If the [stream] is created at the same
/// time as the [StreamBuilder], then every time the [StreamBuilder]'s parent is
/// rebuilt, the asynchronous task will be restarted.
///
/// A general guideline is to assume that every `build` method could get called
/// every frame, and to treat omitted calls as an optimization.
///
/// ## Timing
///
/// Widget rebuilding is scheduled by each interaction, using [State.setState],
/// but is otherwise decoupled from the timing of the stream. The [builder]
/// is called at the discretion of the Flutter pipeline, and will thus receive a
/// timing-dependent sub-sequence of the snapshots that represent the
/// interaction with the stream.
///
/// As an example, when interacting with a stream producing the integers
/// 0 through 9, the [builder] may be called with any ordered sub-sequence
/// of the following snapshots that includes the last one (the one with
/// ConnectionState.done):
///
/// * `AsyncSnapshot<int>.withData(ConnectionState.waiting, null)`
/// * `AsyncSnapshot<int>.withData(ConnectionState.active, 0)`
/// * `AsyncSnapshot<int>.withData(ConnectionState.active, 1)`
/// * ...
/// * `AsyncSnapshot<int>.withData(ConnectionState.active, 9)`
/// * `AsyncSnapshot<int>.withData(ConnectionState.done, 9)`
///
/// The actual sequence of invocations of the [builder] depends on the relative
/// timing of events produced by the stream and the build rate of the Flutter
/// pipeline.
///
/// Changing the [StreamBuilder] configuration to another stream during event
/// generation introduces snapshot pairs of the form:
///
/// * `AsyncSnapshot<int>.withData(ConnectionState.none, 5)`
/// * `AsyncSnapshot<int>.withData(ConnectionState.waiting, 5)`
///
/// The latter will be produced only when the new stream is non-null, and the
/// former only when the old stream is non-null.
///
/// The stream may produce errors, resulting in snapshots of the form:
///
/// * `AsyncSnapshot<int>.withError(ConnectionState.active, 'some error', someStackTrace)`
///
/// The data and error fields of snapshots produced are only changed when the
/// state is `ConnectionState.active`.
///
/// The initial snapshot data can be controlled by specifying [initialData].
/// This should be used to ensure that the first frame has the expected value,
/// as the builder will always be called before the stream listener has a chance
/// to be processed.
///
/// {@tool dartpad}
/// This sample shows a [StreamBuilder] that listens to a Stream that emits bids
/// for an auction. Every time the StreamBuilder receives a bid from the Stream,
/// it will display the price of the bid below an icon. If the Stream emits an
/// error, the error is displayed below an error icon. When the Stream finishes
/// emitting bids, the final price is displayed.
///
/// ** See code in examples/api/lib/widgets/async/stream_builder.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [ValueListenableBuilder], which wraps a [ValueListenable] instead of a
///    [Stream].
///  * [StreamBuilderBase], which supports widget building based on a computation
///    that spans all interactions made with the stream.
class StreamBuilder<T> extends StreamBuilderBase<T, AsyncSnapshot<T>> {
  /// Creates a new [StreamBuilder] that builds itself based on the latest
  /// snapshot of interaction with the specified [stream] and whose build
  /// strategy is given by [builder].
  ///
  /// The [initialData] is used to create the initial snapshot.
  const StreamBuilder({super.key, this.initialData, required super.stream, required this.builder});

  /// The build strategy currently used by this builder.
  ///
  /// This builder must only return a widget and should not have any side
  /// effects as it may be called multiple times.
  final AsyncWidgetBuilder<T> builder;

  /// The data that will be used to create the initial snapshot.
  ///
  /// Providing this value (presumably obtained synchronously somehow when the
  /// [Stream] was created) ensures that the first frame will show useful data.
  /// Otherwise, the first frame will be built with the value null, regardless
  /// of whether a value is available on the stream: since streams are
  /// asynchronous, no events from the stream can be obtained before the initial
  /// build.
  final T? initialData;

  @override
  AsyncSnapshot<T> initial() =>
      initialData == null
          ? AsyncSnapshot<T>.nothing()
          : AsyncSnapshot<T>.withData(ConnectionState.none, initialData as T);

  @override
  AsyncSnapshot<T> afterConnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.waiting);

  @override
  AsyncSnapshot<T> afterData(AsyncSnapshot<T> current, T data) {
    return AsyncSnapshot<T>.withData(ConnectionState.active, data);
  }

  @override
  AsyncSnapshot<T> afterError(AsyncSnapshot<T> current, Object error, StackTrace stackTrace) {
    return AsyncSnapshot<T>.withError(ConnectionState.active, error, stackTrace);
  }

  @override
  AsyncSnapshot<T> afterDone(AsyncSnapshot<T> current) => current.inState(ConnectionState.done);

  @override
  AsyncSnapshot<T> afterDisconnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.none);

  @override
  Widget build(BuildContext context, AsyncSnapshot<T> currentSummary) =>
      builder(context, currentSummary);
}
