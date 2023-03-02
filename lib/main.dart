// ignore_for_file: must_call_super, prefer_const_constructors
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:registration/models/login_view.dart';
import 'package:registration/models/register_view.dart';
import 'firebase_options.dart';

void main() {
  // To initialise Firebase when our app start
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // ? This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign In',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  @override
  State<FirstScreen> createState() => _FirstScreenState();

  void dispose() {}
}

class _FirstScreenState extends State<FirstScreen> {
  
  // ? fenetre de popup champs register
  void _startAddNewUser(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return RegisterView();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

// ? Fonction de Greeting par rapport a l'heure
  String _greeting() {
    final hour = TimeOfDay.now().hour;
    if (hour <= 12) {
      return 'Good Morning';
    } else if (hour <= 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

// ? Fonction de popup champs Login
  void _startLoginUser(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return LoginView();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 45.0),
          child: Text(
            _greeting(),
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        shadowColor: Colors.lightBlue,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => _startLoginUser(context),
                child: Text(
                  'SignIn',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(
                child: Text('/'),
              ),
              TextButton(
                onPressed: () => _startAddNewUser(context),
                child: Text(
                  'SignUp',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          )
        ],
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Error');
              break;
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              final emailVerfied = user?.emailVerified ?? false;
              if (emailVerfied) {
                print('Your email\'s verified');
              } else {
                print('you need to verify your email');
              }
              return Center(
                child: Container(
                  height: 200,
                  width: 300,
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          './lib/images/waiting.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        'Welcome to our application',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              );
            default:
              return Text('Loading ...');
          }
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}





/*class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late final RegisterView _register;
  late final LoginView _login;

  @override
  void initState() {
    // TODO: implement initState
    _register = RegisterView(title: 'Register');
    _login = LoginView();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _register.dispose();
    _login.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Card(
        elevation: 3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _register,
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: () => _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
