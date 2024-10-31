import 'package:ai_mental_health_chatbot/screens/journal/models/journal_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Journals.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE Journal(id TEXT PRIMARY KEY, content TEXT NOT NULL, rate INTEGER NOT NULL);"),
        version: _version);
  }

  static Future<int> addJournal(Journal journal) async {
    final db = await _getDB();
    return await db.insert("Journal", journal.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateJournal(Journal journal) async {
    final db = await _getDB();
    return await db.update("Journal", journal.toJson(),
        where: 'id = ?',
        whereArgs: [journal.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Journal>?> getAllJournals() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query("Journal");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Journal.fromJson(maps[index]));
  }

  static Future<Journal?> getJournalById(String id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      "Journal",
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Journal.fromJson(maps.first);
    } else {
      return null;
    }
  }
}
