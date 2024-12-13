import 'package:pricecal/data/models/item.dart';

sealed class ItemListEvent {}

class ItemListEventLoad extends ItemListEvent {}

class ItemListEventAddItem extends ItemListEvent {
  final Item item;
  ItemListEventAddItem({required this.item});
}

class ItemListEventRemoveItem extends ItemListEvent {
  final Item item;
  ItemListEventRemoveItem({required this.item});
}

class ItemListEventUpdateItem extends ItemListEvent {
  final Item item;
  ItemListEventUpdateItem({required this.item});
}

class ItemListEventClearAllItem extends ItemListEvent {
  final bool save;
  ItemListEventClearAllItem({this.save = false});
}
