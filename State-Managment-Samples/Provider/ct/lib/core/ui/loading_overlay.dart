
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget content;

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        content,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent background
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(

      child: Container(
        color: Colors.black.withOpacity(0.5), // Semi-transparent background
        child: const Center(
          child: SizedBox(width:64,height:64,child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class FullScreenShimmerEffect extends StatelessWidget {
  const FullScreenShimmerEffect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 15, // Adjust the count based on your needs
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
              height: 20,
              width: 200,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}