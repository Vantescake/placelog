import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Нижня панель навігації з чотирма вкладками
/// «Головна», «Заклади», «Оцінки», «Профіль».
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (Icons.home_outlined, 'Головна'),
    (Icons.format_list_bulleted, 'Заклади'),
    (Icons.star_border_rounded, 'Оцінки'),
    (Icons.person_outline, 'Профіль'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 80),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < _items.length; i++)
                  Expanded(child: _buildItem(i)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final (icon, label) = _items[index];
    final color =
        index == currentIndex ? AppColors.accent : AppColors.textSecondary;

    return InkResponse(
      onTap: () => onTap(index),
      radius: 36,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
