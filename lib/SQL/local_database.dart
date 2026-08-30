import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:note_app/Data/note_data.dart';

class NotesDatabase {
  static final NotesDatabase _instance = NotesDatabase._internal();
  factory NotesDatabase() => _instance;
  NotesDatabase._internal();

  static const String _fileName = 'note_database.db';
  static const String _tableName = 'notes';

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, _fileName);

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            body TEXT NOT NULL,
            date TEXT NOT NULL,
            color TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<NoteData>> readData() async {
    final db = await database;
    final maps = await db.query(_tableName, orderBy: 'id DESC');
    return maps.map(NoteData.fromMap).toList();
  }

  Future<int> insertData(NoteData note) async {
    final db = await database;
    return db.insert(
      _tableName,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateData(NoteData note) async {
    final db = await database;
    return db.update(
      _tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteData(NoteData note) async {
    final db = await database;
    return db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteMultiple(List<int> ids) async {
    if (ids.isEmpty) return;
    final db = await database;
    final placeholders = List.filled(ids.length, '?').join(',');
    await db.delete(
      _tableName,
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
  }
}

