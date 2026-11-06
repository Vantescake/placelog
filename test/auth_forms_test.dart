import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:placelog/core/services/app_services.dart';
import 'package:placelog/core/theme/app_theme.dart';
import 'package:placelog/core/validation/validators.dart';
import 'package:placelog/data/auth/auth_repository.dart';
import 'package:placelog/features/auth/auth_gate.dart';
import 'package:placelog/features/auth/screens/register_screen.dart';

import 'fake_auth_repository.dart';

Widget _app(Widget home) => MaterialApp(theme: AppTheme.dark, home: home);

void main() {
  group('Validators', () {
    test('email', () {
      expect(Validators.email(''), 'Вкажіть електронну пошту.');
      expect(Validators.email('andrii@'), 'Некоректний формат пошти.');
      expect(Validators.email(' andrii@example.com '), isNull);
    });

    test('новий пароль: довжина, літери й цифри', () {
      expect(Validators.newPassword('abc1'), 'Мінімум 8 символів.');
      expect(Validators.newPassword('password'),
          'Пароль має містити літери й цифри.');
      expect(Validators.newPassword('Placelog26'), isNull);
    });

    test('повтор пароля', () {
      final confirm = Validators.confirmPassword(() => 'Placelog26');
      expect(confirm('Placelog25'), 'Паролі не збігаються.');
      expect(confirm('Placelog26'), isNull);
    });

    test('https-посилання на фото', () {
      expect(Validators.httpsUrl('http://x.com/a.jpg'), isNotNull);
      expect(Validators.httpsUrl('https://picsum.photos/id/64/300/300'), isNull);
    });
  });

  group('Форма реєстрації', () {
    late FakeAuthRepository auth;

    setUp(() => AppServices.auth = auth = FakeAuthRepository());

    testWidgets('порожня форма показує помилки і не надсилає запит',
        (tester) async {
      await tester.pumpWidget(_app(const RegisterScreen()));
      await tester.tap(find.text('Зареєструватися'));
      await tester.pump();

      expect(find.text('Вкажіть ім’я.'), findsOneWidget);
      expect(find.text('Вкажіть електронну пошту.'), findsOneWidget);
      expect(find.text('Введіть пароль.'), findsOneWidget);
      expect(auth.currentUser, isNull);
    });

    testWidgets('помилка Firebase показується зрозумілим текстом',
        (tester) async {
      auth.nextFailure = const AuthFailure(
        'email-already-in-use',
        'Акаунт із такою поштою вже існує.',
      );
      await tester.pumpWidget(_app(const RegisterScreen()));

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Андрій');
      await tester.enterText(fields.at(1), 'andrii@example.com');
      await tester.enterText(fields.at(2), 'Placelog26');
      await tester.enterText(fields.at(3), 'Placelog26');
      await tester.tap(find.text('Зареєструватися'));
      await tester.pumpAndSettle();

      expect(find.text('Акаунт із такою поштою вже існує.'), findsOneWidget);
    });
  });

  testWidgets('AuthGate: вхід із неправильним паролем, потім успішний',
      (tester) async {
    final auth = FakeAuthRepository();
    AppServices.auth = auth;
    await auth.signUp(
      name: 'Андрій',
      email: 'andrii@example.com',
      password: 'Placelog26',
    );
    await auth.signOut();

    await tester.pumpWidget(_app(const AuthGate()));
    await tester.pumpAndSettle();
    expect(find.text('Вітаємо в PlaceLog'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'andrii@example.com');
    await tester.enterText(fields.at(1), 'wrong-pass');
    await tester.tap(find.text('Увійти'));
    await tester.pumpAndSettle();
    expect(find.text('Не вдалося увійти. Перевірте email і пароль.'),
        findsOneWidget);

    await tester.enterText(fields.at(1), 'Placelog26');
    await tester.tap(find.text('Увійти'));
    await tester.pumpAndSettle();
    expect(find.text('Нещодавно відвідані'), findsOneWidget);
  });
}
