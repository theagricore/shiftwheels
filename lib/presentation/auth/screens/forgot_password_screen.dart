import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/commonWidget/Widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/commonWidget/Widget/basic_snakbar.dart';
import 'package:shiftwheels/core/commonWidget/basic_app_bar.dart';
import 'package:shiftwheels/core/commonWidget/text_form_feald_widget.dart';
import 'package:shiftwheels/core/config/theme/image_string.dart';
import 'package:shiftwheels/core/config/theme/text_string.dart';
import 'package:shiftwheels/presentation/auth/AuthBloc/auth_bloc.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const BasicAppbar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordResetState) {
            emailController.clear();
             BasicSnackbar(
              message: state.message,
              backgroundColor: Colors.green,
            ).show(context);
            Navigator.pop(context); 
          } else if (state is AuthFailure) {
            BasicSnackbar(
              message: state.errorMessage,
              backgroundColor: Colors.red,
            ).show(context);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Center(
                            child: Image(
                              image: const AssetImage(zLogo),
                              height: size.height * 0.2,
                              width: size.height * 0.2,
                            ),
                          ),
                          Text(
                            zForgetPassord,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          SizedBox(height: size.height * 0.04),
                          TextFormFieldWidget(
                            label: zEnterEmail,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: size.height * 0.04),
                          BasicElevatedAppButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  ForgotPasswordEvent(
                                    email: emailController.text.trim(),
                                  ),
                                );
                              }
                            },
                            title: zContinue,
                            height: size.height * 0.07,
                            isLoading: state is AuthLoading,
                          ),
                          SizedBox(height: size.height * 0.02),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
