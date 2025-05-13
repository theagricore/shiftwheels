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
import 'package:shiftwheels/data/auth/models/user_sigin_model.dart';
import 'package:shiftwheels/presentation/auth/auth_bloc/auth_bloc.dart';
import 'package:shiftwheels/presentation/auth/google_auth/google_auth_bloc.dart';
import 'package:shiftwheels/presentation/auth/screens/forgot_password_screen.dart';
import 'package:shiftwheels/presentation/auth/screens/siginup_screen.dart';
import 'package:shiftwheels/presentation/main_screen/main_screen.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen:
            (previous, current) =>
                current is AuthSuccess || current is AuthFailure,
        listener: (context, state) {
          if (state is AuthSuccess) {
            BasicSnackbar(
              message: state.message,
              backgroundColor: Colors.green,
            ).show(context);
            emailController.clear();
            passwordController.clear();
            AppNavigator.pushReplacement(context, const MainScreens());
          } else if (state is AuthFailure) {
            BasicSnackbar(
              message: state.errorMessage,
              backgroundColor: Colors.red,
            ).show(context);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: size.height * 0.08),
                Center(
                  child: Image(
                    image: const AssetImage(zLogo),
                    height: size.height * 0.2,
                    width: size.height * 0.2,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildEmailWidget(),
                      SizedBox(height: size.height * 0.03),
                      _buildPasswordWidget(),
                      SizedBox(height: size.height * 0.02),
                      _forgotPassword(context),
                      SizedBox(height: size.height * 0.05),
                      Column(
                        children: [
                          _buildEmailPasswordSigninWidget(size),
                          SizedBox(height: size.height * 0.02),
                          _buildGoogleSigininWidget(size),
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
  }

  Widget _buildGoogleSigininWidget(Size size) {
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

  Widget _buildEmailPasswordSigninWidget(Size size) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return BasicElevatedAppButton(
          onPressed: () {
            if (_formKey.currentState!.validate() && state is! AuthLoading) {
              final email = emailController.text.trim();
              final password = passwordController.text.trim();
              final user = UserSiginModel(email: email, password: password);
              context.read<AuthBloc>().add(SignInEvent(userSiginModel: user));
            }
          },
          title: zContinue,
          height: size.height * 0.07,
          isLoading: state is AuthLoading,
        );
      },
    );
  }

  Widget _buildPasswordWidget() {
    return TextFormFieldWidget(
      label: zEnterPassword,
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      isPassword: true,
    );
  }

  Widget _buildEmailWidget() {
    return TextFormFieldWidget(
      label: zEnterEmail,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _createAccount(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: zDontHaveAnAccount,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            TextSpan(
              recognizer:
                  TapGestureRecognizer()
                    ..onTap = () {
                      AppNavigator.pushReplacement(context, SiginupScreen());
                    },
              text: zCreateOne,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _forgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: RichText(
        text: TextSpan(
          recognizer:
              TapGestureRecognizer()
                ..onTap = () {
                  AppNavigator.push(context, ForgotPasswordPage());
                },
          text: zForgetPassord,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
