import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class BottomContactBarWidget extends StatelessWidget {
  final VoidCallback onChatPressed;
  final VoidCallback onCallPressed;

  const BottomContactBarWidget({
    super.key,
    required this.onChatPressed,
    required this.onCallPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.zblack,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onChatPressed,
              icon: const Icon(
                Icons.chat,
                color: AppColors.zWhite,
                size: 22,
              ),
              label: const Text(
                "Chat",
                style: TextStyle(
                  color: AppColors.zWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.zPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onCallPressed,
              icon: const Icon(
                Icons.call,
                color: AppColors.zWhite,
                size: 22,
              ),
              label: const Text(
                "Call",
                style: TextStyle(
                  color: AppColors.zWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.zPrimaryColor.withOpacity(0.9),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}