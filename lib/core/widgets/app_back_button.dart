import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Кругла кнопка «Назад» 42×42 з рамкою.
class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed ?? () => Navigator.of(context).maybePop(),
        child: const SizedBox(
          width: 42,
          height: 42,
          child: Icon(Icons.arrow_back, size: 20, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
