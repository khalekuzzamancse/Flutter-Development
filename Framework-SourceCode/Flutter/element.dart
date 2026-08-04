
abstract class Element extends DiagnosticableTree implements BuildContext {
  Element(Widget widget) : _widget = widget {
    assert(debugMaybeDispatchCreated('widgets', 'Element', this));
  }

  Element? _parent;
  _NotificationNode? _notificationTree;



  Object? get slot => _slot;
  Object? _slot;

  int get depth {
    
    return _depth;
  }

  late int _depth;

  static int _sort(Element a, Element b) {
    final int diff = a.depth - b.depth;
        if (diff != 0) {
      return diff;
    }
            final bool isBDirty = b.dirty;
    if (a.dirty != isBDirty) {
      return isBDirty ? -1 : 1;
    }
        return 0;
  }

          static int _debugConcreteSubtype(Element element) {
    return element is StatefulElement
        ? 1
        : element is StatelessElement
        ? 2
        : 0;
  }

  @override
  Widget get widget => _widget!;
  Widget? _widget;

  @override
  bool get mounted => _widget != null;

 

  @override
  BuildOwner? get owner => _owner;
  BuildOwner? _owner;

  BuildScope get buildScope => _parentBuildScope!;

      BuildScope? _parentBuildScope;

  @mustCallSuper
  @protected
  void reassemble() {
    markNeedsBuild();
    visitChildren((Element child) {
      child.reassemble();
    });
  }

  

  RenderObject? get renderObject {
    Element? current = this;
    while (current != null) {
      if (current._lifecycleState == _ElementLifecycle.defunct) {
        break;
      } else if (current is RenderObjectElement) {
        return current.renderObject;
      } else {
        current = current.renderObjectAttachingChild;
      }
    }
    return null;
  }

  @protected
  Element? get renderObjectAttachingChild {
    Element? next;
    visitChildren((Element child) {
      assert(next == null);       next = child;
    });
    return next;
  }


  void visitChildren(ElementVisitor visitor) {}

  void debugVisitOnstageChildren(ElementVisitor visitor) =>
      visitChildren(visitor);

