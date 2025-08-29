import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quiz_app.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE quiz_attempts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT,
        category_id INTEGER,
        category_name TEXT,
        attempt_date TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE quiz_answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        attempt_id INTEGER,
        question TEXT,
        user_answer TEXT,
        correct_answer TEXT,
        is_correct INTEGER,
        FOREIGN KEY (attempt_id) REFERENCES quiz_attempts(id)
      )
    ''');
  }

  // Insert or update user
  Future<void> insertUser(String id, String email) async {
    final db = await database;
    await db.insert(
      'users',
      {'id': id, 'email': email},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insert quiz attempt
  Future<int> insertQuizAttempt(String userId, int categoryId, String categoryName) async {
    final db = await database;
    return await db.insert(
      'quiz_attempts',
      {
        'user_id': userId,
        'category_id': categoryId,
        'category_name': categoryName,
        'attempt_date': DateTime.now().toIso8601String(),
      },
    );
  }

  // Insert quiz answer
  Future<void> insertQuizAnswer(
      int attemptId, String question, String? userAnswer, String correctAnswer, bool isCorrect) async {
    final db = await database;
    await db.insert(
      'quiz_answers',
      {
        'attempt_id': attemptId,
        'question': question,
        'user_answer': userAnswer,
        'correct_answermarkAttemptAsCompleted': correctAnswer,
        'is_correct': isCorrect ? 1 : 0,
      },
    );
  }

  // Get user quiz history
  Future<List<Map<String, dynamic>>> getQuizHistory(String userId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        qa.id as attempt_id,
        qa.category_id,
        qa.category_name,
        qa.attempt_date,
        COUNT(qans.id) as total_questions,
        SUM(qans.is_correct) as correct_answers
      FROM quiz_attempts qa
      LEFT JOIN quiz_answers qans ON qa.id = qans.attempt_id
      WHERE qa.user_id = ?
      GROUP BY qa.id, qa.category_id, qa.category_name, qa.attempt_date
    ''', [userId]);
  }

  // Get quiz answers for an attempt
  Future<List<Map<String, dynamic>>> getQuizAnswers(int attemptId) async {
    final db = await database;
    return await db.query(
      'quiz_answers',
      where: 'attempt_id = ?',
      whereArgs: [attemptId],
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}