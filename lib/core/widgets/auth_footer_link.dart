import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Рядок «Немає акаунта? Створити» / «Вже є акаунт? Увійти».
class AuthFooterLink extends StatelessWidget {
  final String question;
  final String action;
  final VoidCallback onTap;

  const AuthFooterLink({
    super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Wrap переносить «Створити» на новий рядок, якщо не вміщається.
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          question,
          style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 6, height: 20),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            ),
          ),
        ),
      ],
    );
  }
}
