import 'package:flutter/material.dart';
import 'package:registration/services/crud/notes_service.dart';

import '../../utilities/dialogs/delete_dialog.dart';

typedef deleteNoteCallBack = void Function(DatabaseNote note);

class NotesList extends StatelessWidget {
  const NotesList({
    super.key,
    required this.notes,
    required this.onDeleteNote,
  });

  final List<DatabaseNote?> notes;
  final deleteNoteCallBack onDeleteNote;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(
            note!.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
          ),
        );
      },
    );
  }
}
