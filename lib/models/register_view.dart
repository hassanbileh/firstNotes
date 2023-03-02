// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      if (email.isEmpty || password.isEmpty) {
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Icon(Icons.person),
            SizedBox(width: 15,),
            Text('SignUp',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ))
          ],
        ),
      ),
      body: Card(
        elevation: 4,
        borderOnForeground: true,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _email,
                enableSuggestions: false, // important for the email
                autocorrect: false, // important for the email
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Email',
                  hintText: 'Enter your email here',
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true, // important for the password
                enableSuggestions: false, // important for the password
                autocorrect: false, // important for the password
                decoration: const InputDecoration(
                  icon: Icon(Icons.password),
                  labelText: 'Password',
                  hintText: 'Enter your password here',
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    OutlinedButton(
                      child: const Text(
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
      ),
    );
  }
}
