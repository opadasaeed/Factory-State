import 'dart:async';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/chairmodel.dart';

class ChairsDB {
  List<Chairs> chairlist = [];
  static Database? _db;
  int? id;

  //........check database creadted or not yet ..........
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDB();
      return _db;
    } else {
      return _db;
    }
  }

//creat Database file
  initialDB() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "chairsdb.db");
    var mydb = await openDatabase(path, version: 16, onCreate: _onCreate);
    return mydb;
  }

//creat Database TABLE

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE chairsdb(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE ,description TEXT NOT NULL,title TEXT NOT NULL,date TEXT NOT NULL,state TEXT NOT NULL,pic1 TEXT NOT NULL,pic2 TEXT NOT NULL)");
  }

  //.......add new row in database......
  Future<int> addchair(Map<String, dynamic> data) async {
    Database? db_clint = await db;
    var reselt = await db_clint!.insert("chairsdb", data);

    return reselt;
  }

//.........delete row in database......
  Future deletechair(int id) async {
    try {
      Database? db_clint = await db;
      var reselt =
          await db_clint!.rawUpdate('DELETE FROM chairsdb WHERE id ="$id"');
      return reselt;
    } catch (e) {
      print('e==>$e');
    }
  }

//..........update row in database......
  Future<int> updatechair(String description, String title, String pic1,
      String pic2, String state, int id) async {
    Database? db_clint = await db;
    var reselt = await db_clint!.rawUpdate(
        'UPDATE chairsdb SET description="$description",title="$title",pic1="$pic1",pic2="$pic2",state="$state",WHERE id="$id"');
    return reselt;
  }

  //.........get all rows in database......
  Future getchairs() async {
    try {
      Database? db_clint = await db;
      List<Chairs> list = [];
      var reselt = await db_clint!.query('chairsdb');
      for (var i in reselt) {
        list.add(Chairs.fromMap(i));
      }
      return list;
    } catch (e) {
      print('e==>$e');
    }
  }
}
