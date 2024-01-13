import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../core/database/database.dart';
import '../models/model.dart';

class HomeViewModel extends ChangeNotifier {
  final Database _database;

  HomeViewModel(this._database);

  List<CanvasDetails> _canvasList = [];
  final Set<int> _selectedCanvases = {};
  bool _multiSelectionEnabled = false;

  List<CanvasDetails> get canvasList => _canvasList;
  Set<int> get selectedCanvases => _selectedCanvases;
  bool get multiSelectionEnabled => _multiSelectionEnabled;
  bool get showFAB => _canvasList.isNotEmpty && !_multiSelectionEnabled;

  /// Fetches and updates the list of all canvases.
  Future<void> fetchAllCanvases() async {
    _canvasList = await _database.fetchAllCanvases();
    notifyListeners();
  }

  /// Creates a new canvas and adds it to the canvas list.
  Future<(int, String)> createNewCanvas() async {
    DateTime now = DateTime.now();
    String title = "Untitled Meowsterpiece ${_canvasList.length + 1}";
    int id = await _database.addNewCanvas(title, now, now);

    _canvasList.add(
      CanvasDetails(
        id: id,
        title: title,
        imageData: Uint8List(0),
        createdAt: now,
        updatedAt: now,
      ),
    );
    return (id, title);
  }

  /// Updates the details of an existing canvas.
  Future<void> updateCanvas(
    int canvasId,
    String newTitle,
    Uint8List newImageData,
  ) async {
    await _database.updateCanvasDetails(
      canvasId,
      newTitle,
      newImageData,
    );

    final canvasToUpdate = _canvasList.firstWhere(
      (canvas) => canvas.id == canvasId,
    );
    canvasToUpdate.imageData = newImageData;
    if (newTitle.isNotEmpty) canvasToUpdate.title = newTitle;
    canvasToUpdate.updatedAt = DateTime.now();
    notifyListeners();
  }

  /// Deletes selected canvases.
  Future<void> deleteCanvases() async {
    await _database.deleteCanvases([..._selectedCanvases]);
    _canvasList.removeWhere((canvas) => _selectedCanvases.contains(canvas.id));
    _multiSelectionEnabled = false;
    _selectedCanvases.clear();
    notifyListeners();
  }

  /// Updates the selection of canvases.
  void updateCanvasSelection(int id) {
    if (_selectedCanvases.contains(id)) {
      _selectedCanvases.remove(id);
    } else {
      _selectedCanvases.add(id);
    }
    _multiSelectionEnabled = _selectedCanvases.isNotEmpty;
    notifyListeners();
  }

  /// Selects all canvases or clears selection based on the current state.
  void toggleSelectAll() {
    if (_selectedCanvases.length == _canvasList.length) {
      _selectedCanvases.clear();
      _multiSelectionEnabled = false;
    } else {
      _selectedCanvases.addAll(_canvasList.map((e) => e.id));
      _multiSelectionEnabled = true;
    }
    notifyListeners();
  }

  /// Toggles multi-selection mode.
  set enableMultiSelection(bool value) {
    _multiSelectionEnabled = value;
    if (!value) _selectedCanvases.clear();
    notifyListeners();
  }
}
