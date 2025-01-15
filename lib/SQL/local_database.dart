import 'dart:async';

import 'package:note_app/Data/note_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

class NotesDatabase {
  //! Variables
  static Database? _db;
  final String fileName = 'note_database.db';
  final String tableName = 'notes';

  //! Init Database
  Future<Database?> get database async {
    if (_db == null) {
      _db = await init();
      return _db;
    }
    return _db;
  }

  init() async {
    String path = await getDatabasesPath();
    String file = join(path, fileName);
    Database db = await openDatabase(file, onCreate: _onCreate, version: 1);

    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $tableName(id INTEGER NOT NULL PRIMARY KEY, title TEXT, body TEXT, date TEXT, color TEXT)',
    );

    if (kDebugMode) {
      print('CREATE DATABASE ✔');
    }
  }

  //! Get Data
  Future<List<NoteData>> readData() async {
    Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(tableName);

    return List.generate(maps.length, (i) {
      return NoteData(
        id: maps[i]['id'],
        body: maps[i]['body'],
        date: maps[i]['date'],
        color: maps[i]['color'],
        title: maps[i]['title'],
      );
    });
  }

  //! Add Data
  Future<void> insertData(NoteData data) async {
    Database? db = await database;
    await db!.insert(
      tableName,
      {
        'id': data.id,
        'body': data.body,
        'date': data.date,
        'color': data.color,
        'title': data.title,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //! Update Data
  Future<void> updateData(NoteData data) async {
    Database? db = await database;
    await db!.update(
      tableName,
      {
        'id': data.id,
        'body': data.body,
        'date': data.date,
        'color': data.color,
        'title': data.title,
      },
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  //! Remove Data
  Future<void> deleteData(NoteData data) async {
    Database? db = await database;
    await db?.rawDelete(
      'DELETE FROM $tableName WHERE id = ?',
      [data.id],
    );
  }
}
