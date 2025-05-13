import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/presentation/add_post/get_location_bloc/get_location_bloc.dart';

class ScreenSelectLocation extends StatelessWidget {
  const ScreenSelectLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetLocationBloc, GetLocationState>(
      listener: (context, state) {
        if (state is GetLocationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: BasicAppbar(
            title: Text(
              "Select the Location",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  if (state is GetLocationSuccess)
                    Text(
                      'Latitude: ${state.location.latitude}\nLongitude: ${state.location.longitude}',
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 20),
                  BasicElevatedAppButton(
                    onPressed: () {
                      context.read<GetLocationBloc>().add(GetCurrentLocationEvent());
                    },
                    title: "Current Location",
                    isLoading: state is GetLocationLoading,
                  ),
                  const Spacer(),
                  BasicElevatedAppButton(
                    onPressed: () {
                    }, 
                    title: "Continue",
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}