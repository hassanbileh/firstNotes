
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogIn(this.email, this.password);
}

class AuthEventSendEmailVerification extends AuthEvent{
  const AuthEventSendEmailVerification();
}

class AuthEventSignInWithGoogle extends AuthEvent{
  const AuthEventSignInWithGoogle();
}

class AuthEventSignUpWithGoogle extends AuthEvent{
  const AuthEventSignUpWithGoogle();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;

  const AuthEventRegister(this.email, this.password);
}

class AuthEventShouldRegister extends AuthEvent{
  const AuthEventShouldRegister();
}

class AuthEventLogOut extends AuthEvent{
  const AuthEventLogOut();
}

