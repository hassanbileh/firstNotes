import 'package:flutter/material.dart';
import 'package:registration/services/cloud/cloud_note.dart';

import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesList extends StatelessWidget {
  const NotesList({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  final Iterable<CloudNote?> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return Card(
          elevation: 2,
          child: Dismissible(
            key: ValueKey(notes.elementAt(index)),
            onDismissed: (direction) async {
              final shouldDelete = await showDeleteDialog(context);
                  if (shouldDelete) {
                    onDeleteNote(note);
                  }
            },
            background: Container(color: Theme.of(context).colorScheme.error,),
            child: ListTile(
              onTap:() {
                onTap(note);
              },
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
            ),
          ),
        );
      },
    );
  }
}
