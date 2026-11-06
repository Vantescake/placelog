import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Повідомлення над кнопкою форми: помилка запиту або успіх.
class MessageBanner extends StatelessWidget {
  final String message;
  final bool isError;

  /// Необов'язкова дія, наприклад «Увійти знову».
  final String? actionText;
  final VoidCallback? onAction;

  const MessageBanner.error(
    this.message, {
    super.key,
    this.actionText,
    this.onAction,
  }) : isError = true;

  const MessageBanner.success(this.message, {super.key})
      : isError = false,
        actionText = null,
        onAction = null;

  @override
  Widget build(BuildContext context) {
    final color = isError ? AppColors.primary : AppColors.success;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            size: 20,
            color: isError ? AppColors.accent : AppColors.success,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.35,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (actionText != null) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: onAction,
                    child: Text(
                      actionText!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
