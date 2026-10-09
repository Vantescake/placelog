import 'package:flutter/material.dart';

import '../../../core/data/mock_data.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/place_card.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/stat_card.dart';

/// Головна
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
        children: [
          const Text('Привіт, ${MockData.userName}', style: AppText.title),
          const SizedBox(height: 16),
          const SearchField(hint: 'Пошук закладів'),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: StatCard(
                  value: '${MockData.placesCount}',
                  label: 'закладів',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  value: MockData.averageRating,
                  label: 'сер. оцінка',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  value: '${MockData.photosCount}',
                  label: 'фото',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text('Нещодавно відвідані', style: AppText.section),
              ),
              const Text('Усі', style: AppText.link),
            ],
          ),
          const SizedBox(height: 16),
          for (final place in MockData.recentPlaces) ...[
            PlaceCard(place: place),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
