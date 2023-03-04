// ignore_for_file: prefer_const_constructors
import 'register_view.dart';
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
    return SizedBox(
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
              const Icon(Icons.person, color: Colors.blue,),
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
                    onPressed: () => submitData(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Dont have an account ?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/second');
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
    );
  }
}
