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
    return AppBar(
      title: const Text(
        'Listing Details',
        style: TextStyle(color: AppColors.zblack),
      ),
      centerTitle: true,
      backgroundColor: AppColors.zWhite,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
      ),
    );
  }
}