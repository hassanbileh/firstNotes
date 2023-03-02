// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();

  void dispose() {}
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  void submitData() async {
      try {
        final email = _email.text;
        final password = _password.text;
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        print(userCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('Invalid User');
        } else if (e.code == 'wrong-password') {
          print('Wrong Password');
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
    return Card(
      elevation: 4,
      borderOnForeground: true,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.person),
            TextField(
              controller: _email,
              enableSuggestions: false, // important for the email
              autocorrect: false, // important for the email
              keyboardType: TextInputType.emailAddress,
              onSubmitted: (_) => submitData(),
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
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  OutlinedButton(
                    child: Text(
                      'SignIn',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () => submitData(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
