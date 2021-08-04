import 'package:learn_english_words/model/item.dart';
import 'package:learn_english_words/repository/item_repository.dart';
import 'dart:async';

class ItemBloc {
  final _itemRepository = ItemRepository();
  final _itemDoneRepository = ItemRepository();

  final _itemController = StreamController<List<Item>>.broadcast();
  final _itemDoneController = StreamController<List<Item>>.broadcast();

  get items => _itemController.stream;
  get doneItems => _itemDoneController.stream;

  ItemBloc() {
    getItems();
  }

  getItems({String? query}) async {
    _itemController.sink.add(await _itemRepository.getAllItems(isDone: false));
  }

  getDoneItems({String? query}) async {
    _itemDoneController.sink.add(await _itemDoneRepository.getAllItems(isDone: true));
  }

  addItem(Item item) async {
    await _itemRepository.insertItem(item);
    getItems();
  }

  updateItem(Item item) async {
    await _itemRepository.updateItem(item);
    getItems();
  }

  updateDoneItem(Item item) async {
    await _itemDoneRepository.updateItem(item);
    getItems();
    getDoneItems();
  }

  deleteItemById(int id) async {
    _itemRepository.deleteItemById(id);
    getItems();
  }

  dispose() {
    _itemController.close();
    _itemDoneController.close();
  }
}
