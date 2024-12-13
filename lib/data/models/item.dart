import 'package:hive_flutter/hive_flutter.dart';
// flutter packages pub run build_runner build

part 'item.g.dart';

@HiveType(typeId: 1)
class Item {
  @HiveField(0)
  String key;

  @HiveField(1)
  double price;

  @HiveField(2)
  int count;

  @HiveField(3)
  String name;

  @HiveField(4, defaultValue: null)
  String? picturePath;

  Item({
    String? key,
    required this.price,
    required this.count,
    required this.name,
    this.picturePath,
  }) : key = key ?? DateTime.now().microsecondsSinceEpoch.toString();
}
