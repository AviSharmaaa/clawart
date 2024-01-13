import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../theme/assets.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';
import 'actions/home_action.dart';
import 'view_models/home_view_model.dart';
import 'widgets/canvas_welcome_screen.dart';
import 'widgets/saved_canvases_list.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  final Duration _duration = const Duration(milliseconds: 400);

  Widget? _buildFAB(bool showFAB, VoidCallback onTap) {
    if (!showFAB) return null;

    return TweenAnimationBuilder(
      curve: Curves.easeIn,
      tween: Tween(begin: 0.0, end: 1.0),
      duration: _duration,
      builder: (_, double val, Widget? child) {
        return Container(
          margin: EdgeInsets.only(bottom: val * 20, right: val * 10),
          height: val * 55,
          width: val * 55,
          decoration: BoxDecoration(
            color: AppColor.primary,
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onTap,
            child: Icon(
              Icons.add,
              size: val * 32,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget? _buildBottomSheet(bool showSheet, VoidCallback onTap) {
    if (!showSheet) return null;

    return TweenAnimationBuilder(
      curve: Curves.easeIn,
      duration: _duration,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (_, double val, __) {
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: val * 15,
            horizontal: val * 20,
          ),
          decoration: BoxDecoration(
            color: AppColor.background,
            border: Border(
              top: BorderSide(
                width: 1,
                color: AppColor.neutral.withOpacity(0.35),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onTap,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      AppAssets.icons.delete,
                      width: val * 22,
                      height: val * 22,
                      colorFilter: ColorFilter.mode(
                        AppColor.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Delete",
                      style: P12.regular.apply(
                        color: AppColor.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeAction = HomeAction.getInstance(context);

    return Consumer<HomeViewModel>(builder: (_, vm, __) {
      return Scaffold(
        floatingActionButton: _buildFAB(
          vm.showFAB,
          () async {
            await homeAction.openCanvas();
          },
        ),
        bottomNavigationBar: _buildBottomSheet(
          vm.canvasList.isNotEmpty && !vm.showFAB,
          () async {
            await homeAction.deleteCanvases();
          },
        ),
        body: vm.canvasList.isNotEmpty
            ? const SavedCanvasesList()
            : const CanvasWelcomeScreen(),
      );
    });
  }
}
