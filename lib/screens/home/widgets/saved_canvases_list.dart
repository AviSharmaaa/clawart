import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../theme/assets.dart';
import '../../../theme/colors.dart';
import '../../../theme/styles.dart';
import '../actions/home_action.dart';
import '../models/model.dart';
import '../view_models/home_view_model.dart';
import 'canvas_preview_card.dart';

class SavedCanvasesList extends StatelessWidget {
  const SavedCanvasesList({
    Key? key,
  }) : super(key: key);

  Widget _sizedbox(double height) => SizedBox(
        height: height,
      );

  final Duration _duration = const Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    final HomeAction homeAction = HomeAction.getInstance(context);
    return Consumer<HomeViewModel>(builder: (_, vm, __) {
      return SafeArea(
        child: GestureDetector(
          onTap: () => vm.enableMultiSelection = false,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sizedbox(30),
                _buildHeader(homeAction),
                _sizedbox(10),
                AnimatedSwitcher(
                  duration: _duration,
                  child: vm.multiSelectionEnabled
                      ? _buildSelectionInfo(
                          vm,
                          vm.toggleSelectAll,
                        )
                      : _buildAllLabel(),
                ),
                _sizedbox(20),
                _buildCanvasList(
                  vm,
                  (CanvasDetails canvas) async {
                    if (vm.multiSelectionEnabled) {
                      vm.updateCanvasSelection(canvas.id);
                      return;
                    }
                    await homeAction.getSavedDoodle(
                      canvas.id,
                      canvas.title,
                    );
                  },
                  (CanvasDetails canvas) async {
                    if (vm.multiSelectionEnabled) return;
                    vm.enableMultiSelection = true;
                    vm.updateCanvasSelection(canvas.id);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader(HomeAction homeAction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Hey, Pawcasso", style: P22.bold),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onDoubleTap: homeAction.showEasterEgg,
          child: CircleAvatar(
            child: Image.asset(
              AppAssets.images.avatar,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAllLabel() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: AppColor.primary.shade500, width: 2.5)),
      ),
      child: Text(
        "All",
        style: P16.medium.copyWith(
          color: AppColor.primary.shade500,
        ),
      ),
    );
  }

  Widget _buildSelectionInfo(HomeViewModel vm, VoidCallback callback) {
    final int selectedCount = vm.selectedCanvases.length;
    final String selectionText =
        "$selectedCount ${selectedCount > 1 ? "Canvases" : "Canvas"} Selected";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          selectionText,
          style: P18.regular.apply(
            color: AppColor.white,
          ),
        ),
        GestureDetector(
          onTap: callback,
          child: SvgPicture.asset(
            AppAssets.icons.selectAll,
            width: 25,
            height: 25,
            colorFilter: ColorFilter.mode(
              AppColor.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCanvasList(
    HomeViewModel vm,
    Function(CanvasDetails) onTap,
    Function(CanvasDetails) onLongPress,
  ) {
    return Expanded(
      child: ListView.builder(
        itemCount: vm.canvasList.length,
        itemBuilder: (context, index) {
          final canvasDetail = vm.canvasList[index];
          return GestureDetector(
            onTap: () => onTap(canvasDetail),
            onLongPress: () => onLongPress(canvasDetail),
            child: CanvasPreviewCard(
              canvasDetails: canvasDetail,
              isSelected: vm.selectedCanvases.contains(canvasDetail.id),
              showSelectionIndicator: vm.multiSelectionEnabled,
            ),
          );
        },
      ),
    );
  }
}
