import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductShimmer extends StatelessWidget {
  const ProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(height: 12, width: 100, color: Colors.white),
            const SizedBox(height: 6),
            Container(height: 12, width: 60, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
