// ignore_for_file: must_call_super, prefer_const_constructors, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration/constants/routes.dart';
import 'package:registration/services/auth/bloc/auth_bloc.dart';
import 'package:registration/services/auth/bloc/auth_event.dart';
import 'package:registration/services/auth/bloc/auth_state.dart';
import 'package:registration/services/auth/firebase_auth_provider.dart';
import 'package:registration/widgets/notesView/create_update_note_view.dart';
import 'widgets/authView/login_view.dart';
import 'widgets/notesView/main_ui.dart';
import 'widgets/authView/register_view.dart';
import 'widgets/authView/verif_email.dart';

void main() {
  // To initialise Firebase when our app start
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // ? This widget is the root of your application

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
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const FirstScreen(),
      ),
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
    context.read<AuthBloc>().add(AuthEventInitialize());

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const MainUi();
        } else if (state is AuthStateNeedsVerification) {
          return const VerificationEmail();
        } else if (state is AuthStateLogOut) {
          return LoginView();
        } else {
          return Scaffold(
              body: SafeArea(child: const CircularProgressIndicator()));
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValidNumber extends CounterState {
  const CounterStateValidNumber(int value) : super(value);
}

// class CounterStateInValidNumber extends CounterState{
//   final String invalidValue;
//   final int previousValue;
// }