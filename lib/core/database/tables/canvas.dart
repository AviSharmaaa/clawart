import 'package:isar/isar.dart';

part "canvas.g.dart";

@Collection()
class Canvas {
  Id id = Isar.autoIncrement;
  late DateTime createdAt;
  late DateTime updatedAt;
  late String title;
  late String imageData;
}
