import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';

class SelectLocationWidget extends StatelessWidget {
  const SelectLocationWidget({
    super.key,
    required this.getCurrentLocation,
    required this.searchLocation,
    this.selectedLocation,
    this.isLoading = false,
  });

  final VoidCallback getCurrentLocation;
  final VoidCallback searchLocation;
  final LocationModel? selectedLocation;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: isLoading ? null : getCurrentLocation,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.zfontColor, width: 2.0),
            ),
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.all(12),
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Center(
                      child: Text(
                        "Current location",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
          ),
        ),
        const SizedBox(height: 30),
        InkWell(
          onTap: isLoading ? null : searchLocation,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.zfontColor, width: 2.0),
            ),
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                "Search for a location",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (selectedLocation != null) _showLocationWidget(context),
      ],
    );
  }

  Widget _showLocationWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_on_outlined,color: AppColors.zfontColor,),
        Text(
          selectedLocation?.address ?? 'No address',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(width: 5),
        Text(
          "Lat: ${selectedLocation?.latitude.toStringAsFixed(4) ?? 'N/A'}, "
          "Lng: ${selectedLocation?.longitude.toStringAsFixed(4) ?? 'N/A'}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
