import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/text_form_feald_widget.dart';
import 'package:shiftwheels/core/config/theme/image_string.dart';
import 'package:shiftwheels/core/config/theme/text_string.dart';
import 'package:shiftwheels/presentation/auth/auth_bloc/auth_bloc.dart';

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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  SizedBox(height: size.height * 0.04),
                                  _buildLogo(size),
                                  SizedBox(height: size.height * 0.03),
                                  _buildForgotPasswordText(context),
                                  SizedBox(height: size.height * 0.04),
                                  _buildEmailWidget(),
                                  SizedBox(height: size.height * 0.04),
                                  _buildContinueButton(context, size, state),
                                  SizedBox(height: size.height * 0.02),
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
      ),
    );
  }

  Widget _buildForgotPasswordText(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        zForgetPassord,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: isWeb ? 22 : null,
            ),
      ),
    );
  }

  Widget _buildLogo(Size size) {
    return Center(
      child: Image(
        image: const AssetImage(zLogo),
        height: size.height * 0.2,
        width: size.height * 0.2,
      ),
    );
  }

  Widget _buildContinueButton(
      BuildContext context, Size size, AuthState state) {
    return BasicElevatedAppButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          context.read<AuthBloc>().add(
                ForgotPasswordEvent(email: emailController.text.trim()),
              );
        }
      },
      title: zContinue,
      height: size.height * 0.07,
      isLoading: state is AuthLoading,
    );
  }

  Widget _buildEmailWidget() {
    return TextFormFieldWidget(
      label: zEnterEmail,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
    );
  }
}
