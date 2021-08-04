import 'package:flutter/material.dart';
import 'package:learn_english_words/bloc/item_bloc.dart';
import 'package:learn_english_words/model/item.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final ItemBloc itemBloc = ItemBloc();
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой словарь'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute<void>(builder: (_) => doneItems()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          // color: Colors.white,
          padding: const EdgeInsets.all(2.0),
          child: Container(
            child: _itemList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showAddingForm(context);
        },
        tooltip: 'Добавить новое слово',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _itemList() {
    return StreamBuilder(
      stream: itemBloc.items,
      builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
        return itemsWidget(snapshot);
      },
    );
  }

  Widget itemsWidget(AsyncSnapshot<List<Item>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data!.length != 0
          ? ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, itemPosition) {
                Item item = snapshot.data![itemPosition];

                return GestureDetector(
                  onLongPress: () async {
                    await showUpdatingForm(context, item);
                  },
                  child: Dismissible(
                    key: ObjectKey(item),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        item.isDone = !item.isDone;
                        itemBloc.updateItem(item);
                      } else if (direction == DismissDirection.endToStart) {
                        itemBloc.deleteItemById(item.id!);
                      }
                    },
                    background: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15.0),
                      color: Colors.green,
                      child: Icon(Icons.done, color: Colors.white, size: 30.0),
                    ),
                    secondaryBackground: Container(
                      padding: EdgeInsets.only(right: 15.0),
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child:
                          Icon(Icons.delete, color: Colors.white, size: 30.0),
                    ),
                    child: Container(
                      height: 70,
                      child: Card(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  item.valueEn.inCaps,
                                  style: TextStyle(fontSize: 17),
                                ),
                                padding: EdgeInsets.only(left: 15),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  item.isShown = !item.isShown;
                                  itemBloc.updateItem(item);
                                },
                                child: Container(
                                  child: Text(
                                    item.valueRu.inCaps,
                                    style: TextStyle(
                                      color: item.isShown
                                          ? Colors.black
                                          : Colors.grey[200],
                                      fontSize: 17,
                                      backgroundColor: item.isShown
                                          ? Colors.white
                                          : Colors.grey[200],
                                      height: 1.3,
                                    ),
                                  ),
                                  padding: EdgeInsets.only(left: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : Container(
              child: Center(
              child: noItemMessageWidget(),
            ));
    } else {
      return Center(
        child: loadingData(),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> showAddingForm(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        final _valueEn = TextEditingController();
        final _valueRu = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Center(child: const Text('Добавление новых слов')),
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        autofocus: true,
                        controller: _valueEn,
                        decoration:
                            InputDecoration(hintText: 'Слово(а) на английском'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Не должно быть пустым';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _valueRu,
                        decoration:
                            InputDecoration(hintText: 'Слово(а) на русском'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Не должно быть пустым';
                          }
                          return null;
                        },
                      ),
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: const Text('Отменить'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Сохранить'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newItem =
                          Item(valueEn: _valueEn.text, valueRu: _valueRu.text);
                      itemBloc.addItem(newItem);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  final _updatingFormKey = GlobalKey<FormState>();

  Future<void> showUpdatingForm(BuildContext context, Item item) async {
    return await showDialog(
      context: context,
      builder: (context) {
        final _valueEn = TextEditingController();
        final _valueRu = TextEditingController();

        _valueEn.text = item.valueEn;
        _valueRu.text = item.valueRu;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Center(child: const Text('Редактирование слов')),
              content: Form(
                key: _updatingFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: _valueEn,
                      decoration: const InputDecoration(
                        hintText: 'Слово(а) на английском',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Не должно быть пустым';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _valueRu,
                      decoration:
                          const InputDecoration(hintText: 'Слово(а) на русском'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Не должно быть пустым';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Отменить'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('Сохранить'),
                  onPressed: () {
                    if (_updatingFormKey.currentState!.validate()) {
                      item.valueEn = _valueEn.text;
                      item.valueRu = _valueRu.text;
                      itemBloc.updateItem(item);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // void _navigateToDoneItems(BuildContext context) {
  //   Navigator.of(context).push<void>(
  //     MaterialPageRoute<void>(builder: (_) => doneItems()),
  //   );
  // }

  Widget doneItems() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Завершенные слова'),
      ),
      body: SafeArea(
        child: Container(
          // color: Colors.white,
          padding: const EdgeInsets.all(2.0),
          child: Container(
            child: _doneItemList(),
          ),
        ),
      ),
    );
  }


  Widget _doneItemList() {
    return StreamBuilder(
      stream: itemBloc.doneItems,
      builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
        return doneItemsWidget(snapshot);
      },
    );
  }

  Widget doneItemsWidget(AsyncSnapshot<List<Item>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data!.length != 0
          ? ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, itemPosition) {
                Item item = snapshot.data![itemPosition];

                return Dismissible(
                  key: ObjectKey(item),
                  onDismissed: (direction) {
                    item.isDone = !item.isDone;
                    itemBloc.updateDoneItem(item);
                  },
                  child: Container(
                    height: 70,
                    child: Card(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                item.valueEn.inCaps,
                                style: TextStyle(fontSize: 17),
                              ),
                              padding: EdgeInsets.only(left: 15),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                item.valueRu.inCaps,
                                style: TextStyle(fontSize: 17),
                              ),
                              padding: EdgeInsets.only(left: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Container(
              child: Center(
              child: noItemDoneMessageWidget(),
            ));
    } else {
      return Center(
        child: loadingDoneItemData(),
      );
    }
  }

  Widget loadingData() {
    itemBloc.getItems();
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Загрузка слов...",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget noItemMessageWidget() {
    return Container(
      child: Text(
        "Начните добавлять слова...",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget loadingDoneItemData() {
    itemBloc.getDoneItems();
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Загрузка слов...",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget noItemDoneMessageWidget() {
    return Container(
      child: Text(
        'Пока нет завершенных слов',
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
}
