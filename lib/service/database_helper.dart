import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class DatabaseHelper {
  static const _databaseName = "domus.db";
  static const _databaseVersion = 1;

  // Singleton instance
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance ??= DatabaseHelper._internal();

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        name TEXT,
        photo_url TEXT,
        created_at INTEGER NOT NULL,
        last_login INTEGER NOT NULL
      )
    ''');

    // Devices table
    await db.execute('''
      CREATE TABLE devices (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        status INTEGER NOT NULL,
        room_id TEXT,
        last_updated INTEGER NOT NULL,
        FOREIGN KEY (room_id) REFERENCES rooms (id)
      )
    ''');

    // Rooms table
    await db.execute('''
      CREATE TABLE rooms (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    // Settings table
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
  }

  // Upgrade database
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // Add upgrade logic
    }
  }

  // User operations
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUser(String id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

  // Device operations
  Future<int> insertDevice(Map<String, dynamic> device) async {
    Database db = await database;
    return await db.insert('devices', device);
  }

  Future<List<Map<String, dynamic>>> getDevices() async {
    Database db = await database;
    return await db.query('devices');
  }

  Future<int> updateDevice(Map<String, dynamic> device) async {
    Database db = await database;
    return await db.update(
      'devices',
      device,
      where: 'id = ?',
      whereArgs: [device['id']],
    );
  }

  // Room operations
  Future<int> insertRoom(Map<String, dynamic> room) async {
    Database db = await database;
    return await db.insert('rooms', room);
  }

  Future<List<Map<String, dynamic>>> getRooms() async {
    Database db = await database;
    return await db.query('rooms');
  }

  // Settings operations
  Future<int> insertSetting(String key, String value) async {
    Database db = await database;
    return await db.insert('settings', {
      'key': key,
      'value': value,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<String?> getSetting(String key) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    return results.isNotEmpty ? results.first['value'] : null;
  }

  // Close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
} 