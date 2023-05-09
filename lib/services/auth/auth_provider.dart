
import 'package:registration/services/auth/auth_user.dart';

abstract class AuthProvider{
  
  Future<void> signInWithGoogle();
  
  Future<void> initialise();

  AuthUser? get currentUser;

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });



  Future<void> sendEmailVerification();

  Future<void> logout();

}