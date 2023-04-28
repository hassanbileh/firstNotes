// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:registration/constants/routes.dart';
import 'package:registration/services/auth/auth_exception.dart';
import 'package:registration/services/auth/auth_services.dart';
import 'package:registration/widgets/verif_email.dart';
import 'dart:developer' as devtools show log;

import '../utilities/greeting.dart';
import '../utilities/show_error_dialog.dart';
import 'main_ui.dart';

class RegisterView extends StatefulWidget {
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  _submitData() async {
    try {
      final email = _email.text;
      final password = _password.text;
      if (email.isEmpty || password.isEmpty) {
        return null;
      }
      final userCredential = await AuthService.firebase()
          .createUser(email: email, password: password);
      final user = AuthService.firebase().currentUser;
      await AuthService.firebase().sendEmailVerification();
      Navigator.of(context).pushNamedAndRemoveUntil(
        emailVerificationRoute,
        (_) => false,
      );

      devtools.log(userCredential.toString());
    } on WeakPasswordAuthException {
      await showErrorDialog(
          context,
          'Weak password',
        );
    } on EmailAlreadyInUseAuthException {
      await showErrorDialog(
          context,
          'Email already in use',
        );
    } on InvalidEmailAuthException {
      await showErrorDialog(
          context,
          'Invalid email',
        );
    } on GenericAuthException {
      await showErrorDialog(
          context,
          'Registration Error',
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
    super.dispose();
    // ignore: todo
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 50.0),
          child: Text(
            style: const TextStyle(
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
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                TextField(
                  controller: _email,
                  enableSuggestions: false, // important for the email
                  autocorrect: false, // important for the email
                  keyboardType: TextInputType.emailAddress,
                  onSubmitted: (_) => _submitData(),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Enter your email here',
                    labelText: 'Email',
                  ),
                ),
                TextField(
                  controller: _password,
                  obscureText: true, // important for the password
                  enableSuggestions: false, // important for the password
                  autocorrect: false, // important for the password
                  decoration: const InputDecoration(
                    icon: Icon(Icons.password),
                    hintText: 'Enter your password here',
                    labelText: 'Password',
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    OutlinedButton(
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () => _submitData(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('You  have an account ?'),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                loginRoute, (route) => false);
                          },
                          child: const Text('Sign In'),
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
