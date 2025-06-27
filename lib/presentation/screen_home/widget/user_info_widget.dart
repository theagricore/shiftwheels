import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({
    super.key,
    required this.userData,
    required this.ad,
  });

  final UserModel? userData;
  final AdsModel ad;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.zWhite.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.zPrimaryColor,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Profile Picture with Error Handling
          _buildProfileAvatar(),
          const SizedBox(width: 16),
          // User Details
          _buildUserDetails(),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return SizedBox(
      width: 70,
      height: 70,
      child: CircleAvatar(
        backgroundColor: AppColors.zPrimaryColor,
        child: ClipOval(
          child: userData?.image != null
              ? CachedNetworkImage(
                  imageUrl: userData!.image!,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.person,
                    size: 30,
                    color: AppColors.zWhite,
                  ),
                )
              : const Icon(
                  Icons.person,
                  size: 30,
                  color: AppColors.zWhite,
                ),
        ),
      ),
    );
  }

  Widget _buildUserDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Posted by:",
            style: TextStyle(
              color: AppColors.zWhite,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
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
            style: const TextStyle(
              color: AppColors.zWhite,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Posted on: ${DateFormat('dd MMM yyyy').format(ad.postedDate)}",
            style: const TextStyle(
              color: AppColors.zWhite,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}