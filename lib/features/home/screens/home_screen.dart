import 'package:flutter/material.dart';

import '../../../core/data/mock_data.dart';
import '../../../core/services/app_services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/place_card.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../data/auth/auth_repository.dart';

/// Головна. Статистика й заклади поки з MockData (Firestore буде пізніше),
/// а ім'я користувача — з Firebase Authentication через AuthRepository.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
        children: [
          StreamBuilder<AppUser?>(
            stream: AppServices.auth.authStateChanges(),
            initialData: AppServices.auth.currentUser,
            builder: (context, snapshot) {
              final name = snapshot.data?.name ?? '';
              return Text(
                name.isEmpty ? 'Привіт!' : 'Привіт, ${name.split(' ').first}',
                style: AppText.title,
              );
            },
          ),
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
