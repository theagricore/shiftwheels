import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_alert_box.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/config/theme/text_string.dart';
import 'package:shiftwheels/presentation/auth/auth_bloc/auth_bloc.dart';
import 'package:shiftwheels/presentation/auth/screens/signin_screen.dart';
import 'package:shiftwheels/presentation/main_screen/screen_profile/ProfileBloc/profile_bloc.dart';
import 'package:shiftwheels/presentation/main_screen/screen_profile/profile_image_bloc/profile_image_bloc.dart';
import 'package:shiftwheels/presentation/main_screen/screen_profile/widget/full_image_dialog.dart';
import 'package:shiftwheels/presentation/main_screen/screen_profile/widget/image_source_bottom_sheet.dart';
import 'package:shiftwheels/presentation/main_screen/screen_profile/widget/profile_avathar.dart';

class ScreenProfile extends StatelessWidget {
  const ScreenProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: true,
        title: Text(zProfile, style: Theme.of(context).textTheme.displayLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                BlocConsumer<ProfileImageBloc, ProfileImageState>(
                  listener: (context, imageState) {
                    if (imageState is ProfileImagePicked) {
                      _showImageScreen(context, imageState);
                    } else if (imageState is ProfileImageError) {
                      BasicSnackbar(
                        message: imageState.message,
                        backgroundColor: Colors.red,
                      ).show(context);
                    } else if (imageState is ProfileImageConfirmed) {
                      BasicSnackbar(
                        message: 'Profile image updated successfully',
                        backgroundColor: Colors.green,
                      ).show(context);
                    }
                  },
                  builder: (context, imageState) {
                    return GestureDetector(
                      onTap: () => _showImageSourceDialog(context),
                      child: ProfileAvatar(
                        profileState: profileState,
                        imageState: imageState,
                        onTap: () => _showImageSourceDialog(context),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                if (profileState is Profileloading)
                  const CircularProgressIndicator(),
                if (profileState is Profileloaded) ...[
                  Text(
                    profileState.user.fullName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    profileState.user.email,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
                if (profileState is ProfileInfoFailure)
                  Text(
                    profileState.message ?? 'Failed to load profile',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      BasicSnackbar(
                        message: state.message,
                        backgroundColor: Colors.green,
                      ).show(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SigninScreen()),
                      );
                    } else if (state is AuthFailure) {
                      BasicSnackbar(
                        message: state.errorMessage,
                        backgroundColor: Colors.red,
                      ).show(context);
                    }
                  },
                  builder: (context, state) {
                    return BasicElevatedAppButton(
                      onPressed: () {
                        showLogoutConfirmationDialog(
                          context: context,
                          onConfirm: () {
                            context.read<AuthBloc>().add(LogoutEvent());
                          },
                        );
                      },
                      isLoading: state is AuthLoading,
                      title: zSignOut,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const ImageSourceBottomSheet(),
    );
  }

  Future<void> _showImageScreen(
    BuildContext context,
    ProfileImagePicked imageState,
  ) {
    return showDialog(
      context: context,
      builder: (_) => FullImageDialog(image: imageState.image),
    );
  }
}
