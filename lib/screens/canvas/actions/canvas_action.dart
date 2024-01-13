import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

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

  Future<void> saveDoodleData(ScreenshotController controller) async {
    await performCall(() async {
      final Uint8List? imageData = await controller.capture();
      await _homeVM.updateCanvas(
        _canvasVM.canvasId,
        _canvasVM.title,
        imageData!,
      );
      await _canvasVM.saveDoodleData();
    });
  }
}
