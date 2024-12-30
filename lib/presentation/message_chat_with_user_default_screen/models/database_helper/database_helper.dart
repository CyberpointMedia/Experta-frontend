import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'chat_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        chatId TEXT,
        senderId TEXT,
        content TEXT,
        createdAt TEXT,
        readBy TEXT
      )
    ''');
  }

  Future<void> insertMessage(Map<String, dynamic> message) async {
    final db = await database;
    await db.insert(
        'messages',
        {
          'id': message['_id'],
          'chatId': message['chat'],
          'senderId': jsonEncode(message['sender']),
          'content': message['content'],
          'createdAt': message['createdAt'],
          'readBy': jsonEncode(message['readBy']),
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> fetchMessages(String chatId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('messages', where: 'chatId = ?', whereArgs: [chatId]);

    return List.generate(maps.length, (i) {
      return {
        '_id': maps[i]['id'],
        'chat': maps[i]['chatId'],
        'sender': jsonDecode(maps[i]['senderId']),
        'content': maps[i]['content'],
        'createdAt': maps[i]['createdAt'],
        'readBy': jsonDecode(maps[i]['readBy']),
      };
    });
  }

  Future<void> updateMessageReadStatus(String messageId, String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('messages', where: 'id = ?', whereArgs: [messageId]);

    if (maps.isNotEmpty) {
      List<String> readBy = List<String>.from(jsonDecode(maps[0]['readBy']));
      if (!readBy.contains(userId)) {
        readBy.add(userId);
        await db.update('messages', {'readBy': jsonEncode(readBy)},
            where: 'id = ?', whereArgs: [messageId]);
      }
    }
  }
}
