import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/commonWidget/Widget/basic_snakbar.dart';
import 'package:shiftwheels/presentation/auth/AuthBloc/auth_bloc.dart';
import 'package:shiftwheels/presentation/auth/screens/signIn_screen.dart';

class ScreenMyAds extends StatelessWidget {
  const ScreenMyAds({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Ads"),
        actions: [
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                BasicSnackbar(message: state.message, backgroundColor: Colors.green).show(context);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SigninScreen()),
                );
              } else if (state is AuthFailure) {
                BasicSnackbar(message: state.errorMessage, backgroundColor: Colors.red).show(context);
              }
            },
            builder: (context, state) {
              return IconButton(
                onPressed: state is AuthLoading
                    ? null
                    : () {
                        context.read<AuthBloc>().add(LogoutEvent());
                      },
                icon: state is AuthLoading
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.logout),
                tooltip: 'Logout',
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("Home add ads"),
      ),
    );
  }
}
