class Item {
  int? id;
  String valueEn;
  String valueRu;
  bool isShown = false;
  bool isDone = false;

  Item(
      {this.id,
      required this.valueEn,
      required this.valueRu,
      this.isShown = false,
      this.isDone = false});

  factory Item.fromDatabaseJson(Map<String, dynamic> data) => Item(
        id: data['id'],
        valueEn: data['value_en'],
        valueRu: data['value_ru'],
        isShown: data['is_shown'] != 0,
        isDone: data['is_done'] != 0,
      );

  Map<String, dynamic> toDatabaseJson() => {
        'id': this.id,
        'value_en': this.valueEn,
        'value_ru': this.valueRu,
        'is_shown': this.isShown == false ? 0 : 1,
        'is_done': this.isDone == false ? 0 : 1,
      };
}
