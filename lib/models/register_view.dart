import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  void _submitData() async {
    try {
      final email = _email.text;
      final password = _password.text;
      if (email.isEmpty || password.isEmpty ){
      return;
    } 
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Weak Password');
      } else if (e.code == 'email-already-in-use') {
        print('Email already in use');
      }
      Navigator.of(context).pop();
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
            TextField(
              controller: _email,
              enableSuggestions: false, // important for the email
              autocorrect: false, // important for the email
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: const Icon(Icons.person),
                labelText: 'Email',
                hintText: 'Enter your email here',
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true, // important for the password
              enableSuggestions: false, // important for the password
              autocorrect: false, // important for the password
              decoration: InputDecoration(
                icon: const Icon(Icons.password),
                labelText: 'Password',
                hintText: 'Enter your password here',
                
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  OutlinedButton(
                    child: Text(
                      'SignUp',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () => _submitData(),
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
