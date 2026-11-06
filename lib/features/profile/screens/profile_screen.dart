import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/data/mock_data.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/app_services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/validation/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/message_banner.dart';
import '../../../core/widgets/settings_group.dart';
import '../../../data/auth/auth_repository.dart';
import '../widgets/photo_picker_sheet.dart';

/// M8 · Профіль
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController(text: AppServices.auth.currentUser?.name);
  // Місто поки не зберігається на сервері: це буде у Cloud Firestore.
  final _city = TextEditingController(text: MockData.userCity);

  bool _saving = false;
  bool _signingOut = false;
  bool _nameEdited = false;
  String? _error;
  String? _success;
  late final StreamSubscription<AppUser?> _userSub;

  @override
  void initState() {
    super.initState();
    // Ім'я може прийти із запізненням (одразу після реєстрації),
    // тому підставляємо його, поки користувач не почав редагувати поле.
    _userSub = AppServices.auth.authStateChanges().listen((user) {
      if (user != null && !_nameEdited) _name.text = user.name;
    });
  }

  @override
  void dispose() {
    _userSub.cancel();
    _name.dispose();
    _city.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action, String success) async {
    setState(() {
      _saving = true;
      _error = null;
      _success = null;
    });
    try {
      await action();
      if (mounted) setState(() => _success = success);
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _saveName() async {
    if (!_formKey.currentState!.validate()) return;
    await _run(
      () => AppServices.auth.updateProfile(name: _name.text.trim()),
      'Профіль оновлено.',
    );
  }

  Future<void> _changePhoto(AppUser user) async {
    final url = await PhotoPickerSheet.show(context, currentUrl: user.photoUrl);
    if (url == null) return;
    await _run(() async {
      await AppServices.auth.updateProfile(photoUrl: url);
      await AppServices.analytics.logEvent('profile_photo_changed');
    }, 'Фото профілю оновлено.');
  }

  Future<void> _openChangePassword() async {
    final changed =
        await Navigator.pushNamed(context, AppRoutes.changePassword);
    if (changed == true && mounted) {
      setState(() {
        _error = null;
        _success = 'Пароль змінено.';
      });
    }
  }

  Future<void> _signOut() async {
    setState(() => _signingOut = true);
    try {
      await AppServices.auth.signOut();
      // AuthGate покаже екран входу.
    } on AuthFailure catch (e) {
      if (mounted) {
        setState(() {
          _signingOut = false;
          _error = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: AppServices.auth.authStateChanges(),
      initialData: AppServices.auth.currentUser,
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) return const SizedBox.shrink();

        return SafeArea(
          bottom: false,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                const Text('Профіль', style: AppText.title),
                const SizedBox(height: 16),
                Center(
                  child: _Avatar(
                    user: user,
                    onChangePhoto: _saving ? null : () => _changePhoto(user),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  user.name.isEmpty ? 'Без імені' : user.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Ім’я',
                  controller: _name,
                  validator: Validators.name,
                  enabled: !_saving,
                  onChanged: (_) => _nameEdited = true,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Місто',
                  controller: _city,
                  enabled: !_saving,
                ),
                const SizedBox(height: 16),
                if (_error != null) ...[
                  MessageBanner.error(_error!),
                  const SizedBox(height: 16),
                ],
                if (_success != null) ...[
                  MessageBanner.success(_success!),
                  const SizedBox(height: 16),
                ],
                AppButton(
                  text: 'Зберегти зміни',
                  isLoading: _saving,
                  onPressed: _saveName,
                ),
                const SizedBox(height: 16),
                SettingsGroup(
                  children: [
                    SettingsTile(
                      title: 'Змінити пароль',
                      onTap: _openChangePassword,
                    ),
                    const SettingsTile(title: 'Мова', value: 'Українська'),
                    // Лише для налагодження: перевірка звітів про помилки.
                    // У релізній збірці вмикається прапорцем
                    // --dart-define=ENABLE_TEST_ERROR=true.
                    if (kDebugMode ||
                        const bool.fromEnvironment('ENABLE_TEST_ERROR'))
                      SettingsTile(
                        title: 'Тестова помилка (Sentry)',
                        onTap: () => throw StateError(
                          'PlaceLog: тестова помилка для перевірки Sentry',
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                AppButton.outlined(
                  text: 'Вийти з акаунта',
                  icon: Icons.logout,
                  isLoading: _signingOut,
                  onPressed: _signOut,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Аватар: фото профілю або перша літера імені, зі значком камери.
class _Avatar extends StatelessWidget {
  final AppUser user;
  final VoidCallback? onChangePhoto;

  const _Avatar({required this.user, required this.onChangePhoto});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        children: [
          ProfilePhoto(
            url: user.photoUrl,
            size: 96,
            fallback: Text(
              user.initial,
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
            child: Material(
              color: AppColors.primary,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onChangePhoto,
                child: const SizedBox(
                  width: 32,
                  height: 32,
                  child: Icon(
                    Icons.photo_camera_outlined,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
