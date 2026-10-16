import 'package:flutter/material.dart';

import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/main/main_shell.dart';
import '../../features/profile/screens/change_password_screen.dart';

/// Іменовані маршрути застосунку.
abstract final class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const changePassword = '/change-password';

  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginScreen(),
        register: (_) => const RegisterScreen(),
        forgotPassword: (_) => const ForgotPasswordScreen(),
        home: (_) => const MainShell(),
        changePassword: (_) => const ChangePasswordScreen(),
      };
}
