import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stormtune/models/car_profile.dart';
import 'package:stormtune/models/weather_data.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'stormtune.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Car profiles table
    await db.execute('''
      CREATE TABLE car_profiles(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        drive TEXT NOT NULL,
        induction TEXT NOT NULL,
        fuel TEXT NOT NULL,
        tire TEXT NOT NULL,
        weight_class TEXT NOT NULL,
        ignition_strength TEXT,
        launch_rpm INTEGER NOT NULL,
        base_wgdc_pct REAL,
        afr_target_wot REAL,
        tire_hot_pressure_psi REAL,
        boost_psi REAL,
        ecu_brand TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Weather cache table
    await db.execute('''
      CREATE TABLE weather_cache(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        temperature_c REAL NOT NULL,
        humidity_pct REAL,
        pressure_hpa REAL,
        iat_c REAL,
        clt_c REAL,
        location TEXT,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  // Car Profile Methods
  static Future<void> saveCarProfile(CarProfile profile) async {
    final db = await database;
    await db.insert(
      'car_profiles',
      profile.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<CarProfile>> getCarProfiles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('car_profiles');
    return List.generate(maps.length, (i) => CarProfile.fromJson(maps[i]));
  }

  static Future<CarProfile?> getCarProfile(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'car_profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return CarProfile.fromJson(maps.first);
    }
    return null;
  }

  static Future<void> deleteCarProfile(String id) async {
    final db = await database;
    await db.delete(
      'car_profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Weather Cache Methods
  static Future<void> saveWeatherData(WeatherData weather) async {
    final db = await database;
    await db.insert(
      'weather_cache',
      weather.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<WeatherData?> getLatestWeatherData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'weather_cache',
      orderBy: 'timestamp DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return WeatherData.fromJson(maps.first);
    }
    return null;
  }

  static Future<void> clearOldWeatherData() async {
    final db = await database;
    final oneDayAgo = DateTime.now().subtract(const Duration(days: 1));
    await db.delete(
      'weather_cache',
      where: 'timestamp < ?',
      whereArgs: [oneDayAgo.toIso8601String()],
    );
  }
} 