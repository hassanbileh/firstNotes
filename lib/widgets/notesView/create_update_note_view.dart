import 'package:flutter/material.dart';
import 'package:registration/services/auth/auth_services.dart';
import 'package:registration/services/crud/notes_service.dart';
import 'package:registration/utilities/generics/get_arguments.dart';

class CreateUpdateNoteVeiw extends StatefulWidget {
  const CreateUpdateNoteVeiw({super.key});

  @override
  State<CreateUpdateNoteVeiw> createState() => _CreateUpdateNoteVeiwState();
}

class _CreateUpdateNoteVeiwState extends State<CreateUpdateNoteVeiw> {
  DatabaseNote? _note;
  late final NotesServices _notesServices;
  late final TextEditingController _textController;

  @override
  @override
  void initState() {
    _notesServices = NotesServices();
    _textController = TextEditingController();
    super.initState();
  }

// fonction qui ecoute et enregistre la note instantannement que l'utilisateur tape sur le clavier
  void _textControllerListener() async {
    final note = _note;
    if (note != null) {
      final text = _textController.text;
      await _notesServices.updateNote(note: note, text: text);
    } else {
      return;
    }
    
    
  }

  void _setUpTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote> createOrUpdateExistingNote(BuildContext context) async {

    final widgetNote = context.getArguments<DatabaseNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final user = AuthService.firebase().currentUser!;
    final userEmail = user.email;
    final owner = await _notesServices.getUser(
      email: userEmail,
    );
    final newNote = await _notesServices.createNote(
      owner: owner,
    );
    _note = newNote;
    return newNote;
  }

// Fonction qui supprime la note si elle est vide lorsque le btton retour est touché
  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      await _notesServices.deleteNote(
        id: note.id,
      );
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesServices.updateNote(
        note: note,
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
                    decoration: const InputDecoration(hintText: 'Add your note here',),
                    keyboardType: TextInputType.multiline,
                  
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
