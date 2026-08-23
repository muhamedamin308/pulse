import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pulse/core/constants/pulse_colors.dart';

class ShimmerCircle extends StatelessWidget {
  final double radius;

  const ShimmerCircle({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: PulseColors.surface,
      highlightColor: PulseColors.surfaceVariant,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: const BoxDecoration(
          color: PulseColors.surface,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
