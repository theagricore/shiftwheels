import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class DeatilsAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const DeatilsAppBarWidget({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    
    return AppBar(
      title: Text(
        'Listing Details',
        style: TextStyle(
          color: AppColors.zblack,
          fontSize: isWeb ? 22 : 18,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.zWhite,
      leading: Padding(
        padding: EdgeInsets.all(isWeb ? 12.0 : 8.0),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            radius: isWeb ? 20 : 16,
            child: Icon(
              Icons.arrow_back, 
              color: Colors.white,
              size: isWeb ? 28 : 24,
            ),
          ),
        ),
      ),
    );
  }
}