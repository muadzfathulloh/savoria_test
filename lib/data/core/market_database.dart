import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MarketDB {
  static final MarketDB _instance = MarketDB._internal();
  static Database? _database;

  factory MarketDB() {
    return _instance;
  }

  MarketDB._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'profile.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE market (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        market_code TEXT,
        market_name TEXT,
        market_address TEXT,
        latitude_longitude TEXT,
        photo TEXT,
        photo_path TEXT,
        created_date TEXT,
        updated_date TEXT
      )
    ''');
  }

  Future<int> insertMarket(Map<String, dynamic> market) async {
    Database db = await database;
    return await db.insert('market', market);
  }

  Future<List<Map<String, dynamic>>> getMarkets() async {
    Database db = await database;
    return await db.query('market');
  }

  Future<int> updateMarket(String id, Map<String, dynamic> market) async {
    Database db = await database;
    return await db.update('market', market, where: 'market_code = ?', whereArgs: [id]);
  }

  Future<int> deleteMarket(String id) async {
    Database db = await database;
    return await db.delete('market', where: 'market_code = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    Database db = await database;
    await db.close();
  }
}
