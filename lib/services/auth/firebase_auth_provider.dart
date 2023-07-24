import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:registration/firebase_options.dart';
import 'package:registration/services/auth/auth_user.dart';
import 'package:registration/services/auth/auth_exception.dart';
import 'package:registration/services/auth/auth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthProvider extends ChangeNotifier implements AuthProvider{

 @override
  Future<void> signInWithGoogle() async{
    final googleSignIn = GoogleSignIn();
    // GoogleSignInAccount? user;
    final googleUser = await googleSignIn.signIn();
    if(googleUser == null) throw UserNotFoundAuthException();
    // user = googleUser;
    final googleAuth = await googleUser.authentication;
    googleAuth.accessToken;
    final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken,);

    await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
    

  }


  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      // create user with FirebaseAtuh
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      
      
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) async{
   try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password,);
      final user = currentUser;
      if (user != null) {
        return user;        
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {

      //! Catching FirebaseAuth Errors
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }

    } catch (e) {
      //! catching any other error different of FirebaseAuth
      throw GenericAuthException();
    }
    
  }

  @override
  Future<void> logout() async{
    final googleSignIn = GoogleSignIn();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async{
    final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
       await user.sendEmailVerification();
      } else {
        throw UserNotLoggedInAuthException();
      }
  }
  
  @override
  Future<void> initialise() async{
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
  }
  
  
}
