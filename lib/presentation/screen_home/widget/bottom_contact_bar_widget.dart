import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class BottomContactBarWidget extends StatelessWidget {
  final VoidCallback onChatPressed;
  final VoidCallback onCallPressed;
  final bool isAdSold;

  const BottomContactBarWidget({
    super.key,
    required this.onChatPressed,
    required this.onCallPressed,
    required this.isAdSold,
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
              onPressed: isAdSold ? null : onChatPressed,
              icon: Icon(
                Icons.chat,
                color: isAdSold ? Colors.grey : AppColors.zWhite,
                size: 22,
              ),
              label: Text(
                "Chat",
                style: TextStyle(
                  color: isAdSold ? Colors.grey : AppColors.zWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isAdSold 
                    ? Colors.grey.withOpacity(0.5) 
                    : AppColors.zPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: isAdSold ? 0 : 2,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isAdSold ? null : onCallPressed,
              icon: Icon(
                Icons.call,
                color: isAdSold ? Colors.grey : AppColors.zWhite,
                size: 22,
              ),
              label: Text(
                "Call",
                style: TextStyle(
                  color: isAdSold ? Colors.grey : AppColors.zWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isAdSold
                    ? Colors.grey.withOpacity(0.5)
                    : AppColors.zPrimaryColor.withOpacity(0.9),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: isAdSold ? 0 : 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}