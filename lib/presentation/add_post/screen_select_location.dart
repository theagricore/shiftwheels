import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/widget/app_bottom_sheet.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/common_widget/widget/pop_up_screenWidget.dart';
import 'package:shiftwheels/core/common_widget/widget/select_location_widget.dart';
import 'package:shiftwheels/core/config/helper/navigator/app_navigator.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';
import 'package:shiftwheels/presentation/add_post/get_location_bloc/get_location_bloc.dart';
import 'package:shiftwheels/presentation/add_post/screen_select_image.dart';

// ignore: must_be_immutable
class ScreenSelectLocation extends StatelessWidget {
  final String userId;
  final String brand;
  final String model;
  final String fuelType;
  final int seatCount;
  final int year;
  final int kmDriven;
  final int noOfOwners;
  final String description;
  ScreenSelectLocation({
    super.key,
    required this.userId,
    required this.brand,
    required this.model,
    required this.fuelType,
    required this.seatCount,
    required this.year,
    required this.kmDriven,
    required this.noOfOwners,
    required this.description,
  });
  final TextEditingController _searchController = TextEditingController();
  LocationModel? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<GetLocationBloc, GetLocationState>(
      listener: (context, state) {
        if (state is GetLocationError) {
          if (state is! GetLocationSearchResults) {
            BasicSnackbar(message: state.message, backgroundColor: Colors.red);
          }
        } else if (state is GetLocationSuccess) {
          _selectedLocation = state.location;
        } else if (state is LocationSelectedState) {
          _selectedLocation = state.location;
        } else if (state is GetLocationSearchSelected) {
          _selectedLocation = state.location;
        }
      },
      builder: (context, state) {
        bool isLoading = state is GetLocationLoading;

        return Scaffold(
          appBar: BasicAppbar(
            title: Text(
              "Select Location",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildLocationWidget(context, size, isLoading),
                const SizedBox(height: 30),
                const Spacer(),
                if (_selectedLocation != null)
                  BasicElevatedAppButton(
                    onPressed: () {
                      AppNavigator.push(
                        context,
                        ScreenSelectImage(
                          userId: userId,
                          brand: brand,
                          model: model,
                          fuelType: fuelType,
                          seatCount: seatCount,
                          year: year,
                          kmDriven: kmDriven,
                          noOfOwners: noOfOwners,
                          description: description,
                          location: _selectedLocation!,
                        ),
                      );
                    },
                    title: "Continue",
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationWidget(BuildContext context, Size size, bool isLoading) {
    return SelectLocationWidget(
      getCurrentLocation: () {
        context.read<GetLocationBloc>().add(GetCurrentLocationEvent());
      },
      searchLocation: () {
        _buildSearchLocationWidget(context, size);
      },
      selectedLocation: _selectedLocation,
      isLoading: isLoading,
    );
  }

  void _buildSearchLocationWidget(BuildContext context, Size size) {
    AppBottomSheet.display(
      context,
      Padding(
        padding: const EdgeInsets.all(16),
        child: PopUpSearchScreenWidget(searchController: _searchController),
      ),
    );
  }
}
