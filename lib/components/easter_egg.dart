import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:rive/rive.dart' show RiveAnimation;

import '../core/navigation_service.dart';
import '../theme/assets.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import 'glass_morphism.dart';

const List<String> catArtFacts = [
  "Raja Ravi Varma was known as the 'purrlific portraitist' of Indian art.",
  "M.F. Husain, often referred to as 'Meowbool Fida Husain', was a true trailblazer in modern Indian art.",
  "Leonardo da Vinci, the 'Renaissance Tomcat', was a master of both art and invention.",
  "Michelangelo, known as the 'Sistine Feline', painted the heavens with a divine 'paw'.",
  "Vincent van Gogh, the 'Starry Night Cat', painted with a passion as fiery as a wildcat's spirit.",
  "Pablo Picasso, the 'Cubist Cat', reshaped the art world with his innovative perspectives.",
  "Rembrandt, the 'Dutch Mastercat', was a legend of light and shadow in painting.",
  "Claude Monet, known as the 'Impressionist Cat', painted gardens as enchanting as a cat's paradise.",
  "Salvador Dalí, the 'Surrealist Siamese', bent reality in his paintings like a cat contorting to fit in a box.",
  "Caravaggio, the 'Chiaros-cat-o', was renowned for his dramatic, intense, and realistic art."
];

abstract class EasterEgg {
  void show();

  void hide();
}

class EasterEggOverlay extends StatelessWidget {
  const EasterEggOverlay({super.key, required this.catArtFact});
  final String catArtFact;
  final Duration _duration = const Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: _duration,
            builder: (_, val, child) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: val * 20),
                child: GlassMorphism(
                  opacity: 0.15,
                  blurFactor: 1.5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: val * 10,
                      vertical: val * 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: val * 250,
                          height: val * 250,
                          child: RiveAnimation.asset(
                            AppAssets.animations.easterEgg,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          catArtFact,
                          style: P18.medium.apply(
                            color: AppColor.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class EasterEggHandler extends EasterEgg {
  late PageRoute _pageRoute;

  EasterEggHandler();

  String _getRandomArtFact() {
    var randomIndex = Random().nextInt(catArtFacts.length);
    return catArtFacts[randomIndex];
  }

  @override
  void show() {
    _pageRoute = PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => GestureDetector(
        onTap: hide,
        behavior: HitTestBehavior.translucent,
        child: EasterEggOverlay(catArtFact: _getRandomArtFact(),),
      ),
    );
    NavigationService.navigatorKey.currentState!.push(_pageRoute);
  }

  @override
  void hide() {
    NavigationService.navigatorKey.currentState!.removeRoute(_pageRoute);
  }
}
