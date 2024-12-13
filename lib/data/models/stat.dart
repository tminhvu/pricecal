import 'package:hive_flutter/hive_flutter.dart';

part 'stat.g.dart';

@HiveType(typeId: 2)
class Stat {

  @HiveField(0)
  String key;
  @HiveField(1)
  double total;

  Stat({required this.key, required this.total});
}
