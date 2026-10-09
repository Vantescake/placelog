import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/mobile_frame.dart';

void main() {
  runApp(const PlaceLogApp());
}

class PlaceLogApp extends StatelessWidget {
  const PlaceLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlaceLog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
      builder: (context, child) => MobileFrame(child: child!),
    );
  }
}
