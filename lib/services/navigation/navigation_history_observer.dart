import 'dart:async';
import 'package:flutter/widgets.dart';

/// A modern, safe, dependency-free navigation history observer.
/// Tracks pushes, pops, replaces, removes, and exposes a real-time event stream.
class NavigationHistoryObserver extends NavigatorObserver {
  static final NavigationHistoryObserver _instance =
  NavigationHistoryObserver._internal();

  factory NavigationHistoryObserver() => _instance;

  NavigationHistoryObserver._internal();

  // Internal route stacks
  final List<Route<dynamic>> _history = [];
  final List<Route<dynamic>> _popped = [];

  // ---------------------------------------------------------------------------
  // Public Getters (Immutable Views)
  // ---------------------------------------------------------------------------

  /// All routes currently in the navigation stack
  List<Route<dynamic>> get history => List.unmodifiable(_history);

  /// Routes that were popped previously (most recent last)
  List<Route<dynamic>> get popped => List.unmodifiable(_popped);

  /// The current top (visible) route
  Route<dynamic>? get top => _history.isNotEmpty ? _history.last : null;

  /// The last route that was popped
  Route<dynamic>? get lastPopped =>
      _popped.isNotEmpty ? _popped.last : null;

  // ---------------------------------------------------------------------------
  // Stream for real-time event listeners
  // ---------------------------------------------------------------------------

  final StreamController<HistoryChange> _controller =
  StreamController<HistoryChange>.broadcast();

  /// A broadcast stream emitting updates for push/pop/replace/remove.
  Stream<HistoryChange> get changes => _controller.stream;

  void _emit(NavigationStackAction action,
      {Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _controller.add(
      HistoryChange(
        action: action,
        newRoute: newRoute,
        oldRoute: oldRoute,
        currentTop: top,
        history: history,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // OVERRIDDEN NAVIGATION EVENTS
  // ---------------------------------------------------------------------------

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _history.add(route);
    _popped.remove(route);

    _emit(
      NavigationStackAction.push,
      newRoute: route,
      oldRoute: previousRoute,
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_history.isNotEmpty) {
      _popped.add(_history.last);
      _history.removeLast();
    }

    _emit(
      NavigationStackAction.pop,
      newRoute: route,
      oldRoute: previousRoute,
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _history.remove(route);

    _emit(
      NavigationStackAction.remove,
      newRoute: route,
      oldRoute: previousRoute,
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null && newRoute != null) {
      final index = _history.indexOf(oldRoute);

      if (index != -1) {
        _history[index] = newRoute;
      }
    }

    _emit(
      NavigationStackAction.replace,
      newRoute: newRoute,
      oldRoute: oldRoute,
    );
  }
}

// ---------------------------------------------------------------------------
// Event Model
// ---------------------------------------------------------------------------

/// Rich event information for navigation history changes.
class HistoryChange {
  HistoryChange({
    required this.action,
    this.newRoute,
    this.oldRoute,
    this.currentTop,
    required this.history,
  });

  final NavigationStackAction action;
  final Route<dynamic>? newRoute;
  final Route<dynamic>? oldRoute;

  /// The top-most visible route after this event
  final Route<dynamic>? currentTop;

  /// Full immutable navigation history at event time
  final List<Route<dynamic>> history;
}

enum NavigationStackAction {
  push,
  pop,
  remove,
  replace,
}
