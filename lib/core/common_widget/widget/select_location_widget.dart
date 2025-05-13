import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class SelectLocationWidget extends StatelessWidget {
  const SelectLocationWidget({
    super.key,
    required this.onUp,
    required this.onBottom,
  });

  final VoidCallback onUp;
  final VoidCallback onBottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onUp,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.zfontColor, width: 2.0),
            ),
            width: double.infinity,
            height: 60,
            child: Center(
              child: Text(
                "Current location",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        GestureDetector(
          onTap: onBottom,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.zfontColor, width: 2.0),
            ),
            width: double.infinity,
            height: 60,
            child: Center(
              child: Text(
                "Somewhere else",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
