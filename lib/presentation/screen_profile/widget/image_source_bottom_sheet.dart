import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/screen_profile/profile_image_bloc/profile_image_bloc.dart';
import 'package:shiftwheels/presentation/screen_profile/widget/image_option_button.dart';

class ImageSourceBottomSheet extends StatelessWidget {
  const ImageSourceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ImageOptionButton(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  iconColor: AppColors.zGrey,
                  onTap: () {
                    context.read<ProfileImageBloc>().add(
                          PickProfileImageEvent(source: ImageSource.gallery),
                        );
                    Navigator.of(context).pop();
                  },
                ),
                ImageOptionButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  iconColor: AppColors.zGrey,
                  onTap: () {
                    context.read<ProfileImageBloc>().add(
                          PickProfileImageEvent(source: ImageSource.camera),
                        );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

