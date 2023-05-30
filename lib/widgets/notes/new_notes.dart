import 'package:flutter/material.dart';
import 'package:registration/services/auth/auth_services.dart';
import 'package:registration/services/crud/notes_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
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

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final user = AuthService.firebase().currentUser!;
    final userEmail = user.email!;
    final owner = await _notesServices.getUser(
      email: userEmail,
    );
    final dbNote = await _notesServices.createNote(
      owner: owner,
    );
    return dbNote;
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
          future: createNewNote(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _note = snapshot.data as DatabaseNote?;
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
