import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:registration/services/crud/crudexceptions.dart';


class NotesServices {
  Database? _db;

  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);
    final updateCount = await db.update(noteTable, {
      textColumn: text,
      isSynchedWithCloudColumn: 0,
    });

    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      return await getNote(id: note.id);
    }
  }

  Future<List<DatabaseNote>> getAllNote() async {
    final db = _getDatabaseOrThrow();

    final notes = await db.query(noteTable);
    final results = notes.map((note) => DatabaseNote.fromRaw(note));
    final notesList = results.toList();
    return notesList;
  }

  Future<DatabaseNote> getNote({required id}) async {
    final db = _getDatabaseOrThrow();

    final notes = await db.query(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (notes.isEmpty) throw CouldNotFindNote();
    final note = DatabaseNote.fromRaw(notes.first);
    return note;
  }

  Future<int> deleteAllNote() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  Future<void> deleteNote({required id}) async {
    final db = _getDatabaseOrThrow();

    final noteCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (noteCount == 0) throw CouldNotDeleteNote();
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
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

    //Create an Instance of DatabaseNote
    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSynchedWithCloud: true,
    );

    return note;
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(userTable,
        where: 'email = ?', whereArgs: [email.toLowerCase()]);

    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
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
    if (_db != null) throw DatabaseAlreadyOpen();
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
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
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
