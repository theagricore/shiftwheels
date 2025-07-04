import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedLottieButtonWidget extends StatelessWidget {
  final String animationAsset;
  final String? label;
  final VoidCallback onTap;

  const AnimatedLottieButtonWidget({
    super.key,
    required this.animationAsset,
    required this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 60,
              width: double.infinity,
              child: Lottie.asset(
                animationAsset,
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
            if (label != null)
              Text(
                label!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
