import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/config/sentry_config.dart';
import 'core/routes/app_routes.dart';
import 'core/services/app_services.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/mobile_frame.dart';
import 'data/analytics/analytics_service.dart';
import 'data/auth/firebase_auth_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // SentryFlutter.init встановлює обробники FlutterError.onError
  // і PlatformDispatcher.instance.onError, тож необроблені помилки
  // (зокрема під час запуску) потрапляють у Sentry.
  await SentryFlutter.init(
    (options) {
      options.dsn = SentryConfig.dsn;
      options.environment = 'lab4';
      options.sendDefaultPii = false;
    },
    appRunner: _startApp,
  );
}

Future<void> _startApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  AppServices.auth = FirebaseAuthRepository();
  AppServices.analytics = AnalyticsService(FirebaseAnalytics.instance);

  runApp(SentryWidget(child: const PlaceLogApp()));
}

class PlaceLogApp extends StatelessWidget {
  const PlaceLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlaceLog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: AppRoutes.root,
      routes: AppRoutes.routes,
      navigatorObservers: AppServices.analytics.navigatorObservers,
      builder: (context, child) => MobileFrame(child: child!),
    );
  }
}
