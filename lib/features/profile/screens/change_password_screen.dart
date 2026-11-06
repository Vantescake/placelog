import 'package:flutter/material.dart';

import '../../../core/services/app_services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/validation/validators.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/full_height_scroll.dart';
import '../../../core/widgets/message_banner.dart';
import '../../../core/widgets/password_strength_bar.dart';
import '../../../data/auth/auth_repository.dart';

/// M9 · Зміна пароля
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();

  bool _loading = false;
  AuthFailure? _failure;

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _failure = null;
    });
    try {
      await AppServices.auth.changePassword(
        currentPassword: _current.text,
        newPassword: _new.text,
      );
      await AppServices.analytics.logEvent('password_changed');
      // Профіль покаже «Пароль змінено».
      if (mounted) Navigator.pop(context, true);
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _failure = e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Для requires-recent-login: вийти, щоб увійти знову з новим сеансом.
  Future<void> _signInAgain() async {
    await AppServices.auth.signOut();
    if (mounted) Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: FullHeightScroll(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: AppBackButton(),
              ),
              const SizedBox(height: 16),
              const Text('Зміна пароля', style: AppText.title),
              const SizedBox(height: 16),
              const Text(
                'Для безпеки введіть поточний пароль, а потім новий.',
                style: AppText.body,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Поточний пароль',
                controller: _current,
                isPassword: true,
                textInputAction: TextInputAction.next,
                validator: Validators.requiredPassword,
                enabled: !_loading,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Новий пароль',
                controller: _new,
                isPassword: true,
                textInputAction: TextInputAction.next,
                validator: Validators.newPassword,
                enabled: !_loading,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              PasswordStrengthBar(password: _new.text),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Повторіть новий пароль',
                controller: _confirm,
                isPassword: true,
                textInputAction: TextInputAction.done,
                validator: Validators.confirmPassword(() => _new.text),
                enabled: !_loading,
                onSubmitted: (_) => _submit(),
              ),
              const Spacer(),
              const SizedBox(height: 16),
              if (_failure != null) ...[
                _failure!.requiresRecentLogin
                    ? MessageBanner.error(
                        _failure!.message,
                        actionText: 'Увійти знову',
                        onAction: _signInAgain,
                      )
                    : MessageBanner.error(_failure!.message),
                const SizedBox(height: 16),
              ],
              AppButton(
                text: 'Змінити пароль',
                isLoading: _loading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
