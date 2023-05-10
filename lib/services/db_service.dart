// ignore_for_file: depend_on_referenced_packages

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:totranslate/model/conversation_model.dart';
import 'package:totranslate/model/history_model.dart';
import 'package:totranslate/model/language_model.dart';

class DbService {
  static final DbService instance = DbService._init();
  static Database? _database;
  DbService._init();

  Future<Database> get database async {
    // ignore: unnecessary_null_comparison
    if (_database != null) return _database!;

    _database = await _initDB('download.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableLanguage ( 
      ${LanguageFields.id} $idType, 
      ${LanguageFields.langName} $textType,
      ${LanguageFields.langCode} $textType,
      ${LanguageFields.localName} $textType
      )
    ''');

    await db.execute('''
    CREATE TABLE $tableHistory ( 
      ${HistoryFields.id} $idType, 
      ${HistoryFields.langOnename} $textType,
      ${HistoryFields.langOneCode} $textType,
      ${HistoryFields.langTwoName} $textType,
      ${HistoryFields.langTwoCode} $textType,
      ${HistoryFields.origianlText} $textType,
      ${HistoryFields.translatedText} $textType,
      ${HistoryFields.date} $textType,
      ${HistoryFields.isFav} $integerType
      )
    ''');

    await db.execute('''
    CREATE TABLE $tableConversation ( 
      ${ConversationFields.id} $idType, 
      ${ConversationFields.sourceCode} $textType,
      ${ConversationFields.targetCode} $textType,
      ${ConversationFields.source} $textType,
      ${ConversationFields.target} $textType,
      ${ConversationFields.side} $integerType,
      ${ConversationFields.date} $textType,
      ${ConversationFields.lable} $textType
      )
    ''');
  }

  Future<void> createRecentLanguage(LanguageModel model) async {
    final db = await instance.database;
    await db.insert(tableLanguage, model.toJson());
  }

  Future<void> createHistory(HistoryModel model) async {
    final db = await instance.database;
    await db.insert(tableHistory, model.toJson());
  }

  Future<void> createConversationEntity(ConversationModel model) async {
    final db = await instance.database;
    await db.insert(tableConversation, model.toJson());
  }

  Future<void> updateConversation(ConversationModel model) async {
    final db = await instance.database;
    db.update(
      tableConversation,
      model.toJson(),
      where: '${ConversationFields.id} = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> updateHistory(HistoryModel model) async {
    final db = await instance.database;
    db.update(
      tableHistory,
      model.toJson(),
      where: '${HistoryFields.id} = ?',
      whereArgs: [model.id],
    );
  }

  Future<List<HistoryModel>> getHistory() async {
    final db = await instance.database;
    const orderBy = '${HistoryFields.id} DESC';
    final result = await db.query(tableHistory, orderBy: orderBy, limit: 30);
    return result.map((json) => HistoryModel.fromJson(json)).toList();
  }

  Future<List<ConversationModel>> getConvs() async {
    final db = await instance.database;
    const orderBy = '${ConversationFields.id} DESC';
    final result = await db.query(tableConversation, orderBy: orderBy);
    return result.map((json) => ConversationModel.fromJson(json)).toList();
  }

  Future<List<HistoryModel>> getFavs() async {
    final db = await instance.database;
    const orderBy = '${HistoryFields.id} DESC';
    final result = await db.query(tableHistory,
        where: '${HistoryFields.isFav} = ?', whereArgs: [1], orderBy: orderBy);
    return result.map((json) => HistoryModel.fromJson(json)).toList();
  }

  Future<List<LanguageModel>> getRecentLanguages() async {
    final db = await instance.database;
    final result = await db.query(tableLanguage);
    return result.map((json) => LanguageModel.fromJson(json)).toList();
  }

  Future<int> deleteConvs(int? id) async {
    final db = await instance.database;
    return await db.delete(
      tableConversation,
      where: '${ConversationFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
