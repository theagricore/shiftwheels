import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/commonWidget/Widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/commonWidget/Widget/basic_outlined_app_button.dart';
import 'package:shiftwheels/core/commonWidget/Widget/basic_snakbar.dart';
import 'package:shiftwheels/core/commonWidget/text_form_feald_widget.dart';
import 'package:shiftwheels/core/config/helper/navigator/app_navigator.dart';
import 'package:shiftwheels/core/config/theme/image_string.dart';
import 'package:shiftwheels/core/config/theme/text_string.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/presentation/MainScreen/main_screen.dart';
import 'package:shiftwheels/presentation/auth/AuthBloc/auth_bloc.dart';
import 'package:shiftwheels/presentation/auth/screens/signIn_screen.dart';

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
          return SingleChildScrollView(
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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.05),
                        TextFormFieldWidget(
                          label: zEnterName,
                          controller: nameController,
                          keyboardType: TextInputType.name,

                        ),
                        SizedBox(height: size.height * 0.02),
                        TextFormFieldWidget(
                          label: zEnterEmail,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
             
                        ),
                        SizedBox(height: size.height * 0.02),
                        TextFormFieldWidget(
                          label: zEnterPhoneNo,
                          controller: phoneNoController,
                          keyboardType: TextInputType.phone,
                         
                        ),
                        SizedBox(height: size.height * 0.02),
                        TextFormFieldWidget(
                          label: zEnterPassword,
                          controller: passwordController,
                          isPassword: true,
                          keyboardType: TextInputType.visiblePassword,
                
                        ),
                        SizedBox(height: size.height * 0.02),
                        SizedBox(height: size.height * 0.05),
                        Column(
                          children: [
                            BasicElevatedAppButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    !(state is AuthLoading)) {
                                  final newUser = UserModel(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    fullName: nameController.text.trim(),
                                    phoneNo: phoneNoController.text.trim(),
                                  );
                                  context.read<AuthBloc>().add(
                                        SignUpEvent(user: newUser),
                                      );
                                }
                              },
                              title: zContinue,
                              height: size.height * 0.07,
                              isLoading: state is AuthLoading,
                            ),
                            SizedBox(height: size.height * 0.02),
                            BasicOutlinedAppButton(
                              image: zGoogleLogo,
                              onPressed: () {
                                // Handle Google sign in
                              },
                              title: zContinueWithGoogle,
                              height: size.height * 0.07,
                            ),
                            SizedBox(height: size.height * 0.04),
                            Align(
                              alignment: Alignment.center,
                              child: _createAccount(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _createAccount(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: zDoYouHaveAccount,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        TextSpan(
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              AppNavigator.push(context, SigninScreen());
            },
          text: zSignIn,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ]),
    );
  }

}