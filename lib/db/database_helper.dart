import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/article.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  static const String _favoritesTable = 'favorites';
  static const String _userArticlesTable = 'user_articles';

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'articles.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_favoritesTable (
        id INTEGER PRIMARY KEY,
        title TEXT,
        body TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $_userArticlesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        body TEXT
      )
    ''');
  }

  Future<void> insertFavorite(Article article) async {
    final db = await database;
    await db.insert(
      _favoritesTable,
      {
        'id': article.id,
        'title': article.title,
        'body': article.body,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Article>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_favoritesTable);

    return List.generate(maps.length, (i) {
      return Article(
        id: maps[i]['id'],
        title: maps[i]['title'],
        body: maps[i]['body'],
      );
    });
  }

  Future<void> deleteFavorite(int id) async {
    final db = await database;
    await db.delete(
      _favoritesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isFavorite(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.query(_favoritesTable, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }

  Future<void> insertUserArticle(Article article) async {
    final db = await database;
    await db.insert(
      _userArticlesTable,
      {
        'title': article.title,
        'body': article.body,
      },
    );
  }

  Future<List<Article>> getUserArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_userArticlesTable);

    return List.generate(maps.length, (i) {
      return Article(
        id: maps[i]['id'],
        title: maps[i]['title'],
        body: maps[i]['body'],
      );
    });
  }

  Future<void> deleteUserArticle(int id) async {
    final db = await database;
    await db.delete(
      _userArticlesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
