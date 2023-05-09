import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:registration/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:registration/services/crud/crudexceptions.dart';

class NotesServices {
  Database? _db;

  List<DatabaseNote> _notes = [];

  static final _shared = NotesServices._sharedInstance();
  NotesServices._sharedInstance();
  factory NotesServices() => _shared;

  final _notesStreamController =
      StreamController<List<DatabaseNote>>.broadcast();
  
  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;

  Future<DatabaseUser> getOrCreateUser({required email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on UserDoNotExist {
      final newUser = await createUser(email: email);
      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cachNotes() async {
    final allNotes = await getAllNote();

    //? Add the notes to _notes list
    _notes = allNotes;
    _notesStreamController.add(_notes);
  }

  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // Make sure note exists
    await getNote(id: note.id);
    final updateCount = await db.update(noteTable, {
      textColumn: text,
      isSynchedWithCloudColumn: 0,
    });

    // Updating the DB
    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }

  Future<List<DatabaseNote>> getAllNote() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final notes = await db.query(noteTable);
    final results = notes.map((note) => DatabaseNote.fromRaw(note));
    final notesList = results.toList();
    return notesList;
  }

  Future<DatabaseNote> getNote({required id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final notes = await db.query(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (notes.isEmpty) throw CouldNotFindNote();
    final note = DatabaseNote.fromRaw(notes.first);

    //? Forcing the List to update when we want to get a note
    _notes.removeWhere((note) => note.id == id);
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<int> deleteAllNote() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletionCount = await db.delete(noteTable);
    _notes = [];
    _notesStreamController.add(_notes);
    return deletionCount;
  }

  Future<void> deleteNote({required id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final noteCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (noteCount == 0) {
      throw CouldNotDeleteNote();
    } else {
      //? Removing note from NotesList
      _notes.removeWhere((note) => note.id == id);
      //? Adding the new list on the Stream
      _notesStreamController.add(_notes);
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // check if owner exists in the db
    final user = await getUser(email: owner.email);
    if (user != owner) {
      throw UserDoNotExist();
    }

    // Add note in db
    const text = '';
    final noteId = await db.insert(noteTable, {
      emailColumn: owner.email,
      textColumn: text,
      isSynchedWithCloudColumn: 1,
    });

    //Create an Instance of a DatabaseNote
    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSynchedWithCloud: true,
    );
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(userTable,
        where: 'email = ?', whereArgs: [email.toLowerCase()]);

    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // Query the db to check if user already exists
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    // if the results list is not empty throw exception
    if (results.isNotEmpty) {
      throw UserAlreadyExist();
    }
    // Insert user in the database
    final userId = await db.insert(
      userTable,
      {
        emailColumn: email.toLowerCase(),
      },
    );
    return DatabaseUser(
      id: userId,
      email: email,
    );
  }

  Future<DatabaseUser> getUser({required email}) async {
    //await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw UserDoNotExist();
    } else {
      return DatabaseUser.fromRaw(results.first);
    }
  }

//get db or throw Exception
  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsClosed();
    } else {
      return db;
    }
  }

// Open the db
  Future<void> open() async {
    await _ensureDbIsOpen();
    try {
      // Get Doc Directory Path from sqflite package
      final docPath = await getApplicationDocumentsDirectory();

      //Joining the docPath with databasePath
      final dbPath = join(docPath.path, dbName);

      //Open the Database
      final db = await openDatabase(dbPath);

      // Execute createUser sql script
      await db.execute(createUserTable);

      // Execute createNote sql script
      await db.execute(createNoteTable);
      await _cachNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

//S'assurer que la BD est ouverte
  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpen {
      //empty
      throw DatabaseAlreadyOpen();
    }
  }

// Close the db
  Future<void> close() async {
    final db = _db;
    (db == null) ? throw DatabaseIsClosed() : await db.close();
    _db = null;
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRaw(Map<String, Object?> user)
      : id = user[idColumn] as int,
        email = user[emailColumn] as String;

  @override
  String toString() => 'Person : ID = $id, Email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSynchedWithCloud;

  const DatabaseNote(
      {required this.id,
      required this.userId,
      required this.text,
      required this.isSynchedWithCloud});

  DatabaseNote.fromRaw(Map<String, Object?> note)
      : id = note[idColumn] as int,
        userId = note[userIdColumn] as int,
        text = note[textColumn] as String,
        isSynchedWithCloud =
            (note[isSynchedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note : ID = $id, UserID = $userId, IsSynchedWithCloud = $isSynchedWithCloud';
  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSynchedWithCloudColumn = 'is_synched_with_cloud';

//Create User table if not exist script
const createUserTable = '''
        CREATE TABLE IF NOT EXISTS "user" (
          "id"	INTEGER NOT NULL,
          "email"	TEXT NOT NULL UNIQUE,
          PRIMARY KEY("id" AUTOINCREMENT)
        );
      ''';

//Create Note table if not exist script
const createNoteTable = '''
        CREATE TABLE IF NOT EXISTS "note" (
          "id"	INTEGER NOT NULL,
          "user_id"	INTEGER NOT NULL,
          "text"	TEXT NOT NULL,
          "is_synched_with_cloud"	INTEGER NOT NULL DEFAULT 0,
          PRIMARY KEY("id" AUTOINCREMENT),
          FOREIGN KEY("user_id") REFERENCES "user"("id")
        );
      ''';
