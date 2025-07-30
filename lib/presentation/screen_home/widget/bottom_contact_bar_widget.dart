import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class BottomContactBarWidget extends StatelessWidget {
  final VoidCallback onChatPressed;
  final VoidCallback onCallPressed;
  final bool isAdSold;
  final bool isWeb;

  const BottomContactBarWidget({
    super.key,
    required this.onChatPressed,
    required this.onCallPressed,
    required this.isAdSold,
    this.isWeb = false,
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
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 24 : 16,
        vertical: isWeb ? 16 : 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isAdSold ? null : onChatPressed,
              icon: Icon(
                Icons.chat,
                color: isAdSold ? Colors.grey : AppColors.zWhite,
                size: isWeb ? 26 : 22,
              ),
              label: Text(
                "Chat",
                style: TextStyle(
                  color: isAdSold ? Colors.grey : AppColors.zWhite,
                  fontSize: isWeb ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isAdSold 
                    ? Colors.grey.withOpacity(0.5) 
                    : AppColors.zPrimaryColor,
                padding: EdgeInsets.symmetric(vertical: isWeb ? 18 : 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: isAdSold ? 0 : 2,
              ),
            ),
          ),
          SizedBox(width: isWeb ? 16 : 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isAdSold ? null : onCallPressed,
              icon: Icon(
                Icons.call,
                color: isAdSold ? Colors.grey : AppColors.zWhite,
                size: isWeb ? 26 : 22,
              ),
              label: Text(
                "Call",
                style: TextStyle(
                  color: isAdSold ? Colors.grey : AppColors.zWhite,
                  fontSize: isWeb ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isAdSold
                    ? Colors.grey.withOpacity(0.5)
                    : AppColors.zPrimaryColor.withOpacity(0.9),
                padding: EdgeInsets.symmetric(vertical: isWeb ? 18 : 16),
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