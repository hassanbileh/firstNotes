// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:registration/constants/routes.dart'; //? log est une alternative a print

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();

  void dispose() {}
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  String _greeting() {
    const String goodMorning = 'Good Morning';
    const String goodAfter = 'Good Afternoon';
    const String goodEven = 'Good Evening';
    final hour = TimeOfDay.now().hour;
    if (hour <= 12) {
      return goodMorning;
    } else if (hour <= 18) {
      return goodAfter;
    } else {
      return goodEven;
    }
  }

// ? function de login et redirection vers le mainui
  void _submitData() async {
    try {
      final email = _email.text;
      final password = _password.text;
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      devtools.log(userCredential.toString());
      Navigator.of(context).pushNamedAndRemoveUntil(
        notesRoute,
        (_) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        devtools.log('User not found');
      } else if (e.code == 'wrong-password') {
        devtools.log('Wrong Password');
      }
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
            _greeting(),
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
                        Text('Dont have an account ?'),
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
