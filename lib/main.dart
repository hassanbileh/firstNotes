// ignore_for_file: must_call_super, prefer_const_constructors, use_key_in_widget_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:registration/models/login_view.dart';
import 'package:registration/models/register_view.dart';
import 'package:registration/models/verif_email.dart';
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
      //? The initialRoute property defines which route the app should start with *Named Routes*
      initialRoute: '/',
      routes:  {
        '/': (context) =>  FirstScreen(),
        '/second': (context) =>  RegisterView(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class FirstScreen extends StatefulWidget {
  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {

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
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Error');
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              print(user);
              /*final emailVerfied = user?.emailVerified ?? false;
              if (emailVerfied) {
                return const Text('Done');
              } else {
                return const VerificationEmail();
              }*/

              return LoginView(); 
            default:
              return const CircularProgressIndicator();
          }
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
