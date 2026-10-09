import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Стилізована кнопка дії на всю ширину.
///
/// [AppButton] — основна (теракотова) кнопка: «Увійти», «Зберегти зміни».
/// [AppButton.outlined] — другорядна кнопка з рамкою: «Вийти з акаунта».
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool _outlined;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  }) : _outlined = false;

  const AppButton.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  }) : _outlined = true;

  @override
  Widget build(BuildContext context) {
    final foreground = _outlined ? AppColors.accent : Colors.white;

    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: _outlined ? AppColors.surface : AppColors.primary,
          foregroundColor: foreground,
          padding: EdgeInsets.symmetric(vertical: _outlined ? 17 : 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: _outlined
                ? const BorderSide(color: AppColors.border)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: foreground),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: AppText.button.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
