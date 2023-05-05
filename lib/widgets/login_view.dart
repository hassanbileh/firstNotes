// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:registration/constants/routes.dart';
import 'package:registration/services/auth/auth_exception.dart';
import 'package:registration/services/auth/auth_services.dart';
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
      await AuthService.firebase().sendEmailVerification();
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

// Fonction d'ajout grace a google

  void _signInWithGoogle() async {
    try {
      final userCredential = await AuthService.firebase().signInWithGoogle();
      final user = AuthService.firebase().currentUser;
      Navigator.of(context)
            .pushNamedAndRemoveUntil(notesRoute, (route) => false);
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
      backgroundColor: Colors.grey[350],
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
                      color: Colors.black87,
                      size: 95,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Welcome back, you\'ve been missed',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
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
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        icon: const Icon(Icons.person),
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
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        icon: const Icon(
                          Icons.password,
                        ),
                        hintText: 'Enter your password here',
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forget the password ?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 60,
                        width: 330,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        child: OutlinedButton(
                          child: Text(
                            'Login',
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
                              Text('Don\'t have an account ?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      registerRoute, (route) => false);
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20,),
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
                                  Text('Or continue with'),
                                  Expanded(
                                    child: Divider(
                                      thickness: 0.8,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: Image.asset(
                                      'lib/assets/images/googleit.png',
                                      height: 70,
                                      width: 60,
                                    ),
                                    onTap: () => _signInWithGoogle(),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    child: Image.asset(
                                      'lib/assets/images/instagram.png',
                                      height: 90,
                                      width: 90,
                                    ),
                                    onTap: () => _signInWithGoogle(),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    child: Image.asset(
                                      'lib/assets/images/apple.png',
                                      height: 90,
                                      width: 90,
                                    ),
                                    onTap: () => _signInWithGoogle(),
                                  ),
                                  
                                  
                                ],
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
