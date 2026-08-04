
import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

typedef Database = Box<dynamic>;
class MyDatabase {
  final String tableName = "student";
  final String column_key_id = "id";
  final String column_key_name = "name";
  final String column_key_roll = "roll";
  final String _dbname = "todo_db.db";

  Database? _db;

  Future<void> init() async {
    final directory = await getApplicationSupportDirectory();
    await directory.create(recursive: true);
    Hive.init(directory.path);
    _db ??= await Hive.openBox<dynamic>(
      '${_dbname}_$tableName',
    );
    await createTable();
  }

  Future<void> createTable() async {
    dbOrThrow();
  }

  Future<bool> insert(String title, String roll) async {
    final db = dbOrThrow();

    var id = 1;

    for (final key in db.keys) {
      if (key is int && key >= id) {
        id = key + 1;
      }
    }

    final Map<String, Object?> entity = {
      column_key_id: id,
      column_key_name: title,
      column_key_roll: roll,
    };

    await db.put(id, entity);

    return db.containsKey(id);
  }

  Future<List<Map<String, Object?>>> readAll() async {
    final db = dbOrThrow();
    final rows = <Map<String, Object?>>[];

    for (final value in db.values) {
      if (value is Map) {
        rows.add(Map<String, Object?>.from(value));
      }
    }

    return rows;
  }

  Future<Map<String, Object?>?> readByRoll(String roll) async {
    final db = dbOrThrow();

    for (final value in db.values) {
      if (value is Map) {
        final row = Map<String, Object?>.from(value);

        if (row[column_key_roll] == roll) {
          return row;
        }
      }
    }

    return null;
  }

  Future<bool> update(
      String title,
      String roll,
      ) async {
    final db = dbOrThrow();
    var updated = false;

    for (final key in db.keys.toList()) {
      final value = db.get(key);

      if (value is Map) {
        final row = Map<String, Object?>.from(value);

        if (row[column_key_roll] == roll) {
          row[column_key_name] = title;
          row[column_key_roll] = roll;

          await db.put(key, row);
          updated = true;
        }
      }
    }

    return updated;
  }

  void close() {
    _db?.close();
    _db = null;
  }

  Database dbOrThrow() {
    if (_db == null) {
      throw Exception("Database not initialized");
    }

    return _db!;
  }
}