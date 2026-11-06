/// Користувач застосунку: дані профілю з Firebase Authentication.
class AppUser {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;

  const AppUser({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
  });

  /// Перша літера імені (або пошти) для аватара без фото.
  String get initial {
    final source = name.isNotEmpty ? name : email;
    if (source.isEmpty) return '?';
    return String.fromCharCode(source.runes.first).toUpperCase();
  }
}

/// Помилка автентифікації з повідомленням, зрозумілим користувачу.
class AuthFailure implements Exception {
  /// Код помилки Firebase, наприклад `invalid-credential`.
  final String code;
  final String message;

  const AuthFailure(this.code, this.message);

  bool get requiresRecentLogin => code == 'requires-recent-login';

  @override
  String toString() => 'AuthFailure($code): $message';
}

/// Операції автентифікації, які потрібні інтерфейсу.
///
/// Екрани працюють лише з цим інтерфейсом і не знають про Firebase,
/// тому в тестах його можна замінити фейковою реалізацією.
abstract interface class AuthRepository {
  /// Потік поточного користувача: `null` після виходу.
  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signIn({required String email, required String password});

  Future<void> signOut();

  Future<void> sendPasswordReset({required String email});

  Future<void> updateProfile({String? name, String? photoUrl});

  /// Повторна автентифікація поточним паролем і встановлення нового.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
