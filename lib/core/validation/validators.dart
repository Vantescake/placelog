/// Правила локальної валідації полів форм.
///
/// Кожен метод повертає текст помилки або `null`, якщо значення коректне,
/// тож його можна передати прямо в `TextFormField.validator`.
abstract final class Validators {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? name(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Вкажіть ім’я.';
    if (text.length < 2) return 'Ім’я має містити щонайменше 2 символи.';
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Вкажіть електронну пошту.';
    if (!_emailPattern.hasMatch(text)) return 'Некоректний формат пошти.';
    return null;
  }

  /// Пароль для входу: лише перевірка, що поле заповнене.
  static String? requiredPassword(String? value) =>
      (value ?? '').isEmpty ? 'Введіть пароль.' : null;

  /// Новий пароль: мінімум 8 символів, літери й цифри (вимога з макета).
  static String? newPassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Введіть пароль.';
    if (text.length < 8) return 'Мінімум 8 символів.';
    if (!text.contains(RegExp(r'[A-Za-zА-Яа-яІіЇїЄєҐґ]')) ||
        !text.contains(RegExp(r'\d'))) {
      return 'Пароль має містити літери й цифри.';
    }
    return null;
  }

  /// Повтор пароля має збігатися з [original].
  static String? Function(String?) confirmPassword(String Function() original) =>
      (value) {
        if ((value ?? '').isEmpty) return 'Повторіть пароль.';
        if (value != original()) return 'Паролі не збігаються.';
        return null;
      };

  static String? httpsUrl(String? value) {
    final uri = Uri.tryParse(value?.trim() ?? '');
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      return 'Вкажіть посилання, що починається з https://';
    }
    return null;
  }
}
