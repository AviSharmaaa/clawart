import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../screens/canvas/models/model.dart';
import '../../screens/home/models/model.dart';
import 'tables/canvas.dart';
import 'tables/point.dart';

class Database {
  static late Isar _isar;
  static Database? _instance;

  Database._(); // Private constructor for singleton pattern

  factory Database.instance() {
    return _instance ??= Database._();
  }

  // Initialize the database
  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [CanvasSchema, PathSchema],
      directory: dir.path,
    );
  }

  // Create a new canvas
  Future<int> addNewCanvas(
    String title,
    DateTime createdAt,
    DateTime updatedAt,
  ) async {
    final canvas = Canvas()
      ..title = title
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..imageData = "";

    return await _isar.writeTxn(() async => await _isar.canvas.put(canvas));
  }

  // Update the canvas title
  Future<void> updateCanvasDetails(
    int id,
    String newTitle,
    Uint8List imageData,
  ) async {
    final canvas = await _isar.canvas.get(id);
    if (canvas == null) return;

    if (newTitle.isNotEmpty && canvas.title != newTitle) {
      canvas.title = newTitle;
    }

    canvas.imageData = base64Encode(imageData);
    canvas.updatedAt = DateTime.now();
    await _isar.writeTxn(() async => await _isar.canvas.put(canvas));
  }

  // Save doodle data for a canvas
  Future<void> saveDoodleData(
    int canvasId,
    List<DrawingPoint> drawingPoints,
    List<DrawingPoint> drawingPointHistory,
  ) async {
    await _isar.paths.filter().canvasIdEqualTo(canvasId).deleteAll();

    final currentPaths = _convertDrawingPointsToPaths(
      drawingPoints,
      canvasId,
      PathType.current,
    );
    final historyPaths = _convertDrawingPointsToPaths(
      drawingPointHistory,
      canvasId,
      PathType.history,
    );

    await _isar.writeTxn(() async {
      await _isar.paths.putAll([...currentPaths, ...historyPaths]);
    });
  }

  // Fetch all saved canvases
  Future<List<CanvasDetails>> fetchAllCanvases() async {
    final savedCanvases = await _isar.canvas.where().findAll();
    return savedCanvases
        .map((canvas) => CanvasDetails(
              id: canvas.id,
              title: canvas.title,
              imageData: base64Decode(canvas.imageData),
              createdAt: canvas.createdAt,
              updatedAt: canvas.updatedAt,
            ))
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  // Fetch drawing data for a specific canvas
  Future<(List<DrawingPoint>, List<DrawingPoint>)> getDrawingData(
    int canvasId,
  ) async {
    final currentPaths = await _fetchPaths(canvasId, PathType.current);
    final historyPaths = await _fetchPaths(canvasId, PathType.history);

    return (currentPaths, historyPaths);
  }

  // Delete a canvas and its associated data
  Future<void> deleteCanvases(List<int> canvasIds) async {
    if (canvasIds.isEmpty) return;

    await _isar.writeTxn(() async {
      // Delete all paths associated with the given canvas IDs in a single query
      await _isar.paths
          .filter()
          .allOf(canvasIds, (q, e) => q.canvasIdEqualTo(e))
          .deleteAll();

      // Delete all canvases with the given IDs
      await _isar.canvas.deleteAll(canvasIds);
    });
  }

  // Helper method to convert DrawingPoint objects to Path objects
  List<Path> _convertDrawingPointsToPaths(
    List<DrawingPoint> drawingPoints,
    int canvasId,
    PathType pathType,
  ) =>
      drawingPoints
          .map((point) => Path()
            ..canvasId = canvasId
            ..color = _colorToString(point.color)
            ..width = point.width
            ..path = _encodeOffsetsToBase64(point.offsets)
            ..pathType = pathType)
          .toList();

  // Helper method to fetch paths from the database
  Future<List<DrawingPoint>> _fetchPaths(
    int canvasId,
    PathType pathType,
  ) async {
    final paths = await _isar.paths
        .filter()
        .canvasIdEqualTo(canvasId)
        .and()
        .pathTypeEqualTo(pathType)
        .findAll();

    return paths
        .map((path) => DrawingPoint(
              id: path.id,
              offsets: _decodeBase64ToOffsets(path.path),
              color: _stringToColor(path.color),
              width: path.width,
            ))
        .toList();
  }

  // Encode a list of offsets to a Base64 string
  String _encodeOffsetsToBase64(List<Offset> offsets) {
    final flattenedList =
        offsets.expand((offset) => [offset.dx, offset.dy]).toList();
    final listAsString = flattenedList.join(',');
    return base64Encode(utf8.encode(listAsString));
  }

  // Convert a color to a string
  String _colorToString(Color color) {
    return color.value.toRadixString(16).padLeft(8, '0').toUpperCase();
  }

  // Decode a Base64 string to a list of offsets
  List<Offset> _decodeBase64ToOffsets(String base64String) {
    final decodedString = utf8.decode(base64Decode(base64String));
    final stringValues = decodedString.split(',');
    return List<Offset>.generate(stringValues.length ~/ 2, (i) {
      return Offset(double.parse(stringValues[i * 2]),
          double.parse(stringValues[i * 2 + 1]));
    });
  }

  // Convert a string to a color
  Color _stringToColor(String colorString) {
    return Color(int.parse("0x$colorString"));
  }
}
