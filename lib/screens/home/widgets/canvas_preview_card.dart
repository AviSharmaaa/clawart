import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_svg/svg.dart' show SvgPicture;

import '../../../theme/assets.dart';
import '../../../theme/colors.dart';
import '../../../theme/styles.dart';
import '../models/model.dart';

class CanvasPreviewCard extends StatelessWidget {
  const CanvasPreviewCard({
    Key? key,
    required this.canvasDetails,
    required this.isSelected,
    this.showSelectionIndicator = false,
  }) : super(key: key);

  final CanvasDetails canvasDetails;
  final bool isSelected;
  final bool showSelectionIndicator;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColor.neutral.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCanvasInfo(),
          const SizedBox(
            width: 15,
          ),
          _buildCanvasThumbnail(),
          _buildSelectedCheckCircle(isSelected)
        ],
      ),
    );
  }

  Widget _buildCanvasInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            canvasDetails.title,
            style: P18.medium,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('MMM d, yyyy').format(canvasDetails.updatedAt),
            style: P14.regular.apply(
              color: AppColor.neutral,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvasThumbnail() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: AppColor.neutral.withOpacity(0.35),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: canvasDetails.imageData.isNotEmpty
          ? Image.memory(
              canvasDetails.imageData,
              fit: BoxFit.contain,
            )
          : SvgPicture.asset(
              AppAssets.icons.placeholder,
              fit: BoxFit.contain,
            ),
    );
  }

  Widget _buildSelectedCheckCircle(bool isSelected) {
    return AnimatedSize(
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 400),
      child: Container(
        width: showSelectionIndicator ? 25 : 0,
        height: showSelectionIndicator ? 25 : 0,
        margin: EdgeInsets.only(left: showSelectionIndicator ? 15 : 0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColor.primary.shade500 : AppColor.transparent,
          border: isSelected
              ? Border.all()
              : Border.all(
                  width: 1.5,
                  color: AppColor.neutral.withOpacity(0.35),
                ),
        ),
        child: isSelected
            ? Icon(
                Icons.check_rounded,
                color: AppColor.white,
                size: 15,
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
