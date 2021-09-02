import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ticketing_system/Models/setting.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null)
      return _database as Database;

    _database = await initDB();
    return _database as Database;
  }

  Future<Database> initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'GigabyteLtd.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute("CREATE TABLE IF NOT EXISTS Settings (id INTEGER PRIMARY KEY autoincrement, serverLink, TEXT)");
      },
    );
  }

  Future<int> insertSetting(Setting setting) async {
    final db = await database;

    var res =  await db.insert(
      'Settings',
      setting.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print(res);

    return res;
  }

  Future<Setting?> getSetting() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('Settings');

    List li =  List.generate(maps.length, (i) {
      return Setting(
        id: maps[i]['id'],
        serverLink: maps[i]['serverLink'],
      );
    });

    print(li.first);

    if (li.isNotEmpty)
      return li.first;

    return null;
  }
}
