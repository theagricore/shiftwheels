import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key, required this.userData, required this.ad});

  final UserModel? userData;
  final AdsModel ad;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.zWhite.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.zPrimaryColor, width: 1.5),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36.5,
            backgroundColor: AppColors.zPrimaryColor,
            child: CircleAvatar(
              radius: 35,
              backgroundColor: AppColors.zPrimaryColor,
              backgroundImage:
                  (userData?.image != null && userData!.image!.isNotEmpty)
                      ? NetworkImage(userData!.image!)
                      : null,
              child:
                  (userData?.image == null || userData!.image!.isEmpty)
                      ? const Icon(
                        Icons.person,
                        size: 30,
                        color: AppColors.zWhite,
                      )
                      : null,
            ),
          ),

          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Posted by :",
                  style: TextStyle(color: AppColors.zWhite, fontSize: 13),
                ),
                Text(
                  userData?.fullName ?? "No Name",
                  style: const TextStyle(
                    color: AppColors.zWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userData?.email ?? "No Email",
                  style: const TextStyle(color: AppColors.zWhite, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  "Posted on: ${DateFormat('dd MMM yyyy').format(DateTime.parse(ad.postedDate.toString()))}",
                  style: const TextStyle(color: AppColors.zWhite, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
