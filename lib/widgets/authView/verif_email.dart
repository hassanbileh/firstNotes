
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration/services/auth/bloc/auth_bloc.dart';
import 'package:registration/services/auth/bloc/auth_event.dart';

import '../../constants/greeting.dart';

class VerificationEmail extends StatefulWidget {
  const VerificationEmail({super.key});

  @override
  State<VerificationEmail> createState() => _VerificationEmailState();
}

class _VerificationEmailState extends State<VerificationEmail> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 50.0),
          child: Text(
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            greeting(),
          ),
        ),
        shadowColor: Colors.lightBlue,
      ),
      
      body: Container(
        margin: const EdgeInsets.all(20),
        height: 200,
        width: double.infinity,
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.dangerous),
              const Text(
                  'We\'ve send you a message to your email, please check in order tou verify your account'),
              const Text(
                  'If you\'ve not received any message, click the button below'),
              TextButton(
                style: const ButtonStyle(
                    mouseCursor: MaterialStateMouseCursor.clickable),
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
                },
                child: const Text('Send email verification'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text('Restart'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
