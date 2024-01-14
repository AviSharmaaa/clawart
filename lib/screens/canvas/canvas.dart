import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../theme/colors.dart';
import '../../theme/styles.dart';
import 'actions/canvas_action.dart';
import 'view_models/canvas_view_model.dart';
import 'widgets/canvas_painter.dart';

class PaintingCanvas extends StatefulWidget {
  const PaintingCanvas({super.key});

  @override
  State<PaintingCanvas> createState() => _PaintingCanvasState();
}

class _PaintingCanvasState extends State<PaintingCanvas> {
  late ScreenshotController _screenshotController;
  late TextEditingController _textController;
  late CanvasAction _canvasAction;

  @override
  void initState() {
    super.initState();
    _canvasAction = CanvasAction.getInstance(context);
    _screenshotController = ScreenshotController();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;
    final mediaQueryPadding = MediaQuery.of(context).padding;
    return Consumer<CanvasViewModel>(builder: (_, vm, __) {
      _textController.text = vm.title;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: vm.canvasColor,
        body: SafeArea(
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              _buildDrawingArea(vm),
              _buildTopBarControls(vm, _canvasAction),
              _buildColorPicker(vm, mediaQuerySize),
              _buildStrokeSlider(vm, mediaQueryPadding),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDrawingArea(CanvasViewModel vm) {
    return GestureDetector(
      onPanStart: vm.onPanStart,
      onPanUpdate: vm.onPanUpdate,
      onPanEnd: vm.onPanEnd,
      child: RepaintBoundary(
        child: Screenshot(
          controller: _screenshotController,
          child: CustomPaint(
            painter: CanvasPainter(drawingPoints: vm.drawingPoints),
            isComplex: true,
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBarControls(CanvasViewModel vm, CanvasAction action) {
    final Color color = vm.isDarkTheme ? AppColor.white : AppColor.background;
    return Positioned(
      top: 20,
      right: 10,
      left: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.55,
                child: TextField(
                  controller: _textController,
                  onChanged: vm.onChanged,
                  style: P16.regular.apply(
                    color: vm.isDarkTheme ? AppColor.white : AppColor.primary,
                  ),
                  textInputAction: TextInputAction.done,
                  maxLength: 25,
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "Enter Title",
                    enabledBorder: !vm.isDarkTheme
                        ? UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColor.primary,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              const Spacer(),
              _buildIconButton(
                () async {
                  Uint8List? imageData = await _screenshotController.capture();
                  if (imageData == null) return;
                  await action.saveDoodleData(imageData);
                },
                Icons.check_rounded,
                color,
              ),
              const SizedBox(width: 10),
              _buildIconButton(
                () async {
                  Uint8List? imageData = await _screenshotController.capture();
                  if (imageData == null) return;
                  await action.shareDoodle(imageData, vm.title);
                },
                Icons.share_rounded,
                color,
              ),
              const SizedBox(width: 10),
              _buildIconButton(
                vm.toggleTheme,
                vm.isDarkTheme
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_sharp,
                color,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          _buildIconButton(
            vm.undo,
            Icons.undo_rounded,
            color,
          ),
          const SizedBox(
            height: 10,
          ),
          _buildIconButton(
            vm.redo,
            Icons.redo_rounded,
            color,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(VoidCallback onPressed, IconData icon, Color color) {
    final double opacity = color == AppColor.background ? 0.05 : 0.15;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(opacity),
          shape: BoxShape.circle,
          border: Border.all(
            width: 1.5,
            color: color.withOpacity(0.2),
          ),
        ),
        child: Icon(icon),
      ),
    );
  }

  Widget _buildColorPicker(CanvasViewModel vm, Size mediaQuerySize) {
    return Positioned(
      bottom: mediaQuerySize.height * 0.03,
      left: 20,
      child: SizedBox(
        height: 30,
        width: mediaQuerySize.width,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: vm.availableColors.length,
          itemBuilder: (context, index) => _buildColorPickerItem(vm, index),
        ),
      ),
    );
  }

  Widget _buildColorPickerItem(CanvasViewModel vm, int index) {
    bool isSelected = vm.selectedColor == vm.availableColors[index];
    return GestureDetector(
      onTap: () => vm.updateSelectedColor(index),
      child: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: vm.availableColors[index],
          shape: BoxShape.circle,
        ),
        child: isSelected
            ? Icon(Icons.check_rounded, color: AppColor.white, size: 20)
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildStrokeSlider(CanvasViewModel vm, EdgeInsets mediaQueryPadding) {
    return Positioned(
      top: mediaQueryPadding.top + 120,
      right: 0,
      bottom: 80,
      child: RotatedBox(
        quarterTurns: 3,
        child: Slider(
          value: vm.strokeWidth,
          min: 1,
          max: 10,
          onChanged: (value) => vm.strokeWidth = value,
          thumbColor: AppColor.primary.shade500,
          activeColor: AppColor.primary.shade500,
          inactiveColor: AppColor.primary.shade900.withOpacity(0.5),
        ),
      ),
    );
  }
}
