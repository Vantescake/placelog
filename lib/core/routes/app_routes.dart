import 'package:flutter/material.dart';

import '../../features/auth/auth_gate.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/profile/screens/change_password_screen.dart';

/// Іменовані маршрути застосунку.
///
/// Вхід і головна не мають окремих маршрутів: їх показує [AuthGate]
/// на кореневому маршруті залежно від стану сеансу.
abstract final class AppRoutes {
  static const root = '/';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const changePassword = '/change-password';

  static Map<String, WidgetBuilder> get routes => {
        root: (_) => const AuthGate(),
        register: (_) => const RegisterScreen(),
        forgotPassword: (_) => const ForgotPasswordScreen(),
        changePassword: (_) => const ChangePasswordScreen(),
      };
}
