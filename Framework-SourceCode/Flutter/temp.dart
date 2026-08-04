abstract class ComponentElement extends Element {
  ComponentElement(super.widget);

  Element? _child;

  bool _debugDoingBuild = false;

  @override
  bool get debugDoingBuild => _debugDoingBuild;

  @override
  Element? get renderObjectAttachingChild => _child;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    assert(_child == null);
    assert(_lifecycleState == _ElementLifecycle.active);
    _firstBuild();
    assert(_child != null);
  }

  void _firstBuild() {
    // StatefulElement overrides this to also call state.didChangeDependencies.
    rebuild(); // This eventually calls performRebuild.
  }

  @override
  @pragma('vm:notify-debugger-on-exception')
  void performRebuild() {
    Widget? built;
    try {
      assert(() {
        _debugDoingBuild = true;
        return true;
      }());
      built = build();
      assert(() {
        _debugDoingBuild = false;
        return true;
      }());
      debugWidgetBuilderValue(widget, built);
    } catch (e, stack) {
      _debugDoingBuild = false;
      built = ErrorWidget.builder(
        _reportException(
          ErrorDescription('building $this'),
          e,
          stack,
          informationCollector:
              () =>
          <DiagnosticsNode>[
            if (kDebugMode) DiagnosticsDebugCreator(DebugCreator(this))
          ],
        ),
      );
    } finally {
      // We delay marking the element as clean until after calling build() so
      // that attempts to markNeedsBuild() during build() will be ignored.
      super.performRebuild(); // clears the "dirty" flag
    }
    try {
      _child = updateChild(_child, built, slot);
      assert(_child != null);
    } catch (e, stack) {
      built = ErrorWidget.builder(
        _reportException(
          ErrorDescription('building $this'),
          e,
          stack,
          informationCollector:
              () =>
          <DiagnosticsNode>[
            if (kDebugMode) DiagnosticsDebugCreator(DebugCreator(this))
          ],
        ),
      );
      _child = updateChild(null, built, slot);
    }
  }

  @protected
  Widget build();

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_child != null) {
      visitor(_child!);
    }
  }

  @override
  void forgetChild(Element child) {
    assert(child == _child);
    _child = null;
    super.forgetChild(child);
  }
}