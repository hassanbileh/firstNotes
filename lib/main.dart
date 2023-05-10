// ignore_for_file: must_call_super, prefer_const_constructors, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:registration/constants/routes.dart';
import 'package:registration/services/auth/auth_services.dart';
import 'package:registration/widgets/notes/new_notes.dart';
import 'widgets/login_view.dart';
import 'widgets/notes/main_ui.dart';
import 'widgets/register_view.dart';
import 'widgets/verif_email.dart';

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
        firstRoute: (context) => const FirstScreen(),
        registerRoute: (context) => const RegisterView(),
        loginRoute: (context) => const LoginView(),
        notesRoute: (context) => const MainUi(),
        emailVerificationRoute: (context) => const VerificationEmail(),
        newNoteRoute: (context) => const NewNoteView(),
      },
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});
  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  // ? Fonction de Greeting par rapport a l'heure

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialise(),
      builder: (ctx, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('Error');
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;

            //? Verifier si le user est connecté
            if (user != null) {
              if (user.isEmailVerified) {
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
      }, //? This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
