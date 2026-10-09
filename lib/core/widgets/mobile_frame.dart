import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Обмежує застосунок мобільною шириною (mobile-only view).
///
/// На телефоні займає весь екран, а у браузері чи на десктопі
/// показує «телефон» шириною до [maxWidth] по центру вікна.
class MobileFrame extends StatelessWidget {
  static const double maxWidth = 430;

  final Widget child;

  const MobileFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width.clamp(0.0, maxWidth);

    return ColoredBox(
      color: AppColors.outside,
      child: Center(
        child: ClipRect(
          child: SizedBox(
            width: width,
            child: MediaQuery(
              // Дочірні віджети «бачать» лише ширину телефона.
              data: media.copyWith(size: Size(width, media.size.height)),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
