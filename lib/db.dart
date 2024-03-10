import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import './models/dog.dart';

class DBProvider {
  static final DBProvider dbProvider = DBProvider._();
  DBProvider._();
  factory DBProvider() {
    return dbProvider;
  }

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'),
      onCreate: _onCreate,
      version: 1,
    );
    return database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
    );
  }

  Future<void> insertDog(Dog dog) async {
    final db = await dbProvider.database;
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dog>> dogs() async {
    final db = await dbProvider.database;
    final List<Map<String, Object?>> dogMaps = await db.query('dogs');
    return [
      for (final {
            'id': id as int,
            'name': name as String,
            'age': age as int,
          } in dogMaps)
        Dog(id: id, name: name, age: age),
    ];
  }

  Future<void> updateDog(Dog dog) async {
    final db = await dbProvider.database;
    await db.update(
      'dogs',
      dog.toMap(),
      where: 'id = ?',
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    final db = await dbProvider.database;
    await db.delete(
      'dogs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
