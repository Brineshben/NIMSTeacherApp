import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../Models/api_models/learning_walk_apply_model.dart';

class LessonLearningDatabase {
  static final LessonLearningDatabase instance = LessonLearningDatabase._init();

  static Database? _database;

  LessonLearningDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('lesson.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    print(path);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''CREATE TABLE $tableLessLearn( 
  ${LessonLearningFields.id} $idType, 
  ${LessonLearningFields.isLesson} $intType,
  ${LessonLearningFields.lessonLearning} $textType
  )''');
  }

  Future<LessonLearningApplyModel> create(LessonLearningApplyModel lessLearn) async {
    final db = await instance.database;

    final id = await db.insert(tableLessLearn, lessLearn.toJsonForDb());
    return lessLearn.copy(id: id);
  }

  Future<LessonLearningApplyModel> readLessonLearn(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableLessLearn,
      columns: LessonLearningFields.values,
      where: '${LessonLearningFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return LessonLearningApplyModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<LessonLearningApplyModel>> readAllLessonLearn() async {
    final db = await instance.database;

    final result = await db.query(tableLessLearn);

    return result.map((json) => LessonLearningApplyModel.fromJson(json)).toList();
  }

  Future<int> update(LessonLearningApplyModel lessonLearn) async {
    final db = await instance.database;

    return db.update(
      tableLessLearn,
      lessonLearn.toJson(),
      where: '${LessonLearningFields.id} = ?',
      whereArgs: [lessonLearn.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableLessLearn,
      where: '${LessonLearningFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTable() async {
    final db = await instance.database;
    return await db.delete(tableLessLearn);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
