import 'package:flutter/material.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/shared/widget/shimmer_box.dart';
import 'package:pulse/shared/widget/shimmer_circle.dart';

class ChatTileShimmer extends StatelessWidget {
  const ChatTileShimmer({super.key});

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
          ShimmerCircle(radius: 26),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                  width: double.infinity,
                  height: 15,
                  borderRedius: 4,
                ),
                SizedBox(
                  height: 8,
                ),
                ShimmerBox(
                  width: 160,
                  height: 12,
                  borderRedius: 6,
                )
              ],
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShimmerBox(width: 36, height: 11, borderRedius: 4),
              SizedBox(height: 8),
              ShimmerBox(width: 20, height: 20, borderRedius: 10),
            ],
          )
        ],
      ),
    );
  }
}
