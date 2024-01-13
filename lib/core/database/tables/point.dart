import 'package:isar/isar.dart';

part "point.g.dart";

enum PathType { current, history }

@Collection()
class Path {
  Id id = Isar.autoIncrement;

  late String path; //offests bas64 encoded
  late String color;
  late double width;
  @enumerated
  late PathType pathType;

  late int canvasId;
}
