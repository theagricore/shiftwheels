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
    this.isWeb = false,
  });

  final VoidCallback getCurrentLocation;
  final VoidCallback searchLocation;
  final LocationModel? selectedLocation;
  final bool isLoading;
  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: isLoading ? null : getCurrentLocation,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isWeb ? 12 : 15),
              border: Border.all(
                color: AppColors.zfontColor, 
                width: isWeb ? 1.5 : 2.0,
              ),
            ),
            width: double.infinity,
            height: isWeb ? 50 : 60,
            padding: EdgeInsets.all(isWeb ? 10 : 12),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: Text(
                      "Current location",
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: isWeb ? 15 : null,
                      ),
                    ),
                  ),
          ),
        ),
        SizedBox(height: isWeb ? 20 : 30),
        InkWell(
          onTap: isLoading ? null : searchLocation,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isWeb ? 12 : 15),
              border: Border.all(
                color: AppColors.zfontColor, 
                width: isWeb ? 1.5 : 2.0,
              ),
            ),
            width: double.infinity,
            height: isWeb ? 50 : 60,
            padding: EdgeInsets.all(isWeb ? 10 : 12),
            child: Center(
              child: Text(
                "Search for a location",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: isWeb ? 15 : null,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: isWeb ? 8 : 10),
        if (selectedLocation != null) _showLocationWidget(context, isWeb),
      ],
    );
  }

  Widget _showLocationWidget(BuildContext context, bool isWeb) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_on_outlined,
          color: AppColors.zfontColor,
          size: isWeb ? 18 : null,
        ),
        const SizedBox(width: 4),
        Text(
          selectedLocation?.address ?? 'No address',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: isWeb ? 12 : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          "Lat: ${selectedLocation?.latitude.toStringAsFixed(4) ?? 'N/A'}, "
          "Lng: ${selectedLocation?.longitude.toStringAsFixed(4) ?? 'N/A'}",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: isWeb ? 12 : null,
          ),
        ),
      ],
    );
  }
}