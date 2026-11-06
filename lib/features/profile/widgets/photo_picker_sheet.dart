import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/validation/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

/// Вибір фото профілю: готові зображення або власне HTTPS-посилання
/// з попереднім переглядом. Повертає вибране посилання через Navigator.pop.
class PhotoPickerSheet extends StatefulWidget {
  final String? currentUrl;

  const PhotoPickerSheet({super.key, this.currentUrl});

  /// Набір готових зображень з відомими HTTPS-посиланнями.
  static const presets = [
    'https://picsum.photos/id/64/300/300',
    'https://picsum.photos/id/91/300/300',
    'https://picsum.photos/id/177/300/300',
    'https://picsum.photos/id/338/300/300',
    'https://picsum.photos/id/433/300/300',
    'https://picsum.photos/id/1005/300/300',
  ];

  static Future<String?> show(BuildContext context, {String? currentUrl}) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PhotoPickerSheet(currentUrl: currentUrl),
    );
  }

  @override
  State<PhotoPickerSheet> createState() => _PhotoPickerSheetState();
}

class _PhotoPickerSheetState extends State<PhotoPickerSheet> {
  final _formKey = GlobalKey<FormState>();
  final _url = TextEditingController();
  late String? _selected = widget.currentUrl;

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  void _previewCustomUrl() {
    if (_formKey.currentState!.validate()) {
      setState(() => _selected = _url.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Фото профілю', style: AppText.section),
              const SizedBox(height: 16),
              Center(child: ProfilePhoto(url: _selected, size: 96)),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 6,
                shrinkWrap: true,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final url in PhotoPickerSheet.presets)
                    GestureDetector(
                      onTap: () => setState(() => _selected = url),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2,
                            color: url == _selected
                                ? AppColors.accent
                                : Colors.transparent,
                          ),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: ProfilePhoto(url: url, size: 44),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Або власне посилання',
                controller: _url,
                hint: 'https://…',
                keyboardType: TextInputType.url,
                validator: Validators.httpsUrl,
                onSubmitted: (_) => _previewCustomUrl(),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _previewCustomUrl,
                  child: const Text('Переглянути', style: AppText.link),
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Застосувати',
                onPressed: _selected == null || _selected == widget.currentUrl
                    ? null
                    : () => Navigator.pop(context, _selected),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Кругле фото за посиланням; якщо його немає або воно не завантажилось,
/// показує [fallback] (літеру імені).
class ProfilePhoto extends StatelessWidget {
  final String? url;
  final double size;
  final Widget? fallback;

  const ProfilePhoto({super.key, this.url, required this.size, this.fallback});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: fallback ??
          Icon(Icons.person_outline,
              size: size * 0.45, color: AppColors.textSecondary),
    );
    if (url == null || url!.isEmpty) return placeholder;

    return ClipOval(
      child: Image.network(
        url!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        // У вебі дозволяє показати зображення з іншого домену без CORS.
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        errorBuilder: (_, _, _) => placeholder,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : placeholder,
      ),
    );
  }
}
