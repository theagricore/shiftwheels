import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/text_form_feald_widget.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_outlined_app_button.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/config/helper/navigator/app_navigator.dart';
import 'package:shiftwheels/core/config/theme/image_string.dart';
import 'package:shiftwheels/core/config/theme/text_string.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/presentation/auth/auth_bloc/auth_bloc.dart';
import 'package:shiftwheels/presentation/auth/google_auth/google_auth_bloc.dart';
import 'package:shiftwheels/presentation/auth/screens/signin_screen.dart';
import 'package:shiftwheels/presentation/main_screen/main_screen.dart';

class SiginupScreen extends StatelessWidget {
  SiginupScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            current is AuthSuccess || current is AuthFailure,
        listener: (context, state) {
          if (state is AuthSuccess) {
            BasicSnackbar(
              message: state.message,
              backgroundColor: Colors.green,
            ).show(context);
            AppNavigator.pushReplacement(context, const MainScreens());
          } else if (state is AuthFailure) {
            BasicSnackbar(
              message: state.errorMessage,
              backgroundColor: Colors.red,
            ).show(context);
          }
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth > 600;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isWideScreen ? 500 : double.infinity,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: size.height * 0.08),
                          _buildLogoWidget(size),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                SizedBox(height: size.height * 0.05),
                                _buildTextFormName(),
                                SizedBox(height: size.height * 0.02),
                                _buildTextFormEmail(),
                                SizedBox(height: size.height * 0.02),
                                _buildTextFormPhoneNo(),
                                SizedBox(height: size.height * 0.02),
                                _buildTextFormPassword(),
                                SizedBox(height: size.height * 0.07),
                                Column(
                                  children: [
                                    _buildEmailPasswordButton(
                                        state, context, size),
                                    SizedBox(height: size.height * 0.02),
                                    _buildGoogleSiginButton(size),
                                    SizedBox(height: size.height * 0.04),
                                    _createAccount(context),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLogoWidget(Size size) {
    return Center(
      child: Image(
        image: const AssetImage(zLogo),
        height: size.height * 0.2,
        width: size.height * 0.2,
      ),
    );
  }

  Widget _buildTextFormName() {
    return TextFormFieldWidget(
      label: zEnterName,
      controller: nameController,
      keyboardType: TextInputType.name,
    );
  }

  Widget _buildTextFormEmail() {
    return TextFormFieldWidget(
      label: zEnterEmail,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildTextFormPhoneNo() {
    return TextFormFieldWidget(
      label: zEnterPhoneNo,
      controller: phoneNoController,
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildTextFormPassword() {
    return TextFormFieldWidget(
      label: zEnterPassword,
      controller: passwordController,
      isPassword: true,
      keyboardType: TextInputType.visiblePassword,
    );
  }

  Widget _buildEmailPasswordButton(
    AuthState state,
    BuildContext context,
    Size size,
  ) {
    return BasicElevatedAppButton(
      onPressed: () {
        if (_formKey.currentState!.validate() && state is! AuthLoading) {
          final newUser = UserModel(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            fullName: nameController.text.trim(),
            phoneNo: phoneNoController.text.trim(),
          );
          context.read<AuthBloc>().add(SignUpEvent(user: newUser));
        }
      },
      title: zContinue,
      height: size.height * 0.07,
      isLoading: state is AuthLoading,
    );
  }

  Widget _buildGoogleSiginButton(Size size) {
    return BlocListener<GoogleAuthBloc, GoogleAuthState>(
      listener: (context, state) {
        if (state is GoogleAuthSuccess) {
          BasicSnackbar(
            message: state.message,
            backgroundColor: Colors.green,
          ).show(context);
          AppNavigator.pushReplacement(context, const MainScreens());
        } else if (state is GoogleAuthFailure) {
          BasicSnackbar(
            message: state.errorMessage,
            backgroundColor: Colors.red,
          ).show(context);
        }
      },
      child: BlocBuilder<GoogleAuthBloc, GoogleAuthState>(
        builder: (context, state) {
          return BasicOutlinedAppButton(
            image: zGoogleLogo,
            onPressed: () {
              if (state is! GoogleAuthLoading) {
                context.read<GoogleAuthBloc>().add(GoogleSignInRequested());
              }
            },
            title: zContinueWithGoogle,
            height: size.height * 0.07,
            isLoading: state is GoogleAuthLoading,
          );
        },
      ),
    );
  }

  Widget _createAccount(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Align(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: zDoYouHaveAccount,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: isWeb ? 13 : null,
                  ),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  AppNavigator.push(context, SigninScreen());
                },
              text: zSignIn,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isWeb ? 13 : 15,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
