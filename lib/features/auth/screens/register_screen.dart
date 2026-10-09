import 'package:flutter/material.dart';

import '../../../core/data/mock_data.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/auth_footer_link.dart';
import '../../../core/widgets/full_height_scroll.dart';

/// M2 · Реєстрація (FR-01).
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
            const Text('Створіть акаунт', style: AppText.title),
            const SizedBox(height: 16),
            const AppTextField(label: 'Ім’я', initialValue: MockData.userName),
            const SizedBox(height: 16),
            const AppTextField(
              label: 'Електронна пошта',
              initialValue: MockData.userEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            const AppTextField(
              label: 'Пароль',
              initialValue: 'password',
              isPassword: true,
            ),
            const SizedBox(height: 16),
            const AppTextField(
              label: 'Підтвердіть пароль',
              initialValue: 'password',
              isPassword: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'Мінімум 8 символів, літери й цифри',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const Spacer(),
            const SizedBox(height: 16),
            AppButton(
              text: 'Зареєструватися',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (_) => false,
              ),
            ),
            const SizedBox(height: 16),
            AuthFooterLink(
              question: 'Вже є акаунт?',
              action: 'Увійти',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
