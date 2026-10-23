import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/full_height_scroll.dart';
import '../../../core/widgets/password_strength_bar.dart';

/// M9 · Зміна пароля
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String _newPassword = 'Placelog';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FullHeightScroll(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: AppBackButton(),
            ),
            const SizedBox(height: 16),
            const Text('Зміна пароля', style: AppText.title),
            const SizedBox(height: 16),
            const Text(
              'Для безпеки введіть поточний пароль, а потім новий.',
              style: AppText.body,
            ),
            const SizedBox(height: 16),
            const AppTextField(
              label: 'Поточний пароль',
              initialValue: 'password',
              isPassword: true,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Новий пароль',
              initialValue: _newPassword,
              isPassword: true,
              onChanged: (value) => setState(() => _newPassword = value),
            ),
            const SizedBox(height: 16),
            PasswordStrengthBar(password: _newPassword),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Повторіть новий пароль',
              initialValue: _newPassword,
              isPassword: true,
            ),
            const Spacer(),
            const SizedBox(height: 16),
            AppButton(
              text: 'Змінити пароль',
              // Без бізнес-логіки: просто повертаємось у профіль.
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
