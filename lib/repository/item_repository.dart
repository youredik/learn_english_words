import 'package:learn_english_words/dao/item_dao.dart';
import 'package:learn_english_words/model/item.dart';

class ItemRepository {
  final itemDao = ItemDao();

  Future getAllItems({bool? isDone}) => itemDao.getItems(isDone: isDone);

  Future insertItem(Item item) => itemDao.createItem(item);

  Future updateItem(Item item) => itemDao.updateItem(item);

  Future deleteItemById(int id) => itemDao.deleteItem(id);

  Future deleteAllItems() => itemDao.deleteAllItems();
}
