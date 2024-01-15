import 'package:flutter/material.dart' show BuildContext;
import 'package:provider/provider.dart' show Provider;

import '../../../components/base_action.dart';
import '../../../components/easter_egg.dart';
import '../../../components/loader.dart';
import '../../../core/navigation_handler.dart';
import '../../../core/route_name.dart';
import '../../canvas/view_models/canvas_view_model.dart';
import '../view_models/home_view_model.dart';

class HomeAction extends BaseAction {
  final CanvasViewModel _canvasVM;
  final HomeViewModel _homeVM;
  final NavigationHandler _navigationHandler;
  final EasterEggHandler _easterHandler;

  static HomeAction? instance;

  HomeAction._(
    this._canvasVM,
    this._homeVM,
    this._navigationHandler,
    super.loader,
    this._easterHandler,
  );

  factory HomeAction.getInstance(BuildContext context) {
    return instance ??= HomeAction._(
      Provider.of<CanvasViewModel>(context, listen: false),
      Provider.of<HomeViewModel>(context, listen: false),
      Provider.of<NavigationHandler>(context, listen: false),
      DefaultLoader(),
      EasterEggHandler(),
    );
  }

  Future<void> openCanvas() async {
    await performCall(
      () async {
        final response = await _homeVM.createNewCanvas();
        _canvasVM.init(response.$1, response.$2);
        await _homeVM.fetchAllCanvases();
      },
      navigationCall: () async => await _navigationHandler.navigate(
        RouteName.canvas,
      ),
    );
  }

  Future<void> getSavedDoodle(int id, String canvasTitle) async {
    await performCall(
      () async {
        _canvasVM.init(id, canvasTitle);
        await _canvasVM.getDrawingData();
      },
      navigationCall: () async => await _navigationHandler.navigate(
        RouteName.canvas,
      ),
    );
  }

  Future<void> deleteCanvases() async {
    await performCall(() async {
      await _homeVM.deleteCanvases();
    });
  }

  void showEasterEgg() {
    _easterHandler.show();
  }
}
