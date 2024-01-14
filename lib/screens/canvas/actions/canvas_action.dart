import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../components/base_action.dart';
import '../../../components/loader.dart';
import '../../home/view_models/home_view_model.dart';
import '../view_models/canvas_view_model.dart';

class CanvasAction extends BaseAction {
  final CanvasViewModel _canvasVM;
  final HomeViewModel _homeVM;

  static CanvasAction? instance;

  CanvasAction(
    this._canvasVM,
    this._homeVM,
    super.loader,
  );

  factory CanvasAction.getInstance(BuildContext context) {
    if (instance != null) {
      return instance!;
    }

    instance = CanvasAction(
      Provider.of<CanvasViewModel>(context, listen: false),
      Provider.of<HomeViewModel>(context, listen: false),
      DefaultLoader(),
    );

    return instance!;
  }

  Future<void> saveDoodleData(Uint8List imageData) async {
    await performCall(() async {
      await _homeVM.updateCanvas(
        _canvasVM.canvasId,
        _canvasVM.title,
        imageData,
      );
      await _canvasVM.saveDoodleData();
    });
  }

  Future<void> shareDoodle(Uint8List imageData, String title) async {
    await performCall(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = await File('${dir.path}/$title.png').create();
      await file.writeAsBytes(imageData);

      await Share.shareXFiles([XFile(file.path)]);
    });
  }
}
