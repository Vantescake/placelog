import 'package:flutter/material.dart';

import '../../../core/data/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

/// M3 · Відновлення пароля 
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String _email = MockData.userEmail;
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: AppBackButton(),
            ),
            const SizedBox(height: 16),
            const Text('Відновлення пароля', style: AppText.title),
            const SizedBox(height: 16),
            const Text(
              'Вкажіть пошту акаунта — ми надішлемо посилання для встановлення нового пароля.',
              style: AppText.body,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Електронна пошта',
              initialValue: _email,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => _email = value,
            ),
            const SizedBox(height: 16),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: _sent
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _SuccessCard(email: _email),
                    )
                  : const SizedBox(width: double.infinity),
            ),
            AppButton(
              text: 'Надіслати посилання',
              onPressed: () => setState(() => _sent = true),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  final String email;

  const _SuccessCard({required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.mail_outline, size: 22, color: AppColors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Перевірте пошту',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Лист надіслано на $email. Посилання діє 1 годину.',
                  style: const TextStyle(
                    fontSize: 13,
                    height: 19 / 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
