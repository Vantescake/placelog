import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Стилізована кнопка дії на всю ширину.
///
/// [AppButton] — основна (теракотова) кнопка: «Увійти», «Зберегти зміни».
/// [AppButton.outlined] — другорядна кнопка з рамкою: «Вийти з акаунта».
/// Поки [isLoading] true, кнопка показує індикатор і не натискається,
/// тож запит не можна надіслати повторно.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool _outlined;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : _outlined = false;

  const AppButton.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : _outlined = true;

  @override
  Widget build(BuildContext context) {
    final foreground = _outlined ? AppColors.accent : Colors.white;
    final background = _outlined ? AppColors.surface : AppColors.primary;

    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: background,
          disabledBackgroundColor: background.withValues(alpha: 0.6),
          foregroundColor: foreground,
          padding: EdgeInsets.symmetric(vertical: _outlined ? 17 : 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: _outlined
                ? const BorderSide(color: AppColors.border)
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox.square(
                dimension: 19,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: foreground,
                ),
              )
            : Row(
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
