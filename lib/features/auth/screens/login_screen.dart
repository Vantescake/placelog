import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/services/app_services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/validation/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/auth_footer_link.dart';
import '../../../core/widgets/full_height_scroll.dart';
import '../../../core/widgets/message_banner.dart';
import '../../../data/auth/auth_repository.dart';

/// Вхід
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Ключ створюється один раз у State, а не в build().
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AppServices.auth.signIn(
        email: _email.text.trim(),
        password: _password.text,
      );
      await AppServices.analytics.logLogin();
      // AuthGate сам покаже головну, щойно Firebase повідомить про вхід.
    } on AuthFailure catch (e) {
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
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 28),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Вітаємо в PlaceLog', style: AppText.title),
                const SizedBox(height: 16),
                const Text(
                  'Зберігайте відвідані місця, оцінки, нотатки та фото в одному каталозі.',
                  style: AppText.body,
                ),
                const SizedBox(height: 40),
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
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  validator: Validators.requiredPassword,
                  enabled: !_loading,
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    child: const Text('Забули пароль?', style: AppText.link),
                  ),
                ),
                const SizedBox(height: 16),
                if (_error != null) ...[
                  MessageBanner.error(_error!),
                  const SizedBox(height: 16),
                ],
                AppButton(
                  text: 'Увійти',
                  isLoading: _loading,
                  onPressed: _submit,
                ),
                const Spacer(),
                const SizedBox(height: 16),
                AuthFooterLink(
                  question: 'Немає акаунта?',
                  action: 'Створити',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.register),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
