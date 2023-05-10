import'package:flutter/material.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  
  late final TextEditingController noteText; 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(1),
        title: const Text('New Note'),
      ),
      body: const SingleChildScrollView(
        child: TextField(
            maxLines: 200,
          ),
      ),
    );
  }
}