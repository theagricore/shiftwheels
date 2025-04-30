import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/commonWidget/Widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/commonWidget/Widget/basic_snakbar.dart';
import 'package:shiftwheels/core/commonWidget/basic_app_bar.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/core/config/theme/text_string.dart';
import 'package:shiftwheels/presentation/MainScreen/ScreenProfile/ProfileBloc/profile_bloc.dart';
import 'package:shiftwheels/presentation/auth/AuthBloc/auth_bloc.dart';
import 'package:shiftwheels/presentation/auth/screens/signin_screen.dart';

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
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.zPrimaryColor,
                  child: CircleAvatar(
                    radius: 57,
                    backgroundColor: AppColors.zPrimaryColor,
                    backgroundImage:
                        state is Profileloaded && state.user.image != null
                            ? NetworkImage(state.user.image!)
                            : null,
                    child:
                        state is! Profileloaded || state.user.image == null
                            ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            )
                            : null,
                  ),
                ),
                const SizedBox(height: 20),
                // User Name
                _buildProfileInfo(
                  context,
                  state is Profileloaded ? state.user.fullName : null,
                  state is Profileloading,
                  state is ProfileInfoFailure,
                  'Full Name',
                ),
                const SizedBox(height: 10),
                // Email
                _buildProfileInfo(
                  context,
                  state is Profileloaded ? state.user.email : null,
                  state is Profileloading,
                  state is ProfileInfoFailure,
                  'Email',
                ),
                const SizedBox(height: 10),
                // Phone Number
                _buildProfileInfo(
                  context,
                  state is Profileloaded ? state.user.phoneNo.toString() : null,
                  state is Profileloading,
                  state is ProfileInfoFailure,
                  'Phone Number',
                ),
                const Spacer(),
                // Logout Button
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
                        context.read<AuthBloc>().add(LogoutEvent());
                      },
                      isLoading: state is AuthLoading,
                      title: zSignOut,
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileInfo(
    BuildContext context,
    String? text,
    bool isLoading,
    bool isError,
    String label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 4),
        if (isLoading)
          const SizedBox(
            height: 24,
            child: Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else if (isError)
          Text(
            'Failed to load $label',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.red),
          )
        else
          Text(
            text ?? 'Not available',
            style: Theme.of(context).textTheme.titleMedium,
          ),
      ],
    );
  }
}
