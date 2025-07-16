import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/screen_profile/ProfileBloc/profile_bloc.dart';
import 'package:shiftwheels/presentation/screen_profile/profile_image_bloc/profile_image_bloc.dart';

class ProfileAvatar extends StatelessWidget {
  final ProfileState profileState;
  final ProfileImageState imageState;
  final VoidCallback onTap;

  const ProfileAvatar({
    super.key,
    required this.profileState,
    required this.imageState,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String? imageUrl;

    if (imageState is ProfileImageConfirmed) {
      imageUrl = (imageState as ProfileImageConfirmed).imageUrl;
    } else if (profileState is Profileloaded &&
        (profileState as Profileloaded).user.image != null) {
      imageUrl = (profileState as Profileloaded).user.image!;
    }

    final bool showDefaultIcon = imageUrl == null;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.zPrimaryColor,
            child: CircleAvatar(
              radius: 57,
              backgroundColor: AppColors.zPrimaryColor,
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
              child: showDefaultIcon
                  ? const Icon(Icons.person, size: 60, color: Colors.white)
                  : null,
            ),
          ),
          if (imageState is ProfileImageLoading)
            SizedBox(
              width: 128,
              height: 128,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.zPrimaryColor,
                ),
                backgroundColor: Colors.white24,
              ),
            ),
        ],
      ),
    );
  }
}
