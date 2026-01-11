import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class NavigationHistoryObserver extends NavigatorObserver {
  static final NavigationHistoryObserver _instance =
  NavigationHistoryObserver._internal();

  factory NavigationHistoryObserver() => _instance;

  NavigationHistoryObserver._internal();

  final List<Route<dynamic>> _history = [];
  final List<Route<dynamic>> _popped = [];

  List<Route<dynamic>> get history => List.unmodifiable(_history);
  List<Route<dynamic>> get popped => List.unmodifiable(_popped);
  Route<dynamic>? get top => _history.isNotEmpty ? _history.last : null;
  Route<dynamic>? get lastPopped =>
      _popped.isNotEmpty ? _popped.last : null;

  final StreamController<HistoryChange> _controller =
  StreamController<HistoryChange>.broadcast();

  Stream<HistoryChange> get changes => _controller.stream;

  // ---------------------------------------------------------------------------
  // INTERNAL EMIT + SINGLE-LINE COLORED LOG
  // ---------------------------------------------------------------------------

  void _emit(
      NavigationStackAction action, {
        Route<dynamic>? newRoute,
        Route<dynamic>? oldRoute,
      }) {
    final event = HistoryChange(
      action: action,
      newRoute: newRoute,
      oldRoute: oldRoute,
      currentTop: top,
      history: history,
    );

    _controller.add(event);

    if (kReleaseMode) return;

    final color = {
      NavigationStackAction.push: '\x1B[32m',
      NavigationStackAction.pop: '\x1B[31m',
      NavigationStackAction.replace: '\x1B[33m',
      NavigationStackAction.remove: '\x1B[35m',
    }[action]!;

    debugPrint(
      '$color[NAV:${action.name.toUpperCase()}] '
          'new=${newRoute?.settings.name} | '
          'old=${oldRoute?.settings.name} | '
          'top=${event.currentTop?.settings.name} | '
          'stack=[${event.history.map((r) => r.settings.name).join(' → ')}]'
          '\x1B[0m',
    );
  }

  // ---------------------------------------------------------------------------
  // NAVIGATION EVENTS
  // ---------------------------------------------------------------------------

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _history.add(route);
    _popped.remove(route);
    _emit(NavigationStackAction.push,
        newRoute: route, oldRoute: previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _history.remove(route);
    _popped.add(route);
    _emit(NavigationStackAction.pop,
        newRoute: previousRoute, oldRoute: route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _history.remove(route);
    _emit(NavigationStackAction.remove,
        newRoute: route, oldRoute: previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null && newRoute != null) {
      final index = _history.indexOf(oldRoute);
      if (index != -1) _history[index] = newRoute;
    }
    _emit(NavigationStackAction.replace,
        newRoute: newRoute, oldRoute: oldRoute);
  }
}

// ---------------------------------------------------------------------------
// EVENT MODEL
// ---------------------------------------------------------------------------

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
  final Route<dynamic>? currentTop;
  final List<Route<dynamic>> history;
}

enum NavigationStackAction { push, pop, remove, replace }
