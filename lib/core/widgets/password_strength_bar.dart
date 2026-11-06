import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Індикатор надійності пароля з чотирьох сегментів.
class PasswordStrengthBar extends StatelessWidget {
  final String password;

  const PasswordStrengthBar({super.key, required this.password});

  /// Проста евристика: довжина, цифри, великі літери, спецсимволи.
  static int strengthOf(String value) {
    if (value.isEmpty) return 0;
    var score = 0;
    if (value.length >= 8) score++;
    if (value.contains(RegExp(r'\d'))) score++;
    if (value.contains(RegExp(r'[A-ZА-ЯІЇЄҐ]'))) score++;
    if (value.contains(RegExp(r'[^A-Za-zА-Яа-яІіЇїЄєҐґ\d]'))) score++;
    return score.clamp(1, 4);
  }

  static const _labels = ['', 'Слабкий пароль', 'Надійний пароль',
    'Надійний пароль', 'Дуже надійний пароль'];

  @override
  Widget build(BuildContext context) {
    final strength = strengthOf(password);
    final color = strength <= 1 ? AppColors.primary : AppColors.success;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < 4; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: i < strength ? color : AppColors.track,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Text(
          _labels[strength],
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }
}
