import '../../data/analytics/analytics_service.dart';
import '../../data/auth/auth_repository.dart';

/// Єдине місце, де екрани беруть репозиторії та сервіси.
///
/// У main.dart тут встановлюються реалізації на Firebase,
/// а в тестах — фейкові.
abstract final class AppServices {
  static late AuthRepository auth;
  static AnalyticsService analytics = const AnalyticsService.disabled();
}
