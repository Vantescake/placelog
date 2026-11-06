import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Поле введення з підписом над ним (компонент «Field» з макета).
///
/// Працює всередині [Form]: [validator] перевіряє значення під час
/// `FormState.validate()`. Для паролів ([isPassword]) показує кнопку-«око».
class AppTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final bool isPassword;
  final bool enabled;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.isPassword = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppText.label),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          initialValue: widget.controller == null ? widget.initialValue : null,
          enabled: widget.enabled,
          obscureText: _obscured,
          obscuringCharacter: '•',
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          style: AppText.input,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppText.input.copyWith(color: AppColors.textSecondary),
            errorStyle: const TextStyle(fontSize: 13, color: AppColors.accent),
            errorMaxLines: 2,
            filled: true,
            fillColor: AppColors.surface,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: border(AppColors.border),
            disabledBorder: border(AppColors.border),
            focusedBorder: border(AppColors.accent),
            errorBorder: border(AppColors.primary),
            focusedErrorBorder: border(AppColors.accent),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () => setState(() => _obscured = !_obscured),
                    icon: Icon(
                      _obscured
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
