import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/widget/app_bottom_sheet.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/common_widget/widget/pop_up_screenWidget.dart';
import 'package:shiftwheels/core/common_widget/widget/select_location_widget.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';
import 'package:shiftwheels/presentation/add_post/get_location_bloc/get_location_bloc.dart';

// ignore: must_be_immutable
class ScreenSelectLocation extends StatelessWidget {
  ScreenSelectLocation({super.key});
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
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
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
                 _buildContinueButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return BasicElevatedAppButton(
      onPressed: () {
        Navigator.pop(context, _selectedLocation);
      },
      title: "Continue",
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
