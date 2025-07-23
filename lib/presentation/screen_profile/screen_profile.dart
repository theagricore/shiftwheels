import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_alert_box.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/config/helper/navigator/app_navigator.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/add_post/post_limit_bloc/post_limit_bloc.dart';
import 'package:shiftwheels/presentation/auth/auth_bloc/auth_bloc.dart';
import 'package:shiftwheels/presentation/auth/screens/signin_screen.dart';
import 'package:shiftwheels/presentation/compare_screen/compare_screen.dart';
import 'package:shiftwheels/presentation/screen_profile/ProfileBloc/profile_bloc.dart';
import 'package:shiftwheels/presentation/screen_profile/profile_image_bloc/profile_image_bloc.dart';
import 'package:shiftwheels/presentation/screen_profile/widget/full_image_dialog.dart';
import 'package:shiftwheels/presentation/screen_profile/widget/image_source_bottom_sheet.dart';
import 'package:shiftwheels/presentation/screen_profile/widget/premium_card.dart';
import 'package:shiftwheels/presentation/screen_profile/widget/profile_avathar.dart';
import 'package:shiftwheels/presentation/screen_profile/widget/profile_item.dart';

class ScreenProfile extends StatelessWidget {
  const ScreenProfile({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        context.read<PostLimitBloc>().add(CheckPostLimitEvent(currentUser.uid));
        context.read<ProfileBloc>().add(FetchUserProfile());
      }
    });

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Future.delayed(const Duration(milliseconds: 500), () {
            AppNavigator.pushAndRemoveUntil(context, SigninScreen());
          });
          BasicSnackbar(
            message: 'Logged out successfully',
            backgroundColor: AppColors.zGreen,
          ).show(context);
        } else if (state is AuthFailure) {
          BasicSnackbar(
            message: state.errorMessage,
            backgroundColor: AppColors.zred,
          ).show(context);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            String? backgroundImageUrl;

            if (profileState is Profileloaded &&
                profileState.user.image != null) {
              backgroundImageUrl = profileState.user.image;
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        if (backgroundImageUrl != null)
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(backgroundImageUrl),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.4),
                                  BlendMode.darken,
                                ),
                              ),
                            ),
                          )
                        else
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.zPrimaryColor,
                                  Color.fromARGB(255, 231, 211, 99),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        Container(
                          color: Colors.black.withOpacity(0.3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 50),
                              Center(
                                child: BlocConsumer<
                                  ProfileImageBloc,
                                  ProfileImageState
                                >(
                                  listener: (context, imageState) {
                                    if (imageState is ProfileImagePicked) {
                                      _showImageScreen(context, imageState);
                                    } else if (imageState
                                        is ProfileImageError) {
                                      BasicSnackbar(
                                        message: imageState.message,
                                        backgroundColor: AppColors.zred,
                                      ).show(context);
                                    } else if (imageState
                                        is ProfileImageConfirmed) {
                                      BasicSnackbar(
                                        message:
                                            'Profile image updated successfully',
                                        backgroundColor: AppColors.zGreen,
                                      ).show(context);
                                      context.read<ProfileBloc>().add(
                                        FetchUserProfile(),
                                      );
                                    }
                                  },
                                  builder: (context, imageState) {
                                    return GestureDetector(
                                      onTap:
                                          () => _showImageSourceDialog(context),
                                      child: ProfileAvatar(
                                        profileState: profileState,
                                        imageState: imageState,
                                        onTap:
                                            () =>
                                                _showImageSourceDialog(context),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                profileState is Profileloaded
                                    ? profileState.user.fullName
                                    : 'Loading...',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(color: AppColors.zWhite),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                profileState is Profileloaded
                                    ? profileState.user.email
                                    : 'loading...',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.zWhite),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionTitle(context, 'Account Type'),
                    BlocBuilder<PostLimitBloc, PostLimitState>(
                      builder: (context, limitState) {
                        if (limitState is PostLimitChecked) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: PremiumCard(
                              limit: limitState.limit,
                              onRefresh: () {
                                final currentUser =
                                    FirebaseAuth.instance.currentUser;
                                if (currentUser != null) {
                                  context.read<PostLimitBloc>().add(
                                    CheckPostLimitEvent(currentUser.uid),
                                  );
                                }
                              },
                            ),
                          );
                        } else if (limitState is PostLimitError) {
                          return Text(
                            'Error loading account status: ${limitState.message}',
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    _buildSectionTitle(context, 'My Listings'),

                    ProfileListItem(
                      icon: Icons.favorite_outline,
                      title: 'Saved Cars',
                      onTap: () {},
                    ),
                    ProfileListItem(
                      icon: Icons.compare,
                      title: 'Compare',
                      onTap: () {
                        AppNavigator.push(context, CompareScreen());
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildSectionTitle(context, 'App Settings'),

                    NotificationListItem(
                      title: 'Notifications',
                      value: true,
                      onChanged: (val) {},
                    ),
                    ProfileListItem(
                      icon: Icons.settings_outlined,
                      title: 'App Preferences',
                      onTap: () {},
                    ),
                    ProfileListItem(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () {},
                    ),
                    ProfileListItem(
                      icon: Icons.info_outline,
                      title: 'About App',
                      onTap: () {},
                    ),
                    ProfileListItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      isDestructive: true,
                      onTap: () {
                        showLogoutConfirmationDialog(
                          context: context,
                          onConfirm: () {
                            context.read<AuthBloc>().add(LogoutEvent());
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                  ]),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 24, bottom: 12),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
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
