// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocListener, ReadContext;
import 'package:registration/services/auth/auth_exception.dart';
import 'package:registration/services/auth/bloc/auth_bloc.dart';
import 'package:registration/services/auth/bloc/auth_event.dart';
import 'package:registration/services/auth/bloc/auth_state.dart';
import 'package:registration/utilities/dialogs/loading_dialog.dart';
import '../../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;

// ? function de login et redirection vers le mainui
  void _submitData() async {
    final email = _email.text;
    final password = _password.text;

    context.read<AuthBloc>().add(
          AuthEventLogIn(
            email,
            password,
          ),
        );
  }

// Fonction d'ajout grace a google

  void _signInWithGoogle() async {
    context.read<AuthBloc>().add(const AuthEventSignInWithGoogle());
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLogOut) {
          final closeDialog = _closeDialogHandle;

          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialogHandle = null;
          } else if (state.isLoading && closeDialog == null) {
            _closeDialogHandle = showLoadingDialog(
              context: context,
              text: 'loading...',
            );
          }

          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              'User not found',
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
              context,
              'Wrong credentials',
            );
          } else if (state.exception is GenericAuthException){
            await showErrorDialog(
              context,
              'Generic Auth Error',
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
                        color: Colors.blue,
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
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          icon: const Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
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
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          icon: const Icon(
                            Icons.password,
                            color: Colors.blue,
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
                            color: Colors.blue,
                          ),
                          child: OutlinedButton(
                            child: Text(
                              'Sign In',
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
                                    context.read<AuthBloc>().add(
                                          const AuthEventShouldRegister(),
                                        );
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
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
                                    const Text('  Or  '),
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
                                Container(
                                  height: 60,
                                  width: 330,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue[40],
                                  ),
                                  child: OutlinedButton(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                            'lib/assets/images/googleit.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                          'Sign In with Google',
                                          style: TextStyle(
                                              color: Colors.blue[500],
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    onPressed: () => _signInWithGoogle(),
                                  ),
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
      ),
    );
  }
}
