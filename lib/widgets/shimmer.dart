import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingEffect extends StatelessWidget {
  const ShimmerLoadingEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200.0,
              height: 20.0,
              color: Colors.white,
            ),
            const SizedBox(height: 3.0),
            Container(
              width: 150.0,
              height: 16.0,
              color: Colors.white,
            ),
            const SizedBox(height: 3.0),
            Container(
              width: 100.0,
              height: 16.0,
              color: Colors.white,
            ),
            const SizedBox(height: 3.0),
            Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
