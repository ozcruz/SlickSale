import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme.dart';

/// Wrap a layout of [SkeletonBox]es so the whole group shimmers in sync.
/// Every data-fetching state gets one of these — never a bare spinner.
class SkeletonShimmer extends StatelessWidget {
  const SkeletonShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceElevated,
      highlightColor: AppColors.border,
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
}

/// A single shimmering placeholder block. The fill color is a mask target —
/// [SkeletonShimmer] paints over it entirely.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.radius = AppRadii.md,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
    );
  }
}
