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
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.zWhite.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.zPrimaryColor.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 37,
            backgroundColor: AppColors.zPrimaryColor.withOpacity(0.2),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: AppColors.zblack,
              backgroundImage: (userData?.image != null && userData!.image!.isNotEmpty)
                  ? NetworkImage(userData!.image!)
                  : null,
              child: (userData?.image == null || userData!.image!.isEmpty)
                  ? Icon(
                      Icons.person,
                      size: 32,
                      color: AppColors.zWhite.withOpacity(0.9),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                const SizedBox(height: 2),
                Text(
                  userData?.fullName ?? "No Name",
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.zWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userData?.email ?? "No Email",
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.zWhite.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppColors.zWhite.withOpacity(0.7),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      "Posted on: ${DateFormat('dd MMM yyyy').format(DateTime.parse(ad.postedDate.toString()))}",
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.zWhite.withOpacity(0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}