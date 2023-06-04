import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registration/services/cloud/cloud_note.dart';
import 'package:registration/services/cloud/cloud_storage_constants.dart';
import 'package:registration/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({
    required String documentId,
  }) async{
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNotException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  //Getting all updated notes with snapshot() methode
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  void createNewNote({required String ownerUserId}) async {
    await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
  }

  //Getting notes by userId
  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                return CloudNote(
                  documentId: doc.id,
                  ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                  text: doc.data()[textFieldName] as String,
                );
              },
            ),
          );
    } catch (e) {
      throw CloudNotGetAllNotesException();
    }
  }

  //? Make a singleton
  // 1- create a private constructor
  FirebaseCloudStorage._sharedInstance();

  // 2- create a factory constructor who talk with a static final variable
  factory FirebaseCloudStorage() => _shared;

  // 3- create the static final var who talk with the private constructor in 1
  static final _shared = FirebaseCloudStorage._sharedInstance();
}
