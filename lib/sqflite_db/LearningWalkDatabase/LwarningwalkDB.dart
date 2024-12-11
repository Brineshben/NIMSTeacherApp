import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../Models/api_models/LearningwalkSubmit.dart';

class LearningWalkDB {
  static final LearningWalkDB instance = LearningWalkDB._internal();

  factory LearningWalkDB() => instance;
  static Database? _database;

  LearningWalkDB._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'learning_walk.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
         CREATE TABLE learning_walks (
  id INTEGER PRIMARY KEY,
  academic_year TEXT,
  added_by TEXT,
  added_date TEXT,
  batch_id TEXT,
  class_id TEXT,
  curriculum_id TEXT,
  even_better_if TEXT,
  lw_focus TEXT,
  notes TEXT,
  observation_date TEXT,
  observer_roles TEXT,
  qs_to_puple TEXT,
  qs_to_teacher TEXT,
  school_id TEXT,
  sender_id TEXT,
  session_id TEXT,
  what_went_well TEXT
);

        ''');
      },
    );
  }

  Future<int> insertLearningWalk(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('learning_walks', data);
  }
  Future<int> deleteLearningWalk(int id) async {
    final db = await database;
    return await db.delete(
      'learning_walks',
      where: 'id = ?', // Specify the condition for deletion
      whereArgs: [id], // Pass the id of the row to delete
    );
  }
  Future<List<LearningwalkSubmitModel>> fetchLearningWalks() async {
    final db = await database;
    List<Map<String, dynamic>> data = await db.query('learning_walks');
    List<LearningwalkSubmitModel> resp = data.map((e) => LearningwalkSubmitModel.fromJson(e)).toList();
    return resp;
  }


}
