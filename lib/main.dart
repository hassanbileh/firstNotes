// ignore_for_file: must_call_super, prefer_const_constructors, use_key_in_widget_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:registration/constants/routes.dart';
import 'widgets/login_view.dart';
import 'widgets/main_ui.dart';
import 'widgets/register_view.dart';
import 'widgets/verif_email.dart';
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
        firstRoute: (context) => FirstScreen(),
        registerRoute: (context) => RegisterView(),
        loginRoute: (context) => LoginView(),
        notesRoute: (context) => MainUi(),
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (ctx, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('Error');
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;

            // Verifier si le user est connecté
            if (user != null) {
              if (user.emailVerified) {
                  return const MainUi();
                } else {
                  return const VerificationEmail();
                }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      }, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
