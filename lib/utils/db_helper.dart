import 'dart:io';
import 'package:cs442_mp4/models/deck.dart';
import 'package:cs442_mp4/models/flashcard.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  static const _databaseName = 'mad4.db';
  static const _databaseVersion = 1;

  // Define the table names
  static const deckTable = 'deck';
  static const flashcardTable = 'flashcard';

  // Define column names for the Deck table
  static const columnDeckId = 'id';
  static const columnDeckTitle = 'title';

  // Define column names for the Flashcard table
  static const columnFlashcardId = 'id';
  static const columnFlashcardDeckId = 'deckId';
  static const columnFlashcardQuestion = 'question';
  static const columnFlashcardAnswer = 'answer';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $deckTable (
        $columnDeckId INTEGER PRIMARY KEY,
        $columnDeckTitle TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $flashcardTable (
        $columnFlashcardId INTEGER PRIMARY KEY,
        $columnFlashcardDeckId INTEGER,
        $columnFlashcardQuestion TEXT NOT NULL,
        $columnFlashcardAnswer TEXT NOT NULL,
        FOREIGN KEY ($columnFlashcardDeckId) REFERENCES $deckTable ($columnDeckId)
      )
    ''');
  }

  Future<int> insertDeck(Deck deck) async {
    Database db = await instance.database;
    return await db.insert(deckTable, deck.toMap());
  }

  Future<int> updateDeck(Deck deck) async {
    Database db = await instance.database;
    return await db.update(
      deckTable,
      deck.toMap(),
      where: '$columnDeckId = ?',
      whereArgs: [deck.id],
    );
  }

  Future<int> deleteDeck(int id) async {
    Database db = await instance.database;
    return await db.delete(deckTable, where: '$columnDeckId = ?', whereArgs: [id]);
  }

  Future<List<Deck>> getAllDecks() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(deckTable);
    return List.generate(maps.length, (i) {
      return Deck.fromMap(maps[i]);
    });
  }

  // Implement similar methods for flashcards

  Future<int> insertFlashcard(Flashcard flashcard) async {
    Database db = await instance.database;
    return await db.insert(flashcardTable, flashcard.toMap());
  }

  Future<int> updateFlashcard(Flashcard flashcard) async {
    Database db = await instance.database;
    return await db.update(
      flashcardTable,
      flashcard.toMap(),
      where: '$columnFlashcardId = ?',
      whereArgs: [flashcard.id],
    );
  }

  Future<int> deleteFlashcard(int id) async {
    Database db = await instance.database;
    return await db.delete(flashcardTable, where: '$columnFlashcardId = ?', whereArgs: [id]);
  }

  Future<List<Flashcard>> getAllFlashcards() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(flashcardTable);
    return List.generate(maps.length, (i) {
      return Flashcard.fromMap(maps[i]);
    });
  }

  Future close() async {
    Database db = await instance.database;
    db.close();
  }
}