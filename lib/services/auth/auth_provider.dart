
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:registration/services/auth/auth_user.dart';

abstract class AuthProvider{

  User? get user;
  
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