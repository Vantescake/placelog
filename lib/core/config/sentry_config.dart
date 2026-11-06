/// Налаштування Sentry: збір помилок у веб-версії замість Firebase Crashlytics,
/// який не підтримує Web.
///
/// DSN не є секретом: він лише вказує, у який проєкт Sentry надсилати події.
/// Його можна перевизначити під час запуску:
/// flutter run -d chrome --dart-define=SENTRY_DSN=https://...
abstract final class SentryConfig {
  static const dsn = String.fromEnvironment('SENTRY_DSN');

  /// Без DSN Sentry нічого не надсилає (наприклад, у тестах).
  static bool get isEnabled => dsn.isNotEmpty;
}
