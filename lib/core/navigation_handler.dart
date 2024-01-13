import 'package:flutter/material.dart';

import 'navigation_service.dart';

class NavigationHandler {
  final context = NavigationService.navigatorKey.currentContext!;
  Future<void> navigate(String routeName) async {
    await Navigator.of(context).pushNamed(routeName);
  }

  void pop() async {
    Navigator.pop(context);
  }
}
