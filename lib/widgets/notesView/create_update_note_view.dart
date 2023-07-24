import 'package:flutter/material.dart';
import 'package:registration/services/auth/auth_services.dart';
import 'package:registration/utilities/generics/get_arguments.dart';
import 'package:registration/services/cloud/cloud_note.dart';
import 'package:registration/services/cloud/firebase_cloud_storage.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesServices;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesServices = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

// fonction qui ecoute et enregistre la note instantannement que l'utilisateur tape sur le clavier
  void _textControllerListener() async {
    final note = _note;
    if (note != null) {
      final text = _textController.text;
      await _notesServices.updateNote(
        text: text,
        documentId: note.documentId,
      );
    } else {
      return;
    }
  }

  void _setUpTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

// ? Créer ou Modifier Note
  Future<CloudNote> createOrUpdateExistingNote(BuildContext context) async {
    //Getting arguments passed in navigator route
    final widgetNote = context.getArguments<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    } else {
      final user = AuthService.firebase().currentUser!;
      final userId = user.id;
      final newNote = await _notesServices.createNewNote(ownerUserId: userId);
      _note = newNote;
      return newNote;
    }
  }

// Fonction qui supprime la note si elle est vide lorsque le btton retour est touché
  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      await _notesServices.deleteNote(documentId: note.documentId);
    }
  }

// Fonction qui enregistre la note si elle n'est pas vide lorsque le btton retour est touché
  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesServices.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(1),
          title: const Text('New Note'),
        ),
        body: FutureBuilder(
          future: createOrUpdateExistingNote(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setUpTextControllerListener();
                return TextField(
                  controller: _textController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Add your note here',
                  ),
                  keyboardType: TextInputType.multiline,
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
