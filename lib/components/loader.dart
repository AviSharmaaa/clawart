import 'package:flutter/material.dart';
import 'package:rive/rive.dart' show RiveAnimation;

import '../core/navigation_service.dart';
import '../theme/assets.dart';

abstract class Loader {
  void show();

  void hide();
}

class AnimatedLoader extends StatefulWidget {
  const AnimatedLoader({super.key});

  @override
  State<AnimatedLoader> createState() => AnimatedLoaderState();
}

class AnimatedLoaderState extends State<AnimatedLoader>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          child: RiveAnimation.asset(
            AppAssets.animations.loader,
          ),
        ),
      ),
    );
  }
}

class DefaultLoader extends Loader {
  late bool _canPop = false;
  late PageRoute _pageRoute;

  DefaultLoader();

  @override
  void show() {
    _canPop = false;
    _pageRoute = PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => PopScope(
        canPop: _canPop,
        child: const AnimatedLoader(),
      ),
    );
    NavigationService.navigatorKey.currentState!.push(_pageRoute);
  }

  @override
  void hide() {
    _canPop = true;
    NavigationService.navigatorKey.currentState!.removeRoute(_pageRoute);
  }
}
