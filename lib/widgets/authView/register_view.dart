// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:registration/constants/routes.dart';
import 'package:registration/services/auth/auth_exception.dart';
import 'package:registration/services/auth/auth_services.dart';
import 'dart:developer' as devtools show log;
import '../../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
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
      AuthService.firebase().sendEmailVerification();
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
    } on UserNotLoggedInAuthException {
      await showErrorDialog(
        context,
        'failed to resgister',
      );
    }
  }

  void _signInWithGoogle() async {
    try {
      final userCredential = await AuthService.firebase().signInWithGoogle();
      final user = AuthService.firebase().currentUser;
      if (user!.isEmailVerified == false) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(emailVerificationRoute, (route) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(notesRoute, (route) => false);
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
    super.dispose();
    // ignore: todo
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 95,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Welcome, create an account below.',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //? Email Field
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: _email,
                      enableSuggestions: true, //? important for the email
                      autocorrect: false, //? important for the email
                      keyboardType: TextInputType.emailAddress,
                      onSubmitted: (_) => _submitData(),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        icon: const Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        hintText: 'Enter your email here',
                      ),
                    ),
                  ),

                  //? Password Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _password,
                      obscureText: true, // important for the password
                      enableSuggestions: false, // important for the password
                      autocorrect: false, // important for the password
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        icon: const Icon(
                          Icons.password,
                          color: Colors.blue,
                        ),
                        hintText: 'Enter your password here',
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 60,
                        width: 330,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: OutlinedButton(
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => _submitData(),
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Do you have an account ?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      loginRoute, (route) => false);
                                },
                                child: const Text(
                                  'Login here',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      thickness: 0.8,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  const Text('Or create an account with'),
                                  Expanded(
                                    child: Divider(
                                      thickness: 0.8,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                height: 60,
                                width: 330,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue[40],
                                ),
                                child: OutlinedButton(
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                          'lib/assets/images/googleit.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Text(
                                        'Sign Up with Google',
                                        style: TextStyle(
                                            color: Colors.blue[500],
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  onPressed: () => _signInWithGoogle(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
