import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Оцінка закладу від 1 до 5 у вигляді зірок.
class StarRating extends StatelessWidget {
  final int rating;
  final double size;

  const StarRating({super.key, required this.rating, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Padding(
          padding: EdgeInsets.only(right: i < 4 ? 2 : 0),
          child: Icon(
            Icons.star_rounded,
            size: size,
            color: i < rating ? AppColors.star : AppColors.starEmpty,
          ),
        );
      }),
    );
  }
}
