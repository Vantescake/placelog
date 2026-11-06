/// Налаштування Sentry: збір помилок у веб-версії замість Firebase Crashlytics,
/// який не підтримує Web.
///
/// DSN не є секретом: він лише вказує, у який проєкт Sentry надсилати події.
/// Його можна перевизначити під час запуску:
/// flutter run -d chrome --dart-define=SENTRY_DSN=https://...
abstract final class SentryConfig {
  static const dsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: 'https://88f28742ddace729a2593cd9ffbbbad7'
        '@o4512384004718592.ingest.de.sentry.io/4512384231800912',
  );

  /// Без DSN Sentry нічого не надсилає.
  static bool get isEnabled => dsn.isNotEmpty;
}
