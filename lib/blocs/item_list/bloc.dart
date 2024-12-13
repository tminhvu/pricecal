import 'dart:async';
import 'package:pricecal/blocs/item_list/event.dart';
import 'package:pricecal/blocs/item_list/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pricecal/data/models/item.dart';
import 'package:pricecal/data/repository/item_list_repository.dart';

class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {
  final ItemListRepository _itemListRepository;

  ItemListBloc({required ItemListRepository itemListRepository})
      : _itemListRepository = itemListRepository,
        super(ItemListStateInitial()) {
    on<ItemListEventLoad>(_onLoad);
    on<ItemListEventAddItem>(_onAddItem);
    on<ItemListEventClearAllItem>(_clearAllItem);
    on<ItemListEventRemoveItem>(_onRemoveItem);
  }

  FutureOr<void> _onLoad(event, emit) async {
    emit(ItemListStateLoadInProcess());

    List<Item> list = [];
    try {
      list = await _itemListRepository.getItemList();
    } catch (e) {
      emit(ItemListStateLoadFailed(exception: Exception(e)));
    }

    emit(ItemListStateLoadSuccess(itemList: list));
  }

  FutureOr<void> _onAddItem(event, emit) async {
    List<Item> list = [...state.itemList];

    emit(ItemListStateLoadInProcess());

    if (list.contains(event.item)) {
      int oldIndex = list.indexOf(event.item);
      list.removeAt(oldIndex);
      list.insert(oldIndex, event.item);
      emit(
        ItemListStateLoadSuccess(itemList: list),
      );
      return;
    }

    emit(
      ItemListStateLoadSuccess(
        itemList: list..insert(0, event.item),
      ),
    );

    _itemListRepository.saveItemList(list);
  }

  FutureOr<void> _clearAllItem(
    ItemListEventClearAllItem event,
    Emitter<ItemListState> emit,
  ) {
    emit(ItemListStateLoadInProcess());

    emit(ItemListStateLoadSuccess(itemList: []));

    _itemListRepository.clearItemList(save: event.save);
  }

  FutureOr<void> _onRemoveItem(ItemListEventRemoveItem event, Emitter<ItemListState> emit) {
    List<Item> list = [...state.itemList];

    emit(ItemListStateLoadInProcess());

    emit(ItemListStateLoadSuccess(itemList: list..remove(event.item)));

    _itemListRepository.saveItemList(list);
  }
}
