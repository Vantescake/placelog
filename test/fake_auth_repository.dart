import 'dart:async';

import 'package:placelog/data/auth/auth_repository.dart';

/// Реалізація [AuthRepository] у пам'яті для тестів (без Firebase і мережі).
class FakeAuthRepository implements AuthRepository {
  final _controller = StreamController<AppUser?>.broadcast();
  final Map<String, String> _passwords = {};
  AppUser? _user;

  /// Якщо задано, наступний виклик кине цю помилку.
  AuthFailure? nextFailure;

  FakeAuthRepository({AppUser? signedIn}) : _user = signedIn;

  void _emit() => _controller.add(_user);

  Future<void> _maybeFail() async {
    final failure = nextFailure;
    nextFailure = null;
    if (failure != null) throw failure;
  }

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield _user;
    yield* _controller.stream;
  }

  @override
  AppUser? get currentUser => _user;

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await _maybeFail();
    if (_passwords.containsKey(email)) {
      throw const AuthFailure(
        'email-already-in-use',
        'Акаунт із такою поштою вже існує.',
      );
    }
    _passwords[email] = password;
    _user = AppUser(uid: email, email: email, name: name);
    _emit();
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _maybeFail();
    if (_passwords[email] != password) {
      throw const AuthFailure(
        'invalid-credential',
        'Не вдалося увійти. Перевірте email і пароль.',
      );
    }
    _user = AppUser(uid: email, email: email, name: '');
    _emit();
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _emit();
  }

  @override
  Future<void> sendPasswordReset({required String email}) => _maybeFail();

  @override
  Future<void> updateProfile({String? name, String? photoUrl}) async {
    await _maybeFail();
    final user = _user!;
    _user = AppUser(
      uid: user.uid,
      email: user.email,
      name: name ?? user.name,
      photoUrl: photoUrl ?? user.photoUrl,
    );
    _emit();
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _maybeFail();
    final email = _user!.email;
    if (_passwords[email] != currentPassword) {
      throw const AuthFailure('wrong-password', 'Поточний пароль неправильний.');
    }
    _passwords[email] = newPassword;
  }
}
