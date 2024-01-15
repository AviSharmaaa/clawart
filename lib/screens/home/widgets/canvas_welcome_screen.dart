import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:rive/rive.dart' show RiveAnimation;

import '../../../theme/assets.dart';
import '../../../theme/colors.dart';
import '../../../theme/styles.dart';
import '../actions/home_action.dart';

class CanvasWelcomeScreen extends StatelessWidget {
  const CanvasWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        _buildBackgroundAnimation(size),
        _buildBlurEffect(),
        _buildContent(context, size),
      ],
    );
  }

  Widget _buildBackgroundAnimation(Size size) {
    return Positioned(
      top: -size.height * 0.25,
      child: SizedBox(
        height: size.height * 0.9,
        width: size.width,
        child: RiveAnimation.asset(
          AppAssets.animations.shapes,
        ),
      ),
    );
  }

  Widget _buildBlurEffect() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: const SizedBox(),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildMainAnimation(size),
          Text(
            "Empty Canvas Awaits!",
            style: P22.medium.apply(color: AppColor.white),
          ),
          const SizedBox(height: 20),
          Text(
            "Blank canvas beckons—paint your purr-sonality with flair!",
            style: P18.medium.apply(color: AppColor.neutral),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _buildGetStartedButton(context),
        ],
      ),
    );
  }

  Widget _buildMainAnimation(Size size) {
    return SizedBox(
      height: size.height * 0.4,
      width: size.width,
      child: RiveAnimation.asset(
        AppAssets.animations.cat,
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return SizedBox(
      width: 150.0,
      height: 55.0,
      child: ElevatedButton(
        onPressed: () {
          HomeAction.getInstance(context).openCanvas();
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColor.primary.shade500,
          textStyle: P18.medium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(200),
          ),
        ),
        child: Text(
          "Get Started",
          style: P18.medium.apply(
            color: AppColor.white,
          ),
        ),
      ),
    );
  }
}
