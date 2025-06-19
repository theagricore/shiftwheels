import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';

class MessageScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MessageScreenAppBar({
    super.key,
    required this.otherUser,
    required this.ad,
  });

  final UserModel? otherUser;
  final AdsModel? ad;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.zPrimaryColor,
      elevation: 2,
      leading: const BackButton(color: Colors.white),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              (otherUser?.fullName?.isNotEmpty ?? false)
                  ? otherUser!.fullName![0].toUpperCase()
                  : "?",
              style: const TextStyle(color: AppColors.zPrimaryColor),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                otherUser?.fullName ?? 'Unknown User',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (ad != null)
                Text(
                  '${ad!.brand} ${ad!.model}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