  @override
  void visitChildElements(ElementVisitor visitor) {
    assert(() {
      if (owner == null || !owner!._debugStateLocked) {
        return true;
      }
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('visitChildElements() called during build.'),
        ErrorDescription(
          "The BuildContext.visitChildElements() method can't be called during "
              'build because the child list is still being updated at that point, '
              'so the children might not be constructed yet, or might be old children '
              'that are going to be replaced.',
        ),
      ]);
    }());
    visitChildren(visitor);
  }

  @protected
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  Element? updateChild(Element? child, Widget? newWidget, Object? newSlot) {
    if (newWidget == null) {
      if (child != null) {
        deactivateChild(child);
      }
      return null;
    }

    final Element newChild;
    if (child != null) {
      bool hasSameSuperclass = true;
                                                                                                assert(() {
        final int oldElementClass = Element._debugConcreteSubtype(child);
        final int newWidgetClass = Widget._debugConcreteSubtype(newWidget);
        hasSameSuperclass = oldElementClass == newWidgetClass;
        return true;
      }());
      if (hasSameSuperclass && child.widget == newWidget) {
                                if (child.slot != newSlot) {
          updateSlotForChild(child, newSlot);
        }
        newChild = child;
      } else
      if (hasSameSuperclass && Widget.canUpdate(child.widget, newWidget)) {
        if (child.slot != newSlot) {
          updateSlotForChild(child, newSlot);
        }
        final bool isTimelineTracked = !kReleaseMode &&
            _isProfileBuildsEnabledFor(newWidget);
        if (isTimelineTracked) {
          Map<String, String>? debugTimelineArguments;
          assert(() {
            if (kDebugMode && debugEnhanceBuildTimelineArguments) {
              debugTimelineArguments =
                  newWidget.toDiagnosticsNode().toTimelineArguments();
            }
            return true;
          }());
          FlutterTimeline.startSync(
              '${newWidget.runtimeType}', arguments: debugTimelineArguments);
        }
        child.update(newWidget);
        if (isTimelineTracked) {
          FlutterTimeline.finishSync();
        }
        assert(child.widget == newWidget);
        assert(() {
          child.owner!._debugElementWasRebuilt(child);
          return true;
        }());
        newChild = child;
      } else {
        deactivateChild(child);
        assert(child._parent == null);
                                newChild = inflateWidget(newWidget, newSlot);
      }
    } else {
                        newChild = inflateWidget(newWidget, newSlot);
    }

    assert(() {
      if (child != null) {
        _debugRemoveGlobalKeyReservation(child);
      }
      final Key? key = newWidget.key;
      if (key is GlobalKey) {
        assert(owner != null);
        owner!._debugReserveGlobalKeyFor(this, newChild, key);
      }
      return true;
    }());

    return newChild;
  }

  @protected
  List<Element> updateChildren(List<Element> oldChildren,
      List<Widget> newWidgets, {
        Set<Element>? forgottenChildren,
        List<Object?>? slots,
      }) {
    assert(slots == null || newWidgets.length == slots.length);

    Element? replaceWithNullIfForgotten(Element child) {
      return (forgottenChildren?.contains(child) ?? false) ? null : child;
    }

    Object? slotFor(int newChildIndex, Element? previousChild) {
      return slots != null
          ? slots[newChildIndex]
          : IndexedSlot<Element?>(newChildIndex, previousChild);
    }

                
                            
                                                                    
    int newChildrenTop = 0;
    int oldChildrenTop = 0;
    int newChildrenBottom = newWidgets.length - 1;
    int oldChildrenBottom = oldChildren.length - 1;

    final List<Element> newChildren = List<Element>.filled(
      newWidgets.length,
      _NullElement.instance,
    );

    Element? previousChild;

        while ((oldChildrenTop <= oldChildrenBottom) &&
        (newChildrenTop <= newChildrenBottom)) {
      final Element? oldChild = replaceWithNullIfForgotten(
          oldChildren[oldChildrenTop]);
      final Widget newWidget = newWidgets[newChildrenTop];
      assert(oldChild == null ||
          oldChild._lifecycleState == _ElementLifecycle.active);
      if (oldChild == null || !Widget.canUpdate(oldChild.widget, newWidget)) {
        break;
      }
      final Element newChild =
      updateChild(oldChild, newWidget, slotFor(newChildrenTop, previousChild))!;
      assert(newChild._lifecycleState == _ElementLifecycle.active);
      newChildren[newChildrenTop] = newChild;
      previousChild = newChild;
      newChildrenTop += 1;
      oldChildrenTop += 1;
    }

        while ((oldChildrenTop <= oldChildrenBottom) &&
        (newChildrenTop <= newChildrenBottom)) {
      final Element? oldChild = replaceWithNullIfForgotten(
          oldChildren[oldChildrenBottom]);
      final Widget newWidget = newWidgets[newChildrenBottom];
      assert(oldChild == null ||
          oldChild._lifecycleState == _ElementLifecycle.active);
      if (oldChild == null || !Widget.canUpdate(oldChild.widget, newWidget)) {
        break;
      }
      oldChildrenBottom -= 1;
      newChildrenBottom -= 1;
    }

        final bool haveOldChildren = oldChildrenTop <= oldChildrenBottom;
    Map<Key, Element>? oldKeyedChildren;
    if (haveOldChildren) {
      oldKeyedChildren = <Key, Element>{};
      while (oldChildrenTop <= oldChildrenBottom) {
        final Element? oldChild = replaceWithNullIfForgotten(
            oldChildren[oldChildrenTop]);
        assert(oldChild == null ||
            oldChild._lifecycleState == _ElementLifecycle.active);
        if (oldChild != null) {
          if (oldChild.widget.key != null) {
            oldKeyedChildren[oldChild.widget.key!] = oldChild;
          } else {
            deactivateChild(oldChild);
          }
        }
        oldChildrenTop += 1;
      }
    }

        while (newChildrenTop <= newChildrenBottom) {
      Element? oldChild;
      final Widget newWidget = newWidgets[newChildrenTop];
      if (haveOldChildren) {
        final Key? key = newWidget.key;
        if (key != null) {
          oldChild = oldKeyedChildren![key];
          if (oldChild != null) {
            if (Widget.canUpdate(oldChild.widget, newWidget)) {
                                          oldKeyedChildren.remove(key);
            } else {
                            oldChild = null;
            }
          }
        }
      }
      assert(oldChild == null || Widget.canUpdate(oldChild.widget, newWidget));
      final Element newChild =
      updateChild(oldChild, newWidget, slotFor(newChildrenTop, previousChild))!;
      assert(newChild._lifecycleState == _ElementLifecycle.active);
      assert(
      oldChild == newChild ||
          oldChild == null ||
          oldChild._lifecycleState != _ElementLifecycle.active,
      );
      newChildren[newChildrenTop] = newChild;
      previousChild = newChild;
      newChildrenTop += 1;
    }

        assert(oldChildrenTop == oldChildrenBottom + 1);
    assert(newChildrenTop == newChildrenBottom + 1);
    assert(newWidgets.length - newChildrenTop ==
        oldChildren.length - oldChildrenTop);
    newChildrenBottom = newWidgets.length - 1;
    oldChildrenBottom = oldChildren.length - 1;

        while ((oldChildrenTop <= oldChildrenBottom) &&
        (newChildrenTop <= newChildrenBottom)) {
      final Element oldChild = oldChildren[oldChildrenTop];
      assert(replaceWithNullIfForgotten(oldChild) != null);
      assert(oldChild._lifecycleState == _ElementLifecycle.active);
      final Widget newWidget = newWidgets[newChildrenTop];
      assert(Widget.canUpdate(oldChild.widget, newWidget));
      final Element newChild =
      updateChild(oldChild, newWidget, slotFor(newChildrenTop, previousChild))!;
      assert(newChild._lifecycleState == _ElementLifecycle.active);
      assert(oldChild == newChild ||
          oldChild._lifecycleState != _ElementLifecycle.active);
      newChildren[newChildrenTop] = newChild;
      previousChild = newChild;
      newChildrenTop += 1;
      oldChildrenTop += 1;
    }

        if (haveOldChildren && oldKeyedChildren!.isNotEmpty) {
      for (final Element oldChild in oldKeyedChildren.values) {
        if (forgottenChildren == null ||
            !forgottenChildren.contains(oldChild)) {
          deactivateChild(oldChild);
        }
      }
    }
    assert(newChildren.every((Element element) => element is! _NullElement));
    return newChildren;
  }

  @mustCallSuper
  void mount(Element? parent, Object? newSlot) {
    assert(
    _lifecycleState == _ElementLifecycle.initial,
    'This element is no longer in its initial state (${_lifecycleState.name})',
    );
    assert(
    _parent == null,
    "This element already has a parent ($_parent) and it shouldn't have one yet.",
    );
    assert(
    parent == null || parent._lifecycleState == _ElementLifecycle.active,
    'Parent ($parent) should be null or in the active state (${parent
        ._lifecycleState.name})',
    );
    assert(slot ==
        null, "This element already has a slot ($slot) and it shouldn't");
    _parent = parent;
    _slot = newSlot;
    _lifecycleState = _ElementLifecycle.active;
    _depth = 1 + (_parent?.depth ?? 0);
    if (parent != null) {
                        _owner = parent.owner;
      _parentBuildScope = parent.buildScope;
    }
    assert(owner != null);
    final Key? key = widget.key;
    if (key is GlobalKey) {
      owner!._registerGlobalKey(key, this);
    }
    _updateInheritance();
    attachNotificationTree();
  }

  void _debugRemoveGlobalKeyReservation(Element child) {
    assert(owner != null);
    owner!._debugRemoveGlobalKeyReservationFor(this, child);
  }

  @mustCallSuper
  void update(covariant Widget newWidget) {
            assert(
    _lifecycleState == _ElementLifecycle.active &&
        newWidget != widget &&
        Widget.canUpdate(widget, newWidget),
    );
                        assert(() {
      _debugForgottenChildrenWithGlobalKey?.forEach(
          _debugRemoveGlobalKeyReservation);
      _debugForgottenChildrenWithGlobalKey?.clear();
      return true;
    }());
    _widget = newWidget;
  }

  @protected
  void updateSlotForChild(Element child, Object? newSlot) {
    assert(_lifecycleState == _ElementLifecycle.active);
    assert(child._parent == this);
    void visit(Element element) {
      element.updateSlot(newSlot);
      final Element? descendant = element.renderObjectAttachingChild;
      if (descendant != null) {
        visit(descendant);
      }
    }

    visit(child);
  }

  @protected
  @mustCallSuper
  void updateSlot(Object? newSlot) {
    assert(_lifecycleState == _ElementLifecycle.active);
    assert(_parent != null);
    assert(_parent!._lifecycleState == _ElementLifecycle.active);
    _slot = newSlot;
  }

  void _updateDepth(int parentDepth) {
    final int expectedDepth = parentDepth + 1;
    if (_depth < expectedDepth) {
      _depth = expectedDepth;
      visitChildren((Element child) {
        child._updateDepth(expectedDepth);
      });
    }
  }

  void _updateBuildScopeRecursively() {
    if (identical(buildScope, _parent?.buildScope)) {
      return;
    }
            _inDirtyList = false;
    _parentBuildScope = _parent?.buildScope;
    visitChildren((Element child) {
      child._updateBuildScopeRecursively();
    });
  }

  void detachRenderObject() {
    visitChildren((Element child) {
      child.detachRenderObject();
    });
    _slot = null;
  }

  void attachRenderObject(Object? newSlot) {
    assert(slot == null);
    visitChildren((Element child) {
      child.attachRenderObject(newSlot);
    });
    _slot = newSlot;
  }

  Element? _retakeInactiveElement(GlobalKey key, Widget newWidget) {
                            final Element? element = key._currentElement;
    if (element == null) {
      return null;
    }
    if (!Widget.canUpdate(element.widget, newWidget)) {
      return null;
    }
    assert(() {
      if (debugPrintGlobalKeyedWidgetLifecycle) {
        debugPrint(
          'Attempting to take $element from ${element._parent ??
              "inactive elements list"} to put in $this.',
        );
      }
      return true;
    }());
    final Element? parent = element._parent;
    if (parent != null) {
      assert(() {
        if (parent == this) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary(
                "A GlobalKey was used multiple times inside one widget's child list."),
            DiagnosticsProperty<GlobalKey>('The offending GlobalKey was', key),
            parent.describeElement(
                'The parent of the widgets with that key was'),
            element.describeElement(
                'The first child to get instantiated with that key became'),
            DiagnosticsProperty<Widget>(
              'The second child that was to be instantiated with that key was',
              widget,
              style: DiagnosticsTreeStyle.errorProperty,
            ),
            ErrorDescription(
              'A GlobalKey can only be specified on one widget at a time in the widget tree.',
            ),
          ]);
        }
        parent.owner!
            ._debugTrackElementThatWillNeedToBeRebuiltDueToGlobalKeyShenanigans(
          parent,
          key,
        );
        return true;
      }());
      parent.forgetChild(element);
      parent.deactivateChild(element);
    }
    assert(element._parent == null);
    owner!._inactiveElements.remove(element);
    return element;
  }

  @protected
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  Element inflateWidget(Widget newWidget, Object? newSlot) {
    final bool isTimelineTracked = !kReleaseMode &&
        _isProfileBuildsEnabledFor(newWidget);
    if (isTimelineTracked) {
      Map<String, String>? debugTimelineArguments;
      assert(() {
        if (kDebugMode && debugEnhanceBuildTimelineArguments) {
          debugTimelineArguments =
              newWidget.toDiagnosticsNode().toTimelineArguments();
        }
        return true;
      }());
      FlutterTimeline.startSync(
          '${newWidget.runtimeType}', arguments: debugTimelineArguments);
    }

    try {
      final Key? key = newWidget.key;
      if (key is GlobalKey) {
        final Element? newChild = _retakeInactiveElement(key, newWidget);
        if (newChild != null) {
          assert(newChild._parent == null);
          assert(() {
            _debugCheckForCycles(newChild);
            return true;
          }());
          try {
            newChild._activateWithParent(this, newSlot);
          } catch (_) {
                        try {
              deactivateChild(newChild);
            } catch (_) {
                          }
            rethrow;
          }
          final Element? updatedChild = updateChild(
              newChild, newWidget, newSlot);
          assert(newChild == updatedChild);
          return updatedChild!;
        }
      }
      final Element newChild = newWidget.createElement();
      assert(() {
        _debugCheckForCycles(newChild);
        return true;
      }());
      newChild.mount(this, newSlot);
      assert(newChild._lifecycleState == _ElementLifecycle.active);

      return newChild;
    } finally {
      if (isTimelineTracked) {
        FlutterTimeline.finishSync();
      }
    }
  }

  void _debugCheckForCycles(Element newChild) {
    assert(newChild._parent == null);
    assert(() {
      Element node = this;
      while (node._parent != null) {
        node = node._parent!;
      }
      assert(node != newChild);       return true;
    }());
  }

  @protected
  void deactivateChild(Element child) {
    assert(child._parent == this);
    child._parent = null;
    child.detachRenderObject();
    owner!._inactiveElements.add(
        child);     assert(() {
      if (debugPrintGlobalKeyedWidgetLifecycle) {
        if (child.widget.key is GlobalKey) {
          debugPrint('Deactivated $child (keyed child of $this)');
        }
      }
      return true;
    }());
  }

            @_debugOnly
  final Set<Element>? _debugForgottenChildrenWithGlobalKey = kDebugMode
      ? HashSet<Element>()
      : null;

  @protected
  @mustCallSuper
  void forgetChild(Element child) {
                            assert(() {
      if (child.widget.key is GlobalKey) {
        _debugForgottenChildrenWithGlobalKey?.add(child);
      }
      return true;
    }());
  }

  void _activateWithParent(Element parent, Object? newSlot) {
    assert(_lifecycleState == _ElementLifecycle.inactive);
    _parent = parent;
    _owner = parent.owner;
    assert(() {
      if (debugPrintGlobalKeyedWidgetLifecycle) {
        debugPrint('Reactivating $this (now child of $_parent).');
      }
      return true;
    }());
    _updateDepth(_parent!.depth);
    _updateBuildScopeRecursively();
    _activateRecursively(this);
    attachRenderObject(newSlot);
    assert(_lifecycleState == _ElementLifecycle.active);
  }

  static void _activateRecursively(Element element) {
    assert(element._lifecycleState == _ElementLifecycle.inactive);
    element.activate();
    assert(element._lifecycleState == _ElementLifecycle.active);
    element.visitChildren(_activateRecursively);
  }

  @mustCallSuper
  void activate() {
    assert(_lifecycleState == _ElementLifecycle.inactive);
    assert(owner != null);
    final bool hadDependencies =
        (_dependencies?.isNotEmpty ?? false) || _hadUnsatisfiedDependencies;
    _lifecycleState = _ElementLifecycle.active;
            _dependencies?.clear();
    _hadUnsatisfiedDependencies = false;
    _updateInheritance();
    attachNotificationTree();
    if (_dirty) {
      owner!.scheduleBuildFor(this);
    }
    if (hadDependencies) {
      didChangeDependencies();
    }
  }

  @mustCallSuper
  void deactivate() {
    assert(_lifecycleState == _ElementLifecycle.active);
    assert(_widget !=
        null);     if (_dependencies?.isNotEmpty ?? false) {
      for (final InheritedElement dependency in _dependencies!) {
        dependency.removeDependent(this);
      }
                                        }
    _inheritedElements = null;
    _lifecycleState = _ElementLifecycle.inactive;
  }

  @mustCallSuper
  void debugDeactivated() {
    assert(_lifecycleState == _ElementLifecycle.inactive);
  }

  @mustCallSuper
  void unmount() {
    assert(_lifecycleState == _ElementLifecycle.inactive);
    assert(_widget !=
        null);     assert(owner != null);
    assert(debugMaybeDispatchDisposed(this));
        final Key? key = _widget?.key;
    if (key is GlobalKey) {
      owner!._unregisterGlobalKey(key, this);
    }
            _widget = null;
    _dependencies = null;
    _lifecycleState = _ElementLifecycle.defunct;
  }

  bool debugExpectsRenderObjectForSlot(Object? slot) => true;

  @override
  RenderObject? findRenderObject() {
    assert(() {
      if (_lifecycleState != _ElementLifecycle.active) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('Cannot get renderObject of inactive element.'),
          ErrorDescription(
            'In order for an element to have a valid renderObject, it must be '
                'active, which means it is part of the tree.\n'
                'Instead, this element is in the $_lifecycleState state.\n'
                'If you called this method from a State object, consider guarding '
                'it with State.mounted.',
          ),
          describeElement(
              'The findRenderObject() method was called for the following element'),
        ]);
      }
      return true;
    }());
    return renderObject;
  }

  @override
  Size? get size {
    assert(() {
      if (_lifecycleState != _ElementLifecycle.active) {
                        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('Cannot get size of inactive element.'),
          ErrorDescription(
            'In order for an element to have a valid size, the element must be '
                'active, which means it is part of the tree.\n'
                'Instead, this element is in the $_lifecycleState state.',
          ),
          describeElement(
              'The size getter was called for the following element'),
        ]);
      }
      if (owner!._debugBuilding) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('Cannot get size during build.'),
          ErrorDescription(
            'The size of this render object has not yet been determined because '
                'the framework is still in the process of building widgets, which '
                'means the render tree for this frame has not yet been determined. '
                'The size getter should only be called from paint callbacks or '
                'interaction event handlers (e.g. gesture callbacks).',
          ),
          ErrorSpacer(),
          ErrorHint(
            'If you need some sizing information during build to decide which '
                'widgets to build, consider using a LayoutBuilder widget, which can '
                'tell you the layout constraints at a given location in the tree. See '
                '<https:                'for more details.',
          ),
          ErrorSpacer(),
          describeElement(
              'The size getter was called for the following element'),
        ]);
      }
      return true;
    }());
    final RenderObject? renderObject = findRenderObject();
    assert(() {
      if (renderObject == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('Cannot get size without a render object.'),
          ErrorHint(
            'In order for an element to have a valid size, the element must have '
                'an associated render object. This element does not have an associated '
                'render object, which typically means that the size getter was called '
                'too early in the pipeline (e.g., during the build phase) before the '
                'framework has created the render tree.',
          ),
          describeElement(
              'The size getter was called for the following element'),
        ]);
      }
      if (renderObject is RenderSliver) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('Cannot get size from a RenderSliver.'),
          ErrorHint(
            'The render object associated with this element is a '
                '${renderObject
                .runtimeType}, which is a subtype of RenderSliver. '
                'Slivers do not have a size per se. They have a more elaborate '
                'geometry description, which can be accessed by calling '
                'findRenderObject and then using the "geometry" getter on the '
                'resulting object.',
          ),
          describeElement(
              'The size getter was called for the following element'),
          renderObject.describeForError('The associated render sliver was'),
        ]);
      }
      if (renderObject is! RenderBox) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'Cannot get size from a render object that is not a RenderBox.'),
          ErrorHint(
            'Instead of being a subtype of RenderBox, the render object associated '
                'with this element is a ${renderObject
                .runtimeType}. If this type of '
                'render object does have a size, consider calling findRenderObject '
                'and extracting its size manually.',
          ),
          describeElement(
              'The size getter was called for the following element'),
          renderObject.describeForError('The associated render object was'),
        ]);
      }
      final RenderBox box = renderObject;
      if (!box.hasSize) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'Cannot get size from a render object that has not been through layout.'),
          ErrorHint(
            'The size of this render object has not yet been determined because '
                'this render object has not yet been through layout, which typically '
                'means that the size getter was called too early in the pipeline '
                '(e.g., during the build phase) before the framework has determined '
                'the size and position of the render objects during layout.',
          ),
          describeElement(
              'The size getter was called for the following element'),
          box.describeForError(
              'The render object from which the size was to be obtained was'),
        ]);
      }
      if (box.debugNeedsLayout) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
            'Cannot get size from a render object that has been marked dirty for layout.',
          ),
          ErrorHint(
            'The size of this render object is ambiguous because this render object has '
                'been modified since it was last laid out, which typically means that the size '
                'getter was called too early in the pipeline (e.g., during the build phase) '
                'before the framework has determined the size and position of the render '
                'objects during layout.',
          ),
          describeElement(
              'The size getter was called for the following element'),
          box.describeForError(
              'The render object from which the size was to be obtained was'),
          ErrorHint(
            'Consider using debugPrintMarkNeedsLayoutStacks to determine why the render '
                'object in question is dirty, if you did not expect this.',
          ),
        ]);
      }
      return true;
    }());
    if (renderObject is RenderBox) {
      return renderObject.size;
    }
    return null;
  }

  PersistentHashMap<Type, InheritedElement>? _inheritedElements;
  Set<InheritedElement>? _dependencies;
  bool _hadUnsatisfiedDependencies = false;

  bool _debugCheckStateIsActiveForAncestorLookup() {
    assert(() {
      if (_lifecycleState != _ElementLifecycle.active) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary("Looking up a deactivated widget's ancestor is unsafe."),
          ErrorDescription(
            "At this point the state of the widget's element tree is no longer "
                'stable.',
          ),
          ErrorHint(
            "To safely refer to a widget's ancestor in its dispose() method, "
                'save a reference to the ancestor by calling dependOnInheritedWidgetOfExactType() '
                "in the widget's didChangeDependencies() method.",
          ),
        ]);
      }
      return true;
    }());
    return true;
  }

  @protected
  bool doesDependOnInheritedElement(InheritedElement ancestor) {
    return _dependencies?.contains(ancestor) ?? false;
  }

  @override
  InheritedWidget dependOnInheritedElement(InheritedElement ancestor,
      {Object? aspect}) {
    _dependencies ??= HashSet<InheritedElement>();
    _dependencies!.add(ancestor);
    ancestor.updateDependencies(this, aspect);
    return ancestor.widget as InheritedWidget;
  }

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>(
      {Object? aspect}) {
    assert(_debugCheckStateIsActiveForAncestorLookup());
    final InheritedElement? ancestor = _inheritedElements?[T];
    if (ancestor != null) {
      return dependOnInheritedElement(ancestor, aspect: aspect) as T;
    }
    _hadUnsatisfiedDependencies = true;
    return null;
  }

  @override
  T? getInheritedWidgetOfExactType<T extends InheritedWidget>() {
    return getElementForInheritedWidgetOfExactType<T>()?.widget as T?;
  }

  @override
  InheritedElement? getElementForInheritedWidgetOfExactType<T extends InheritedWidget>() {
    assert(_debugCheckStateIsActiveForAncestorLookup());
    return _inheritedElements?[T];
  }

  @protected
  void attachNotificationTree() {
    _notificationTree = _parent?._notificationTree;
  }

  void _updateInheritance() {
    assert(_lifecycleState == _ElementLifecycle.active);
    _inheritedElements = _parent?._inheritedElements;
  }

  @override
  T? findAncestorWidgetOfExactType<T extends Widget>() {
    assert(_debugCheckStateIsActiveForAncestorLookup());
    Element? ancestor = _parent;
    while (ancestor != null && ancestor.widget.runtimeType != T) {
      ancestor = ancestor._parent;
    }
    return ancestor?.widget as T?;
  }

  @override
  T? findAncestorStateOfType<T extends State<StatefulWidget>>() {
    assert(_debugCheckStateIsActiveForAncestorLookup());
    Element? ancestor = _parent;
    while (ancestor != null) {
      if (ancestor is StatefulElement && ancestor.state is T) {
        break;
      }
      ancestor = ancestor._parent;
    }
    final StatefulElement? statefulAncestor = ancestor as StatefulElement?;
    return statefulAncestor?.state as T?;
  }

  @override
  T? findRootAncestorStateOfType<T extends State<StatefulWidget>>() {
    assert(_debugCheckStateIsActiveForAncestorLookup());
    Element? ancestor = _parent;
    StatefulElement? statefulAncestor;
    while (ancestor != null) {
      if (ancestor is StatefulElement && ancestor.state is T) {
        statefulAncestor = ancestor;
      }
      ancestor = ancestor._parent;
    }
    return statefulAncestor?.state as T?;
  }

  @override
  T? findAncestorRenderObjectOfType<T extends RenderObject>() {
    assert(_debugCheckStateIsActiveForAncestorLookup());
    Element? ancestor = _parent;
    while (ancestor != null) {
      if (ancestor is RenderObjectElement && ancestor.renderObject is T) {
        return ancestor.renderObject as T;
      }
      ancestor = ancestor._parent;
    }
    return null;
  }

  @override
  void visitAncestorElements(ConditionalElementVisitor visitor) {
    assert(_debugCheckStateIsActiveForAncestorLookup());
    Element? ancestor = _parent;
    while (ancestor != null && visitor(ancestor)) {
      ancestor = ancestor._parent;
    }
  }

  @mustCallSuper
  void didChangeDependencies() {
    assert(_lifecycleState ==
        _ElementLifecycle.active);     assert(_debugCheckOwnerBuildTargetExists('didChangeDependencies'));
    markNeedsBuild();
  }

  bool _debugCheckOwnerBuildTargetExists(String methodName) {
    assert(() {
      if (owner!._debugCurrentBuildTarget == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
            '$methodName for ${widget.runtimeType} was called at an '
                'inappropriate time.',
          ),
          ErrorDescription(
              'It may only be called while the widgets are being built.'),
          ErrorHint(
            'A possible cause of this error is when $methodName is called during '
                'one of:\n'
                ' * network I/O event\n'
                ' * file I/O event\n'
                ' * timer\n'
                ' * microtask (caused by Future.then, async/await, scheduleMicrotask)',
          ),
        ]);
      }
      return true;
    }());
    return true;
  }

  String debugGetCreatorChain(int limit) {
    final List<String> chain = <String>[];
    Element? node = this;
    while (chain.length < limit && node != null) {
      chain.add(node.toStringShort());
      node = node._parent;
    }
    if (node != null) {
      chain.add('\u22EF');
    }
    return chain.join(' \u2190 ');
  }

  List<Element> debugGetDiagnosticChain() {
    final List<Element> chain = <Element>[this];
    Element? node = _parent;
    while (node != null) {
      chain.add(node);
      node = node._parent;
    }
    return chain;
  }

  @override
  void dispatchNotification(Notification notification) {
    _notificationTree?.dispatchNotification(notification);
  }

  @override
  String toStringShort() =>
      _widget?.toStringShort() ?? '${describeIdentity(this)}(DEFUNCT)';

  @override
  DiagnosticsNode toDiagnosticsNode(
      {String? name, DiagnosticsTreeStyle? style}) {
    return _ElementDiagnosticableTreeNode(
        name: name, value: this, style: style);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.defaultDiagnosticsTreeStyle = DiagnosticsTreeStyle.dense;
    if (_lifecycleState != _ElementLifecycle.initial) {
      properties.add(
          ObjectFlagProperty<int>('depth', depth, ifNull: 'no depth'));
    }
    properties.add(
        ObjectFlagProperty<Widget>('widget', _widget, ifNull: 'no widget'));
    properties.add(
      DiagnosticsProperty<Key>(
        'key',
        _widget?.key,
        showName: false,
        defaultValue: null,
        level: DiagnosticLevel.hidden,
      ),
    );
    _widget?.debugFillProperties(properties);
    properties.add(FlagProperty('dirty', value: dirty, ifTrue: 'dirty'));
    final Set<InheritedElement>? deps = _dependencies;
    if (deps != null && deps.isNotEmpty) {
      final List<InheritedElement> sortedDependencies =
      deps.toList()
        ..sort(
              (InheritedElement a, InheritedElement b) =>
              a.toStringShort().compareTo(b.toStringShort()),
        );
      final List<DiagnosticsNode> diagnosticsDependencies =
      sortedDependencies
          .map(
            (InheritedElement element) =>
            element.widget.toDiagnosticsNode(
                style: DiagnosticsTreeStyle.sparse),
      )
          .toList();
      properties.add(
        DiagnosticsProperty<Set<InheritedElement>>(
          'dependencies',
          deps,
          description: diagnosticsDependencies.toString(),
        ),
      );
    }
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    final List<DiagnosticsNode> children = <DiagnosticsNode>[];
    visitChildren((Element child) {
      children.add(child.toDiagnosticsNode());
    });
    return children;
  }

  bool get dirty => _dirty;
  bool _dirty = true;

      bool _inDirtyList = false;

    bool _debugBuiltOnce = false;

  void markNeedsBuild() {
    assert(_lifecycleState != _ElementLifecycle.defunct);
    if (_lifecycleState != _ElementLifecycle.active) {
      return;
    }
    assert(owner != null);
    assert(_lifecycleState == _ElementLifecycle.active);
    assert(() {
      if (owner!._debugBuilding) {
        assert(owner!._debugCurrentBuildTarget != null);
        assert(owner!._debugStateLocked);
        if (_debugIsDescendantOf(owner!._debugCurrentBuildTarget!)) {
          return true;
        }
        final List<DiagnosticsNode> information = <DiagnosticsNode>[
          ErrorSummary('setState() or markNeedsBuild() called during build.'),
          ErrorDescription(
            'This ${widget
                .runtimeType} widget cannot be marked as needing to build because the framework '
                'is already in the process of building widgets. A widget can be marked as '
                'needing to be built during the build phase only if one of its ancestors '
                'is currently building. This exception is allowed because the framework '
                'builds parent widgets before children, which means a dirty descendant '
                'will always be built. Otherwise, the framework might not visit this '
                'widget during this build phase.',
          ),
          describeElement(
              'The widget on which setState() or markNeedsBuild() was called was'),
        ];
        if (owner!._debugCurrentBuildTarget != null) {
          information.add(
            owner!._debugCurrentBuildTarget!.describeWidget(
              'The widget which was currently being built when the offending call was made was',
            ),
          );
        }
        throw FlutterError.fromParts(information);
      } else if (owner!._debugStateLocked) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'setState() or markNeedsBuild() called when widget tree was locked.'),
          ErrorDescription(
            'This ${widget
                .runtimeType} widget cannot be marked as needing to build '
                'because the framework is locked.',
          ),
          describeElement(
              'The widget on which setState() or markNeedsBuild() was called was'),
        ]);
      }
      return true;
    }());
    if (dirty) {
      return;
    }
    _dirty = true;
    owner!.scheduleBuildFor(this);
  }

  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  void rebuild({bool force = false}) {
    assert(_lifecycleState != _ElementLifecycle.initial);
    if (_lifecycleState != _ElementLifecycle.active || (!_dirty && !force)) {
      return;
    }
    assert(() {
      debugOnRebuildDirtyWidget?.call(this, _debugBuiltOnce);
      if (debugPrintRebuildDirtyWidgets) {
        if (!_debugBuiltOnce) {
          debugPrint('Building $this');
          _debugBuiltOnce = true;
        } else {
          debugPrint('Rebuilding $this');
        }
      }
      return true;
    }());
    assert(_lifecycleState == _ElementLifecycle.active);
    assert(owner!._debugStateLocked);
    Element? debugPreviousBuildTarget;
    assert(() {
      debugPreviousBuildTarget = owner!._debugCurrentBuildTarget;
      owner!._debugCurrentBuildTarget = this;
      return true;
    }());
    try {
      performRebuild();
    } finally {
      assert(() {
        owner!._debugElementWasRebuilt(this);
        assert(owner!._debugCurrentBuildTarget == this);
        owner!._debugCurrentBuildTarget = debugPreviousBuildTarget;
        return true;
      }());
    }
    assert(!_dirty);
  }

  @protected
  @mustCallSuper
  void performRebuild() {
    _dirty = false;
  }
}