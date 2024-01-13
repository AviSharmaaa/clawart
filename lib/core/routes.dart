import 'package:flutter/cupertino.dart';
import '../screens/canvas/canvas.dart';
import '../screens/home/home.dart';
import 'route_name.dart';

class Routes {
  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.canvas:
        return CupertinoPageRoute(
          builder: (_) => const PaintingCanvas(),
          settings: settings,
        );

      case RouteName.home:
        return CupertinoPageRoute(
          builder: (_) => const Home(),
          settings: settings,
        );
    }

    return null;
  }
}
