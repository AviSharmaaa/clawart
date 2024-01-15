import 'dart:typed_data' show Uint8List;

class CanvasDetails {
  int id;
  String title;
  Uint8List imageData;
  DateTime createdAt;
  DateTime updatedAt;

  CanvasDetails({
    required this.id,
    required this.title,
    required this.imageData,
    required this.createdAt,
    required this.updatedAt,
  });
}
