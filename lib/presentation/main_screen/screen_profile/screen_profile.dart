import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_alert_box.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/core/config/theme/text_string.dart';
import 'package:shiftwheels/presentation/auth/auth_bloc/auth_bloc.dart';
import 'package:shiftwheels/presentation/auth/screens/signin_screen.dart';
import 'package:shiftwheels/presentation/main_screen/screen_profile/ProfileBloc/profile_bloc.dart';

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
                    child: state is! Profileloaded || state.user.image == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                if (state is Profileloaded)
                  Text(
                    state.user.fullName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                const SizedBox(height: 10),
                if (state is Profileloaded)
                  Text(
                    state.user.email,
                    style: Theme.of(context).textTheme.bodyLarge,
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
                          context: context, onConfirm: (){
                          context.read<AuthBloc>().add(LogoutEvent());
                        });
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
}