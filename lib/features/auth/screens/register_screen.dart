import 'package:flutter/material.dart';

import '../../../core/services/app_services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/validation/validators.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/auth_footer_link.dart';
import '../../../core/widgets/full_height_scroll.dart';
import '../../../core/widgets/message_banner.dart';
import '../../../data/auth/auth_repository.dart';

/// Реєстрація
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Локальна валідація: усі validator-и форми.
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AppServices.auth.signUp(
        name: _name.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
      );
      await AppServices.analytics.logSignUp();
      // Після реєстрації користувач уже увійшов: повертаємось до AuthGate,
      // який покаже головну.
      if (mounted) Navigator.popUntil(context, (route) => route.isFirst);
    } on AuthFailure catch (e) {
      // Перевірки Firebase: пошта зайнята, мережа тощо.
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: FullHeightScroll(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: AppBackButton(),
                ),
                const SizedBox(height: 16),
                const Text('Створіть акаунт', style: AppText.title),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Ім’я',
                  controller: _name,
                  hint: 'Андрій',
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.givenName],
                  validator: Validators.name,
                  enabled: !_loading,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Електронна пошта',
                  controller: _email,
                  hint: 'user@example.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: Validators.email,
                  enabled: !_loading,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Пароль',
                  controller: _password,
                  isPassword: true,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: Validators.newPassword,
                  enabled: !_loading,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Підтвердіть пароль',
                  controller: _confirm,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: Validators.confirmPassword(() => _password.text),
                  enabled: !_loading,
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Мінімум 8 символів, літери й цифри',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const Spacer(),
                const SizedBox(height: 16),
                if (_error != null) ...[
                  MessageBanner.error(_error!),
                  const SizedBox(height: 16),
                ],
                AppButton(
                  text: 'Зареєструватися',
                  isLoading: _loading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 16),
                AuthFooterLink(
                  question: 'Вже є акаунт?',
                  action: 'Увійти',
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
