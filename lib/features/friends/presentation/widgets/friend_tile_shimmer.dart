import 'package:flutter/material.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/widget/shimmer_box.dart';
import 'package:pulse/core/widget/shimmer_circle.dart';

class FriendTileShimmer extends StatelessWidget {
  const FriendTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: PulseColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          ShimmerCircle(radius: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                  width: double.infinity,
                  height: 14,
                  borderRedius: 6,
                ),
                SizedBox(height: 8),
                ShimmerBox(
                  width: 80,
                  height: 11,
                  borderRedius: 6,
                ),
              ],
            ),
          ),
          ShimmerBox(width: 36, height: 36, borderRedius: 18),
        ],
      ),
    );
  }
}
