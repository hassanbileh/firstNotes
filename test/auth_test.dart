import 'package:registration/services/auth/auth_exception.dart';
import 'package:registration/services/auth/auth_provider.dart';
import 'package:registration/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentification', () {
    final provider = MockAuthProvider();

    test('shouldn\'t be initialzed to begin with', () {
      expect(provider._isInitialized, false);
    });

    test('Initialise before log out', () {
      expect(
        provider.logout(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('Should be able to initialized', () async {
      await provider.initialise();
      expect(
        provider.isInitialise,
        true,
      );
    });

    test('User should be null after initialisation', () {
      expect(provider.currentUser, null);
    });

    test(
      'should bo initialzed in less than 2 seconds',
      () async {
        await provider.initialise();
        expect(provider._isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Create user should delegate to logIn', () async {
      await provider.initialise();
      expect(provider._isInitialized, true);

      /*final badEmailUser = await provider.createUser(
        email: 'hasbil@bile.com',
        password: 'hassan',
      );
      expect(
        badEmailUser,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );

      final badPassword = provider.createUser(
        email: 'email',
        password: 'hasbil',
      );
      expect(
        badPassword,
        throwsA(const TypeMatcher<WrongPasswordAuthException>()),
      );*/
      final user = await provider.createUser(
        email: 'mac@os.com',
        password: 'macosx',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged user should be get verified', () async{
      await provider.initialise();
      expect(provider._isInitialized, true);
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('User should log out and log in again', () async {
      await provider.logout();
      await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialized = false;
  bool? get isInitialise => _isInitialized;
  AuthUser? _user;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialise() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw NotInitializedException();
    if (email == 'hasbil@bile.com') throw UserNotFoundAuthException();
    if (password == 'hasbil') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false, email: 'hasbil@bile.com');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!_isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    if (_user == null) throw UserNotFoundAuthException();
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialized) throw NotInitializedException();
    final user = _user;
    await Future.delayed(const Duration(seconds: 1));
    if (_user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true, email: 'hasbil@bile.com');
    _user = newUser;
  }

  @override
  Future<void> signInWithGoogle() {
    
    throw UnimplementedError();
  }
  
}
