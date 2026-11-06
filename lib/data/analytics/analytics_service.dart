import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

/// Обгортка над Firebase Analytics.
///
/// [AnalyticsService.disabled] нічого не надсилає: використовується в тестах.
class AnalyticsService {
  final FirebaseAnalytics? _analytics;

  AnalyticsService(FirebaseAnalytics analytics) : _analytics = analytics;

  const AnalyticsService.disabled() : _analytics = null;

  /// Спостерігач Navigator: реєструє screen_view для іменованих маршрутів.
  List<NavigatorObserver> get navigatorObservers => [
        if (_analytics != null) FirebaseAnalyticsObserver(analytics: _analytics),
      ];

  Future<void> logScreen(String name) async =>
      _analytics?.logScreenView(screenName: name);

  Future<void> logLogin() async => _analytics?.logLogin(loginMethod: 'email');

  Future<void> logSignUp() async =>
      _analytics?.logSignUp(signUpMethod: 'email');

  /// Власна подія з параметрами.
  Future<void> logEvent(String name, [Map<String, Object>? parameters]) async =>
      _analytics?.logEvent(name: name, parameters: parameters);
}
