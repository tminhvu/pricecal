import 'package:pricecal/data/models/item.dart';

sealed class ItemListState {
  final List<Item> itemList;
  double total;

  ItemListState([List<Item>? itemList])
      : itemList = itemList ?? [],
        total = _calTotal(itemList ?? []);

  static double _calTotal(List<Item> itemList) {
    double t = 0;
    for (var e in itemList) {
      t += e.price * e.count;
    }
    return t;
  }
}

class ItemListStateInitial extends ItemListState {}

class ItemListStateLoadInProcess extends ItemListState {}

class ItemListStateLoadSuccess extends ItemListState {
  ItemListStateLoadSuccess({required List<Item> itemList}) : super(itemList);
}

class ItemListStateLoadFailed extends ItemListState {
  final Exception exception;
  ItemListStateLoadFailed({required this.exception});
}
