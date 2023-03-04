// ignore_for_file: must_call_super, prefer_const_constructors, use_key_in_widget_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:registration/widgets/login_view.dart';
import 'package:registration/widgets/main_ui.dart';
import 'package:registration/widgets/register_view.dart';
import 'package:registration/widgets/verif_email.dart';
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
      routes: {
        '/first': (context) => FirstScreen(),
        '/second': (context) => RegisterView(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: FirstScreen(),
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
    return FutureBuilder(
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
              if (user != null) {
                if (user.emailVerified) {
                  return MainUi();
                } else {
                  return VerificationEmail();
                }
              } else {
                return LoginView();
              }
              return MainUi();
            /*final emailVerfied = user?.emailVerified ?? false;
              if (emailVerfied) {
                return const Text('Done');
              } else {
                return const VerificationEmail();
              }*/
            default:
              return const CircularProgressIndicator();
          }
        }, // This trailing comma makes auto-formatting nicer for build methods.
      );
  }
}
