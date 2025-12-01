import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
