import 'package:flutter/material.dart';

import '../../../core/data/mock_data.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/settings_group.dart';

/// M8 · Профіль
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          const Text('Профіль', style: AppText.title),
          const SizedBox(height: 16),
          const Center(child: _Avatar()),
          const SizedBox(height: 14),
          const Text(
            MockData.userFullName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            MockData.userEmail,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          const AppTextField(
            label: 'Ім’я',
            initialValue: MockData.userFullName,
          ),
          const SizedBox(height: 16),
          const AppTextField(label: 'Місто', initialValue: MockData.userCity),
          const SizedBox(height: 16),
          AppButton(
            text: 'Зберегти зміни',
            onPressed: () {},
          ),
          const SizedBox(height: 16),
          SettingsGroup(
            children: [
              SettingsTile(
                title: 'Змінити пароль',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.changePassword),
              ),
              const SettingsTile(title: 'Мова', value: 'Українська'),
            ],
          ),
          const SizedBox(height: 16),
          AppButton.outlined(
            text: 'Вийти з акаунта',
            icon: Icons.logout,
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (_) => false,
            ),
          ),
        ],
      ),
    );
  }
}

/// Аватар із першою літерою імені та значком камери.
class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            alignment: Alignment.center,
            child: Text(
              MockData.userName.characters.first,
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.photo_camera_outlined,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
