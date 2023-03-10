import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:registration/widgets/main_ui.dart';

import '../utilities/greeting.dart';

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
        height: 150,
        width: double.infinity,
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.dangerous),
              const Text('Please verify your email'),
              TextButton(
                style: ButtonStyle(
                    mouseCursor: MaterialStateMouseCursor.clickable),
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  final isUserVerified = user?.emailVerified;
                },
                child: Text('Send email verification'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
