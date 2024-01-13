import 'package:flutter/material.dart';

import '../../../core/database/database.dart';
import '../../../theme/colors.dart';
import '../models/model.dart';

class CanvasViewModel extends ChangeNotifier {
  final Database _db;
  CanvasViewModel(this._db);
  late List<Color> _availableColors;
  late List<DrawingPoint> _drawingPointHistory;
  late List<DrawingPoint> _drawingPoints;
  late Color _selectedColor;
  late double _strokeWidth;
  late int _activeCanvasId;
  late String _canvasTitle;
  late bool _isDarkTheme;
  late Color _canvasColor;
  DrawingPoint? _currentDrawingPoint;

  List<Color> get availableColors => _availableColors;
  List<DrawingPoint> get drawingPointHistory => _drawingPointHistory;
  List<DrawingPoint> get drawingPoints => _drawingPoints;
  Color get selectedColor => _selectedColor;
  double get strokeWidth => _strokeWidth;
  DrawingPoint? get currentDrawingPoint => _currentDrawingPoint;
  int get canvasId => _activeCanvasId;
  String get title => _canvasTitle;
  bool get isDarkTheme => _isDarkTheme;
  Color get canvasColor => _canvasColor;

  void init(int id, String title) {
    _availableColors = AppColor.availableColors;
    _isDarkTheme = true;
    _canvasColor = AppColor.background;

    _activeCanvasId = id;
    _canvasTitle = title;

    _drawingPointHistory = [];
    _drawingPoints = [];
    _strokeWidth = 1.0;
    _selectedColor = _availableColors[0];
  }

  void redo() {
    if (_drawingPoints.length < _drawingPointHistory.length) {
      final index = _drawingPoints.length;
      _drawingPoints.add(_drawingPointHistory[index]);
      notifyListeners();
    }
  }

  void undo() {
    if (_drawingPoints.isNotEmpty && _drawingPointHistory.isNotEmpty) {
      _drawingPoints.removeLast();
      notifyListeners();
    }
  }

  void onPanStart(DragStartDetails details) {
    _currentDrawingPoint = DrawingPoint(
      offsets: [
        details.localPosition,
      ],
      color: _selectedColor,
      width: _strokeWidth,
    );

    _drawingPoints.add(_currentDrawingPoint!);
    _drawingPointHistory = List.of(_drawingPoints);
    notifyListeners();
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (_currentDrawingPoint == null) return;

    _currentDrawingPoint!.offsets.add(details.localPosition);
    _drawingPoints.last = _currentDrawingPoint!;
    _drawingPointHistory = List.of(_drawingPoints);
    notifyListeners();
  }

  void onPanEnd(DragEndDetails details) {
    _currentDrawingPoint = null;
    notifyListeners();
  }

  void updateSelectedColor(int index) {
    _selectedColor = _availableColors[index];
    notifyListeners();
  }

  set strokeWidth(double value) {
    _strokeWidth = value;
    notifyListeners();
  }

  Future<void> saveDoodleData() async {
    await _db.saveDoodleData(
      _activeCanvasId,
      _drawingPoints,
      _drawingPointHistory,
    );
  }

  Future<void> getDrawingData() async {
    final response = await _db.getDrawingData(_activeCanvasId);
    _drawingPoints = response.$1;
    _drawingPointHistory = response.$2;
  }

  void onChanged(String text) {
    if (text.isEmpty) return;

    _canvasTitle = text;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _canvasColor = _isDarkTheme ? AppColor.background : AppColor.white;
    notifyListeners();
  }
}
