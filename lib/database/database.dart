import 'dart:async';
import 'dart:io';
import 'package:learn_english_words/model/item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final itemTABLE = 'Item';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    return _database!;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "LearnEnglishWords.db");
    // await deleteDatabase(path);
    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE $itemTABLE ("
        "id INTEGER PRIMARY KEY, "
        "value_en TEXT, "
        "value_ru TEXT, "
        "is_shown INTEGER, "
        "is_done INTEGER "
        ")");

    await _createDefaultItems(database);
  }

  Future<void> _createDefaultItems(Database database) async {
    [
      Item(valueEn: 'dance', valueRu: 'танец'),
      Item(valueEn: 'bumblebee', valueRu: 'шмель'),
      Item(valueEn: 'I like to sing', valueRu: 'мне нравится петь'),
    ].forEach((item) async {
      await database.insert(itemTABLE, item.toDatabaseJson());
    });
  }
}
