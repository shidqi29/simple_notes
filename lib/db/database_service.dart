import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/note.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService db = DatabaseService._();

  static Database? _database;

  //GETTER untuk database
  Future<Database?> get database async {
    //CEK DATABASE
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  //INISIALISASI DATABASE
  initDB() async {
    return await openDatabase(
      join(
        await getDatabasesPath(),
        'notes.db',
      ),
      version: 1,
      onCreate: (db, version) {
        // CREATE DATABASE TABLE
        db.execute('''
CREATE TABLE notes(
  id INTEGER AUTOINCREMENT PRIMARY KEY,
  title TEXT,
  desc TEXT,
  createdAt DATE
)
''');
      },
    );
  }

  // ADD NOTE
  addNewNote(Note note) async {
    final db = await database;
    db!.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // GET ALL NOTES
  Future getNotes() async {
    final db = await database;
    var result = await db!.query('notes');
    if (result.isEmpty) {
      return null;
    } else {
      var lastResult = result.toList();
      return lastResult.isNotEmpty ? lastResult : null;
    }
  }

  // EDIT NOTE
  Future<int> updateNote(Note note) async {
    final db = await database;
    var result = db!.rawUpdate('''
UPDATE notes SET title = "${note.title}", desc = "${note.desc}"
WHERE id = ${note.id}
''');
    return result;
  }

  // DELETE NOTE
  Future<int> deleteNote(int id) async {
    final db = await database;
    int count = await db!.rawDelete(
      'DELETE FROM notes WHERE id = ?',
      [id],
    );
    return count;
  }
}
