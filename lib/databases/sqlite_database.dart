import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BookDatabase {
  //Get Database
  static Database? _bookDb;
  Future<Database?> get db async {
    if (_bookDb == null) {
      _bookDb = await initialDb();
      return _bookDb;
    } else {
      return _bookDb;
    }
  }

  //Method Of Initial Database
  Future initialDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'books.db');
    Database bookDb = await openDatabase(path,
        onCreate: _onCreate, version: 2, onUpgrade: _onUpgrade);
    return bookDb;
  }

  //Method Of Upgrade Database
  _onUpgrade(Database db, int oldVersion, int newVersion) {
    debugPrint('Upgrade Database AND Table ============');
  }

  //Method Of Create Database And Table
  _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE books (
      Id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      BName Varchar(250) NOT NULL,
      BNote TEXT NOT NULL
      )''');
    debugPrint('Create Database AND Table ============');
  }

  //Method Of Insert Into Database
  insertData(String bName, String bNote) async {
    Database? iDb = await db;
    int response = await iDb!.rawInsert(
        "INSERT INTO books(BName, BNote) VALUES ('$bName', '$bNote')");
    return response;
  }

  //Method Of Read Database
  Future<List<Map>> readData() async {
    Database? rDb = await db;
    List<Map> response = await rDb!.rawQuery("SELECT * FROM 'books'");
    return response;
  }

  //Method For Update Database
  updateData(String sql) async {
    Database? uDb = await db;
    int response = await uDb!.rawUpdate(sql);
    return response;
  }

  //Method For Delete From Database
  deleteData(int id) async {
    Database? dDb = await db;
    int response = await dDb!.rawDelete("DELETE FROM books WHERE Id = $id");
    return response;
  }
}
