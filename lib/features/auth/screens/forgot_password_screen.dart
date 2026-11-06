import 'package:flutter/material.dart';

import '../../../core/services/app_services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/validation/validators.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/message_banner.dart';
import '../../../data/auth/auth_repository.dart';

/// M3 · Відновлення пароля
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  bool _loading = false;
  String? _sentTo;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _email.text.trim();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AppServices.auth.sendPasswordReset(email: email);
      await AppServices.analytics.logEvent('password_reset_requested');
      if (mounted) setState(() => _sentTo = email);
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
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: AppBackButton(),
              ),
              const SizedBox(height: 16),
              const Text('Відновлення пароля', style: AppText.title),
              const SizedBox(height: 16),
              const Text(
                'Вкажіть пошту акаунта — ми надішлемо посилання для встановлення нового пароля.',
                style: AppText.body,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Електронна пошта',
                controller: _email,
                hint: 'user@example.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: Validators.email,
                enabled: !_loading,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              if (_sentTo != null) ...[
                _SuccessCard(email: _sentTo!),
                const SizedBox(height: 16),
              ],
              if (_error != null) ...[
                MessageBanner.error(_error!),
                const SizedBox(height: 16),
              ],
              AppButton(
                text: _sentTo == null
                    ? 'Надіслати посилання'
                    : 'Надіслати ще раз',
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

class _SuccessCard extends StatelessWidget {
  final String email;

  const _SuccessCard({required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.mail_outline, size: 22, color: AppColors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Перевірте пошту',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                // Firebase не розкриває, чи існує акаунт із такою поштою.
                Text(
                  'Якщо акаунт із поштою $email існує, ми надіслали на неї '
                  'посилання. Посилання діє 1 годину.',
                  style: const TextStyle(
                    fontSize: 13,
                    height: 19 / 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
