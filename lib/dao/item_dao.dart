import 'dart:async';
import 'package:learn_english_words/database/database.dart';
import 'package:learn_english_words/model/item.dart';

class ItemDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createItem(Item item) async {
    final db = await dbProvider.database;
    var result = await db.insert(itemTABLE, item.toDatabaseJson());
    return result;
  }

  Future<List<Item>> getItems({List<String>? columns, bool? isDone}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>>? result = isDone != null
        ? await db.query(itemTABLE,
            columns: columns,
            where: 'is_done = ?',
            whereArgs: [(isDone == true ? 1 : 0)])
        : await db.query(itemTABLE, columns: columns);

    List<Item> items = result.isNotEmpty
        ? result.map((item) => Item.fromDatabaseJson(item)).toList()
        : [];
    return items;
  }

  Future<int> updateItem(Item item) async {
    final db = await dbProvider.database;

    var result = await db.update(itemTABLE, item.toDatabaseJson(),
        where: "id = ?", whereArgs: [item.id]);

    return result;
  }

  Future<int> deleteItem(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(itemTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  Future deleteAllItems() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      itemTABLE,
    );

    return result;
  }
}
