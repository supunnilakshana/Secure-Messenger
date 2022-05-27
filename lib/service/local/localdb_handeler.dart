import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class LocalDbHandeler {
  static Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'msglocal.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE fsecure(id INTEGER PRIMARY KEY , value INTEGER NOT NULL)",
        );
        await database.insert('fsecure', {"id": 1, "value": 0});
      },
      version: 1,
    );
  }

  static Future<int> initFsecure() async {
    int result = 0;
    final Database db = await initializeDB();

    try {
      result = await db.insert('fsecure', {"id": 1, "value": 0});
      result = 1;
    } on Exception catch (e) {
      print(e);
    }

    return result;
  }

  static Future<int> getFsecureStatus() async {
    int res = 0;
    try {
      final Database db = await initializeDB();
      final List<Map<String, Object?>> queryResult = await db.query(
        'fsecure',
        where: "id = ?",
        whereArgs: [1],
      );
      if (queryResult.length != 0) {
        res = queryResult.first["value"] as int;
      } else {}
    } on Exception catch (e) {
      print(e);
    }
    return res;
  }

  static Future<int> updateFsecurestatus(int value) async {
    int res = 0;
    try {
      final db = await initializeDB();
      await db.update(
        'fsecure',
        {"value": value},
        where: "id = ?",
        whereArgs: [1],
      );
      res = 1;
    } on Exception catch (e) {
      print(e);
    }
    return res;
  }
}
