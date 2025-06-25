import 'dart:async';
import 'package:app_estudos/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'deck.dart';
import 'flashcard.dart';

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
    final path = join(await getDatabasesPath(), 'geniuscard.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT,
            name TEXT NOT NULL
          )
    ''');
    await db.execute('''
      CREATE TABLE decks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE flashcards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        deckId INTEGER,
        question TEXT,
        answer TEXT,
        FOREIGN KEY (deckId) REFERENCES decks (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        deckId INTEGER,
        correctAnswers INTEGER,
        totalQuestions INTEGER,
        timestamp TEXT
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    final dbClient = await database;
    return await dbClient.insert('users', user.toMap());
  }

  Future<User?> getUser(String username, String password) async {
    final dbClient = await database;
    final res = await dbClient.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }

  Future<int> insertDeck(Deck deck) async {
    final db = await database;
    return await db.insert('decks', deck.toMap());
  }

  Future<int> updateDeck(Deck deck) async {
    final db = await database;
    return await db.update('decks', deck.toMap(), where: 'id = ?', whereArgs: [deck.id]);
  }

  Future<int> deleteDeckById(int id) async {
    final db = await database;
    return await db.delete('decks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Deck>> getDecks() async {
    final db = await database;
    final maps = await db.query('decks');
    return maps.map((map) => Deck.fromMap(map)).toList();
  }

  Future<void> insertFlashcard(Flashcard card) async {
    final db = await database;
    await db.insert('flashcards', card.toMap());
  }

  Future<List<Flashcard>> getFlashcards(int deckId) async {
    final db = await database;
    final maps = await db.query('flashcards', where: 'deckId = ?', whereArgs: [deckId]);
    return maps.map((map) => Flashcard.fromMap(map)).toList();
  }

  Future<int> updateFlashcard(Flashcard flashcard) async {
    final db = await database;
    return await db.update('flashcards', flashcard.toMap(), where: 'id = ?', whereArgs: [flashcard.id]);
  }

  Future<int> deleteFlashcardById(int id) async {
    final db = await database;
    return await db.delete('flashcards', where: 'id = ?', whereArgs: [id]);
  }

}
