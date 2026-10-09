import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:placelog/core/theme/app_theme.dart';
import 'package:placelog/features/auth/screens/forgot_password_screen.dart';
import 'package:placelog/features/auth/screens/login_screen.dart';
import 'package:placelog/features/auth/screens/register_screen.dart';
import 'package:placelog/features/main/main_shell.dart';

/// Перевіряє, що на телефоні 390×844 елементи не вилазять за межі
/// по висоті (BOTTOM OVERFLOWED), навіть зі збільшеним масштабом тексту.
///
/// Переповнення по ширині тут не перевіряється: тестовий шрифт Flutter
/// малює кожну літеру квадратом, тому текст у тестах значно ширший,
/// ніж у реальному застосунку.
void main() {
  final screens = <String, Widget>{
    'login': const LoginScreen(),
    'register': const RegisterScreen(),
    'forgot password': const ForgotPasswordScreen(),
    'home + profile': const MainShell(),
  };

  for (final scale in [1.0, 1.15, 1.3]) {
    for (final entry in screens.entries) {
      testWidgets('${entry.key}: без overflow по висоті, масштаб $scale',
          (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final errors = <String>[];
        final previous = FlutterError.onError;
        FlutterError.onError = (details) => errors.add(details.exceptionAsString());
        addTearDown(() => FlutterError.onError = previous);

        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.dark,
          home: MediaQuery(
            data: MediaQueryData(
              size: const Size(390, 844),
              textScaler: TextScaler.linear(scale),
            ),
            child: entry.value,
          ),
        ));
        if (entry.value is MainShell) {
          await tester.tap(find.text('Профіль').last);
          await tester.pump();
        }

        FlutterError.onError = previous;
        expect(errors.where((e) => e.contains('on the bottom')), isEmpty);
      });
    }
  }
}
