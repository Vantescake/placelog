import 'package:flutter/material.dart';

import '../../core/services/app_services.dart';
import '../../core/theme/app_colors.dart';
import '../../data/auth/auth_repository.dart';
import '../main/main_shell.dart';
import 'screens/login_screen.dart';

/// Кореневий екран: показує вхід або головну залежно від стану сеансу.
///
/// Firebase зберігає сеанс між запусками, тому після перезавантаження
/// сторінки користувач одразу потрапляє на головну (відновлення сеансу).
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AppServices.auth;

    return StreamBuilder<AppUser?>(
      stream: auth.authStateChanges(),
      initialData: auth.currentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.data == null) {
          return const _Splash();
        }
        return snapshot.data == null ? const LoginScreen() : const MainShell();
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}
