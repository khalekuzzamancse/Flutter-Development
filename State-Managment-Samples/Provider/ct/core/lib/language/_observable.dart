part of core_language;
///Immutable
abstract interface class Observable<T>{
   T value();
  void listenWithName( String name,  void Function(T) listener);
   void listen(void Function(T) listener);
  void unregisterListener( String name);
}

class ObservableMutable<T> implements Observable<T> {
  T _value;
  final Map<String, List<void Function(T)>> _namedListeners = {};
  final  List<void Function(T)> _unNamedListener = [];
  ObservableMutable(this._value);

  @override
  T value() => _value;


  void updateWith(T value) {
    if (_value != value) {
      _value = value;
      for (final group in _namedListeners.values) {
        for (final listener in List.from(group)) {
          listener(_value);
        }
      }
      for (final listener in _unNamedListener) {
        listener(_value);
      }
    }
  }
  void update(T Function(T current) transform) {
    final newValue = transform(_value);
    if (_value != newValue) {
      _value = newValue;
      for (final group in _namedListeners.values) {
        for (final listener in List.from(group)) {
          listener(_value);
        }
      }
      for (final listener in _unNamedListener) {
        listener(_value);
      }
    }
  }

  @override
  void listenWithName(String name, void Function(T) listener) {
    _namedListeners.putIfAbsent(name, () => []).add(listener);
    listener(_value);
  }
  @override
  void listen(void Function(T) listener) {
    _unNamedListener.add(listener);
    listener(_value);
  }

  @override
  void unregisterListener(String name) {
    _namedListeners.remove(name);
  }

  void dispose() => _namedListeners.clear();

  Observable<T> asImmutable() => this;
}

