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

    return await openDatabase(
join(await getDatabasesPath(), 'notes.db'), onCreate : (db , version)async {
  await db.execute('''
  
  CREATE TABLE tables(
id INTEGER AUTOINCREMENT,
task TEXT,
createTime Text
  )
  ''');
},version: 1
    );
/*     return openDatabase(join(await getDatabasesPath(), 'note.db'),
        onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE tables (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task TEXT NOT NULL ,
        createdTime TEXT NOT NULL,
      )
        ''');
    }, version: 1); */
  }

  addNewTask(TaskModel newTask) async {
    final db = await database;
    db!.insert('tables', newTask.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<dynamic> getTask() async {
    final db = await database;
    var res = await db!.query('tables');
    if (res.length == 0) {
      return null;
    } else {
      var resultMap = res[0];
      return resultMap.isNotEmpty ? resultMap : null;
    }
  }
}
