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
  late final TextEditingController _noteTextController;

  @override
  @override
  void initState() {
    _notesServices = NotesServices();
    _noteTextController = TextEditingController();
    super.initState();
  }

// fonction qui ecoute et enregistre la note instantannement que l'utilisateur tape sur le clavier
  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    await _notesServices.updateNote(note: note, text: _noteTextController.text);
  }

  void _setUpTextControllerListener() {
    _noteTextController.removeListener(_textControllerListener);
    _noteTextController.addListener(_textControllerListener);
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
  void _deleteNoteIfIsEmpty() async {
    final note = _note;
    if (_noteTextController.text.isEmpty && note != null) {
      await _notesServices.deleteNote(
        id: note.id,
      );
    }
  }

  void _saveNoteIsNotEmpty() async {
    final note = _note;
    if (note != null && _noteTextController.text.isNotEmpty) {
      await _notesServices.updateNote(
        note: note,
        text: _noteTextController.text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfIsEmpty();
    _saveNoteIsNotEmpty();
    _noteTextController.dispose();
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
                _note = snapshot.data;
                _setUpTextControllerListener();
                return const SingleChildScrollView(
                  child: TextField(
                    maxLines: 200,
                    decoration: InputDecoration(hintText: 'Add your note here',),
                    keyboardType: TextInputType.multiline,
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
