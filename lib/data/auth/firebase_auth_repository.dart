import 'package:firebase_auth/firebase_auth.dart';

import 'auth_repository.dart';

/// Реалізація [AuthRepository] на Firebase Authentication (email/пароль).
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;

  FirebaseAuthRepository({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  @override
  Stream<AppUser?> authStateChanges() =>
      _auth.userChanges().map((user) => user == null ? null : _toAppUser(user));

  @override
  AppUser? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : _toAppUser(user);
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) =>
      _guard(() async {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await credential.user!.updateDisplayName(name);
        // userChanges() повідомить екрани про нове ім'я.
        await credential.user!.reload();
      });

  @override
  Future<void> signIn({required String email, required String password}) =>
      _guard(() => _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ));

  @override
  Future<void> signOut() => _guard(_auth.signOut);

  @override
  Future<void> sendPasswordReset({required String email}) =>
      _guard(() => _auth.sendPasswordResetEmail(email: email));

  @override
  Future<void> updateProfile({String? name, String? photoUrl}) =>
      _guard(() async {
        final user = _requireUser();
        if (name != null) await user.updateDisplayName(name);
        if (photoUrl != null) await user.updatePhotoURL(photoUrl);
        await user.reload();
      });

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _guard(() async {
        final user = _requireUser();
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        try {
          await user.reauthenticateWithCredential(credential);
        } on FirebaseAuthException catch (e) {
          // Тут «неправильні облікові дані» означають саме поточний пароль.
          if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
            throw const AuthFailure(
              'wrong-password',
              'Поточний пароль неправильний.',
            );
          }
          rethrow;
        }
        await user.updatePassword(newPassword);
      });

  User _requireUser() {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthFailure(
        'requires-recent-login',
        'Сеанс завершився. Увійдіть знову.',
      );
    }
    return user;
  }

  /// Перетворює винятки Firebase на [AuthFailure] з українським текстом.
  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on AuthFailure {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.code, messageFor(e.code));
    }
  }

  static String messageFor(String code) => switch (code) {
        'invalid-email' => 'Некоректний формат електронної пошти.',
        'user-disabled' => 'Цей акаунт заблоковано.',
        'user-not-found' ||
        'wrong-password' ||
        'invalid-credential' =>
          'Не вдалося увійти. Перевірте email і пароль.',
        'email-already-in-use' => 'Акаунт із такою поштою вже існує.',
        'weak-password' => 'Пароль надто простий: мінімум 6 символів.',
        'too-many-requests' =>
          'Забагато спроб. Зачекайте кілька хвилин і спробуйте знову.',
        'network-request-failed' =>
          'Немає з’єднання з інтернетом. Перевірте мережу.',
        'requires-recent-login' =>
          'З міркувань безпеки увійдіть знову, а потім змініть пароль.',
        'operation-not-allowed' =>
          'Вхід за email і паролем вимкнено в налаштуваннях Firebase.',
        _ => 'Сталася помилка. Спробуйте ще раз.',
      };

  static AppUser _toAppUser(User user) => AppUser(
        uid: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        photoUrl: user.photoURL,
      );
}
