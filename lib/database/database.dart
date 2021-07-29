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
    return await openDatabase(join(await getDatabasesPath(), 'notes.db'),
        onCreate: (db, version) {
      db.execute('''
      CREATE TABLE tasks (
        id INTEGER AUTOINCREMENT,
        task TEXT ,createdTime TEXT
      )
        ''');
    }, version: 1);
  }
  addNewTask(TaskModel newTask)  async {
    final db = await database ;
    db!.insert('tasks', newTask.toMap(), 
    conflictAlgorithm:  ConflictAlgorithm.replace
    );
  }
  Future<dynamic> getTask()async {
    final db = await database ;
  var res = await db!.query('tasks');
  if (res.length == 0) {
    return null;
  }else {
    var resultMap = res.toList();
    return resultMap.isNotEmpty ? resultMap : null;
  }
  }
}
