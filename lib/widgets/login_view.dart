// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:registration/constants/routes.dart';
import 'package:registration/services/auth/auth_exception.dart';
import 'package:registration/services/auth/auth_services.dart';
import '../utilities/greeting.dart';
import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();

  void dispose() {}
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

// ? function de login et redirection vers le mainui
  void _submitData() async {
    try {
      final email = _email.text;
      final password = _password.text;
      final userCredential = await AuthService.firebase().logIn(
        email: email,
        password: password,
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
        notesRoute,
        (_) => false,
      );
      final user = AuthService.firebase().currentUser;
      if (user?.isEmailVerified ?? false) {
        // user's email verified
        Navigator.of(context)
            .pushNamedAndRemoveUntil(notesRoute, (route) => false);
      } else {
        // user email is NOT veerified
        Navigator.of(context)
            .pushNamedAndRemoveUntil(emailVerificationRoute, (route) => false);
      }
    } on UserNotFoundAuthException {
      await showErrorDialog(
        context,
        'User not found',
      );
    } on WrongPasswordAuthException {
      await showErrorDialog(
        context,
        'Wrong password',
      );
    } on GenericAuthException {
      await showErrorDialog(
        context,
        'Authentication error',
      );
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 50.0),
          child: Text(
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            greeting(),
          ),
        ),
        shadowColor: Colors.lightBlue,
      ),
      body: SizedBox(
        height: 330,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          borderOnForeground: true,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Sign In',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                const Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                TextField(
                  controller: _email,
                  enableSuggestions: false, //? important for the email
                  autocorrect: false, //? important for the email
                  keyboardType: TextInputType.emailAddress,
                  onSubmitted: (_) => _submitData(),
                  decoration: InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Enter your email here',
                    labelText: 'Email',
                  ),
                ),
                TextField(
                  controller: _password,
                  obscureText: true, // important for the password
                  enableSuggestions: false, // important for the password
                  autocorrect: false, // important for the password
                  decoration: InputDecoration(
                    icon: const Icon(Icons.password),
                    hintText: 'Enter your password here',
                    labelText: 'Password',
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    OutlinedButton(
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () => _submitData(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account ?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              registerRoute,
                            );
                          },
                          child: Text('Sign Up'),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
