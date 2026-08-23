import 'package:flutter/material.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRedius;

  const ShimmerBox(
      {super.key,
      required this.width,
      required this.height,
      this.borderRedius = 8});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: PulseColors.surface,
      highlightColor: PulseColors.surfaceVariant,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: PulseColors.surface,
            borderRadius: BorderRadius.circular(borderRedius)),
      ),
    );
  }
}
