import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pricecal/data/models/item.dart';
import 'package:pricecal/data/models/stat.dart';

class ItemListDataProvider {
  String lastestKey = 'lastest';

  Future<Box> get getItemListBox async {
    return await Hive.openBox('listOfItemLists');
  }

  Future<Box> get getStatsBox async {
    return await Hive.openBox('stats');
  }

  Future<List<Item>> readItemList({String? key}) async {
    Box box = await getItemListBox;

    List<dynamic> list = [];

    try {
      list = (box.get(key ?? lastestKey) ?? []);
    } catch (e) {
      debugPrint(e.toString());
    }

    return [...list];
  }

  Future<void> saveItemList({String? key, required List<Item> itemList}) async {
    final box = await getItemListBox;
    box.put(
      key ?? lastestKey,
      itemList,
    );
  }

  Future<void> clearItemList({bool save = false}) async {
    final itemListBox = await getItemListBox;

    List<dynamic> list = [];

    try {
      list = (itemListBox.get(lastestKey) ?? []);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (list.isEmpty) return;

    String key = (list.first as Item).key;

    itemListBox.put(key, list);
    itemListBox.delete('lastest');

    double total = 0;
    for (Item i in list) {
      total += i.price * i.count;
    }

    if (save) saveStat(Stat(key: key, total: total));
  }

  Future<void> saveStat(Stat stat) async {
    final statsBox = await getStatsBox;
    statsBox.put(stat.key, stat);
  }

  Future<List<Stat>> readStatList() async {
    final statsBox = await getStatsBox;
    final l = statsBox.values.toList();
    return [...l]..sort((b, a) => a.key.compareTo(b.key));
  }

  Future<void> clearStat(String key) async {
    final statsBox = await getStatsBox;
    statsBox.delete(key);
  }

  Future<void> clearAllData() async {
    final statsBox = await getStatsBox;
    final itemListBox = await getItemListBox;

    statsBox.clear();
    itemListBox.clear();
  }
}
