import 'package:flutter/material.dart';

import '../../../core/data/mock_data.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/auth_footer_link.dart';
import '../../../core/widgets/full_height_scroll.dart';

/// Вхід
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FullHeightScroll(
          padding: const EdgeInsets.fromLTRB(20, 48, 20, 28),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Вітаємо в PlaceLog', style: AppText.title),
            const SizedBox(height: 16),
            const Text(
              'Зберігайте відвідані місця, оцінки, нотатки та фото в одному каталозі.',
              style: AppText.body,
            ),
            const SizedBox(height: 40),
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
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.forgotPassword),
                child: const Text('Забули пароль?', style: AppText.link),
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              text: 'Увійти',
              // Без бізнес-логіки: вхід завжди «успішний».
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.home),
            ),
            const Spacer(),
            const SizedBox(height: 16),
            AuthFooterLink(
              question: 'Немає акаунта?',
              action: 'Створити',
              onTap: () => Navigator.pushNamed(context, AppRoutes.register),
            ),
          ],
        ),
      ),
    );
  }
}
