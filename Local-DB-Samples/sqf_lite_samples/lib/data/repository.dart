import 'package:sqflite/sqflite.dart';

class Repository{
   void load()async{
   }
}

class MyDatabase{
  final String tableName="student";
  final String column_key_id="id";
  final String column_key_name="name";
  final String column_key_roll="roll";
  final String _dbname="todo_db.db";
  Database? _db;
  Future<void> init()async{
    _db ??= await openDatabase(_dbname);
    await createTable();
  }
  Future<void>  createTable()async{
    final db=dbOrThrow();
    //Table(id, title, roll)
    await db.execute(
      'CREATE TABLE IF NOT EXISTS $tableName('
          '$column_key_id INTEGER PRIMARY KEY, '
          '$column_key_name TEXT, '
          '$column_key_roll TEXT'
          ')',
    );
  }
  Future<bool> insert(String title, String roll)async{
    final db=dbOrThrow();
    final Map<String, Object>  entity={
      column_key_name:title,
      column_key_roll:roll,
    };
    final result= await db.insert(tableName,entity);
    return result > 0;
  }
  Future<List<Map<String, Object?>>> readAll() async {
    final db = dbOrThrow();
    return db.query(tableName);
  }
  Future<Map<String, Object?>?> readByRoll(String roll) async {
    final db = dbOrThrow();
    final rows = await db.query(
      tableName,
      where: '$column_key_roll = ?',
      whereArgs: [roll],
      limit: 1,
    );

    return rows.isEmpty ? null : rows.first;
  }
  Future<bool> update(String title, String roll,) async {
    final db = dbOrThrow();
    final result = await db.update(tableName,
      {column_key_name: title, column_key_roll: roll,},
      where: '$column_key_roll = ?',
      whereArgs: [roll],
    );
    return result > 0;
  }
  void close(){
    _db?.close();
    _db=null;
  }
  Database dbOrThrow(){
    if(_db==null){
      throw Exception("Database not initialized");
    }
    return _db!;
  }
}