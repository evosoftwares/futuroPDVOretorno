import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardMotoristaSkeleton extends StatelessWidget {
  const DashboardMotoristaSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skeleton for Welcome Card
            _buildSkeletonContainer(height: 80),
            const SizedBox(height: 16),

            // Skeleton for Status Toggle
            _buildSkeletonContainer(height: 60),
            const SizedBox(height: 16),

            // Skeleton for Location Status
            _buildSkeletonContainer(height: 60),
            const SizedBox(height: 16),

            // Skeleton for Summary Section
            _buildSkeletonContainer(height: 120),
            const SizedBox(height: 16),

            // Skeleton for Main Menu
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: List.generate(4, (_) => _buildSkeletonContainer(height: 120)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonContainer({required double height, double? width}) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
} 