import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/compare_screen/compare_bloc/compare_bloc.dart';

class FavoritesBottomSheet extends StatelessWidget {
  final FavoritesLoadedForComparison state;
  final int slotIndex;

  const FavoritesBottomSheet({
    super.key,
    required this.state,
    required this.slotIndex,
  });

  static void show(BuildContext context, FavoritesLoadedForComparison state, int slotIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: context.read<CompareBloc>(),
          child: FavoritesBottomSheet(
            state: state,
            slotIndex: slotIndex,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? AppColors.zDarkCardBackground : AppColors.zWhite;
    final textColor = isDarkMode ? AppColors.zDarkPrimaryText : AppColors.zLightPrimaryText;
    final subtitleColor = isDarkMode ? AppColors.zDarkSecondaryText : AppColors.zLightSecondaryText;
    final placeholderColor = isDarkMode ? AppColors.zDarkGrey : AppColors.zGrey.shade200;
    final selectedCarHighlightColor = AppColors.zPrimaryColor.withOpacity(0.1);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    color: AppColors.zGrey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                'Select a Car',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
              ),
              Expanded(
                child: state.favorites.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.directions_car_filled_outlined,
                                size: 60,
                                color: subtitleColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No favorite cars available to select for comparison.',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: subtitleColor),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: state.favorites.length,
                        separatorBuilder: (context, index) => Divider(
                          color: isDarkMode ? AppColors.zDarkDivider : AppColors.zLightDivider,
                          indent: 16,
                          endIndent: 16,
                          thickness: 0,
                        ),
                        itemBuilder: (_, index) {
                          final car = state.favorites[index];
                          final isSelected = state.selectedCars.contains(car);
                          final isDisabled = isSelected;

                          return Container(
                            decoration: BoxDecoration(
                              color: isSelected ? selectedCarHighlightColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              leading: car.ad.imageUrls.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: car.ad.imageUrls.first,
                                        width: 65,
                                        height: 65,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          width: 65,
                                          height: 65,
                                          color: placeholderColor,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.zPrimaryColor,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          width: 65,
                                          height: 65,
                                          color: placeholderColor,
                                          child: Center(
                                            child: Icon(
                                              Icons.broken_image,
                                              color: subtitleColor,
                                              size: 35,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 65,
                                      height: 65,
                                      color: placeholderColor,
                                      child: Center(
                                        child: Icon(
                                          Icons.no_photography,
                                          color: subtitleColor,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                              title: Text(
                                '${car.ad.brand} ${car.ad.model}',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: isDisabled ? subtitleColor : textColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              subtitle: Text(
                                '\$${car.ad.price.toStringAsFixed(2)} • ${car.ad.year}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: isDisabled ? subtitleColor.withOpacity(0.7) : subtitleColor,
                                    ),
                              ),
                              trailing: isDisabled
                                  ? Icon(
                                      Icons.check_circle_outline,
                                      color: AppColors.zGreen,
                                      size: 28,
                                    )
                                  : Icon(
                                      Icons.radio_button_unchecked,
                                      color: subtitleColor,
                                      size: 28,
                                    ),
                              onTap: isDisabled
                                  ? null
                                  : () {
                                      context.read<CompareBloc>().add(
                                            SelectCarForComparison(car, true),
                                          );
                                      Navigator.pop(context);
                                    },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}