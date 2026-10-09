import 'package:flutter/material.dart';

/// Hardcoded-дані замість бекенду (ЛР №3 виконується без бізнес-логіки).
abstract final class MockData {
  static const String userName = 'Андрій';
  static const String userFullName = 'Андрій Родінчук';
  static const String userEmail = 'user@example.com';
  static const String userCity = 'Львів';

  static const int placesCount = 18;
  static const String averageRating = '4,3';
  static const int photosCount = 42;

  static const List<Place> recentPlaces = [
    Place(
      name: 'Кав’ярня «Black Honey»',
      category: 'Кав’ярня',
      city: 'Львів',
      rating: 5,
      gradient: [Color(0xFFD2A57E), Color(0xFF8E5A3C)],
    ),
    Place(
      name: 'Піцерія «La П’єц»',
      category: 'Піцерія',
      city: 'Львів',
      rating: 4,
      gradient: [Color(0xFFE3907A), Color(0xFFB04A31)],
    ),
    Place(
      name: 'Бар «Братиська»',
      category: 'Бар',
      city: 'Львів',
      rating: 3,
      gradient: [Color(0xFF8FA39E), Color(0xFF3F5560)],
    ),
  ];
}

/// Модель закладу для відображення у списках.
class Place {
  final String name;
  final String category;
  final String city;
  final int rating;

  /// Градієнт-заглушка замість фото закладу.
  final List<Color> gradient;

  const Place({
    required this.name,
    required this.category,
    required this.city,
    required this.rating,
    required this.gradient,
  });
}
