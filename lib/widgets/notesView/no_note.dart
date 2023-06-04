import 'package:flutter/material.dart';

class NoNote extends StatelessWidget {
  const NoNote({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'No Note added yet',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        SizedBox(
          height: 300,
          width: 400,
          child: Image.asset('lib/assets/images/waiting.png'),
        ),
      ],
    );
  }
}
