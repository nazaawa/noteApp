import 'package:noteapp/model/taskmodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider dataBase = DBProvider._();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initdatabase();
    return _database;
  }

  initdatabase() async {
    return openDatabase(join(await getDatabasesPath(), 'note.db'),
        onCreate: (db, version) async {
      await db.execute("""
        CREATE TABLE tables (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          task TEXT,createdTime TEXT
        )
        """);
    }, version: 1);
  }

  addNewTask(TaskModel newTask) async {
    final db = await database;
    db!.insert('tables', newTask.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<dynamic> getTask() async {
    final db = await database;
    return await db!.query('tables');

  }

  Future <dynamic> delete(int id) async{
    final db = await database;
    return await db!.delete('tables',where: 'id = ?' , whereArgs:[id]);
  }
  Future<dynamic> update(TaskModel newTask , int id)async {
    final db = await database;
    return await db!.update('tables',newTask.toMap(),where: 'id = ?');
  }

 
}
