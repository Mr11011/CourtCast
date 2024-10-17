import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/weather_data_entity.dart';

Future<void> savePredictionEvent(
    String userEmail, Map<String, dynamic> eventData) async {
  final dbHelper = DatabaseHelper();
  await dbHelper.insertPrediction(userEmail, eventData);
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDB('weather_predictions.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,  // Increment the version number to ensure the new table is created
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE prediction_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_email TEXT,
        prediction INTEGER,
        date TEXT,
        weather TEXT
      )
    ''');

    // Create the `predictions_history` table
    await db.execute('''
      CREATE TABLE predictions_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        outlook TEXT,
        temperature REAL,
        humidity INTEGER,
        prediction TEXT
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // When upgrading from older versions, create the `predictions_history` table
      await db.execute('''
        CREATE TABLE predictions_history (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT,
          outlook TEXT,
          temperature REAL,
          humidity INTEGER,
          prediction TEXT
        )
      ''');
    }
  }

  Future<void> insertPrediction(
      String userEmail, Map<String, dynamic> prediction) async {
    final db = await database;
    await db.insert('prediction_history', {
      'user_email': userEmail,
      'prediction': prediction['prediction'],
      'date': prediction['date'],
      'weather': jsonEncode(prediction['weather']),
    });
  }

  Future<List<Map<String, dynamic>>> getUserHistory(String userEmail) async {
    final db = await database;
    final result = await db.query(
      'prediction_history',
      where: 'user_email = ?',
      whereArgs: [userEmail],
      orderBy: 'date DESC',
    );
    return result;
  }
}

Future<String?> getUserEmail() async {
  final prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');
  debugPrint('User email from SharedPreferences: $email');
  return email;
}

Future<void> savePredictionToHistory(
    WeatherEntity weatherEntity, String predictionResult) async {
  final db = await openDatabase('weather_predictions.db');
  await db.insert(
    'predictions_history',
    {
      'date': DateTime.now().toString(), // Store the date/time
      'outlook': weatherEntity.current.condition.text,
      'temperature': weatherEntity.current.tempC,
      'humidity': weatherEntity.current.humidity,
      'prediction': predictionResult // "suitable" or "not suitable"
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
