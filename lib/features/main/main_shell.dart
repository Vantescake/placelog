import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../home/screens/home_screen.dart';
import '../profile/screens/profile_screen.dart';

/// Каркас авторизованої частини: вкладки та нижня панель навігації.
///
/// Поки що працюють лише вкладки «Головна» та «Профіль»,
/// натискання на «Заклади» й «Оцінки» ігнорується.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _homeTab = 0;
  static const _profileTab = 3;

  int _index = _homeTab;

  void _select(int index) {
    if (index != _homeTab && index != _profileTab) return;
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack зберігає стан вкладок під час перемикання.
      body: IndexedStack(
        index: _index == _homeTab ? 0 : 1,
        children: const [HomeScreen(), ProfileScreen()],
      ),
      floatingActionButton: _index == _homeTab
          ? FloatingActionButton(
              onPressed: () {},
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
