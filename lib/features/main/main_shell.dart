import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../home/screens/home_screen.dart';
import '../profile/screens/profile_screen.dart';

/// Каркас авторизованої частини: вкладки та нижня панель навігації.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _homeTab = 0;
  static const _placesTab = 1;

  int _index = _homeTab;

  void _select(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack зберігає стан вкладок під час перемикання.
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onShowAll: () => _select(_placesTab)),
          const _PlaceholderTab(
            title: 'Заклади',
            icon: Icons.format_list_bulleted,
          ),
          const _PlaceholderTab(title: 'Оцінки', icon: Icons.star_border_rounded),
          const ProfileScreen(),
        ],
      ),
      floatingActionButton: _index == _homeTab
          ? FloatingActionButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Додавання закладу — у ЛР №4')),
              ),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.add, size: 26),
            )
          : null,
      bottomNavigationBar: AppBottomNav(currentIndex: _index, onTap: _select),
    );
  }
}

/// Заглушка для вкладок, які реалізуються в наступних лабораторних.
class _PlaceholderTab extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderTab({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: AppText.title),
            const Spacer(),
            Icon(icon, size: 48, color: AppColors.border),
            const SizedBox(height: 12),
            const Text(
              'Розділ буде реалізовано в наступній лабораторній роботі',
              textAlign: TextAlign.center,
              style: AppText.body,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
