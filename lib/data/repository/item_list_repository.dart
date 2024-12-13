import 'package:pricecal/data/models/item.dart';
import 'package:pricecal/data/models/stat.dart';
import 'package:pricecal/data/providers/item_list_provider.dart';

class ItemListRepository {
  final ItemListDataProvider _dataProvider;

  ItemListRepository({
    required ItemListDataProvider dataProvider,
  }) : _dataProvider = dataProvider;

  Future<List<Item>> getItemList({String? key}) async {
    return (await _dataProvider.readItemList(key: key)).toList();
  }

  Future<void> saveItemList(List<Item> itemList) async {
    await _dataProvider.saveItemList(itemList: itemList);
  }

  Future<void> clearItemList({bool save = false}) async {
    await _dataProvider.clearItemList(save: save);
  }

  Future<List<Stat>> getStatList() async {
    return await _dataProvider.readStatList();
  }

  Future<void> clearStat(String key) async {
    await _dataProvider.clearStat(key);
  }

  Future<void> clearAllData() async {
    await _dataProvider.clearAllData();
  }
}
