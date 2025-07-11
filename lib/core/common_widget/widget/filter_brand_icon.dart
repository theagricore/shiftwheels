import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/screen_home/get_post_ad_bloc/get_post_ad_bloc.dart';

class FilterBrandIcon extends StatelessWidget {
  final String brandName;
  final String? imageUrl;

  const FilterBrandIcon({
    super.key,
    required this.brandName,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPostAdBloc, GetPostAdState>(
      builder: (context, state) {
        final isSelected = state is GetPostAdLoaded && state.selectedBrand == brandName;

        return SizedBox( // Reverted to SizedBox to control size directly
          child: Padding(
            padding: const EdgeInsets.only(right: 10), // Original padding
            child: GestureDetector(
              onTap: () {
                final getPostAdBloc = context.read<GetPostAdBloc>();
                if (isSelected) {
                  // If already selected, unselect it (show all ads)
                  getPostAdBloc.add(const FilterByBrandEvent('ALL')); // Use 'ALL' internally to signify no filter
                } else {
                  // If not selected, select it
                  getPostAdBloc.add(FilterByBrandEvent(brandName));
                }
              },
              child: Container(
                width: 70,
                height: 50, // Reverted height
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.zPrimaryColor : Colors.grey[100], // Reverted color pattern
                  borderRadius: BorderRadius.circular(10), // Reverted border radius
                  border: Border.all(color: AppColors.zfontColor.withOpacity(0.4)), // Reverted border
                  // Removed boxShadow as per request
                ),
                child: imageUrl != null
                    ? SizedBox( // Reverted to SizedBox for image container
                        width: 30, // Original image width
                        height: 30, // Original image height
                        child: Image.network(
                          imageUrl!,
                          errorBuilder: (context, error, stackTrace) => const Icon( // Reverted error icon and color
                            Icons.car_rental,
                            color: Colors.black,
                          ),
                          // Removed color tinting based on isSelected
                        ),
                      )
                    : const Icon( // Reverted generic icon and color
                        Icons.car_rental,
                        color: Colors.black,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}