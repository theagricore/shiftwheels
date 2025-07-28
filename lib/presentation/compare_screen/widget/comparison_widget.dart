import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/compare_screen/compare_bloc/compare_bloc.dart';
import 'package:shiftwheels/presentation/compare_screen/widget/comparison_table.dart';
import 'package:shiftwheels/presentation/compare_screen/widget/favorites_bottom_sheet.dart';
import 'package:shiftwheels/presentation/compare_screen/widget/filled_car_slot.dart';

class ComparisonViewWidget extends StatelessWidget {
  final FavoritesLoadedForComparison state;

  const ComparisonViewWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode ? AppColors.zDarkPrimaryText : AppColors.zLightPrimaryText;

    return RefreshIndicator(
      onRefresh: () async {
        final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        context.read<CompareBloc>().add(LoadFavoritesForComparison(userId));
      },
      color: AppColors.zPrimaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Select two cars to compare',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCarSlot(context, 0),
                  _buildCarSlot(context, 1),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (state.selectedCars.length == 2) ...[
              ComparisonTable(selectedCars: state.selectedCars),
              const SizedBox(height: 30),
              _buildGeneratePdfButton(context),
              const SizedBox(height: 16),
              _buildSaveComparisonButton(context),
            ],
            if (state.favorites.isEmpty && state.selectedCars.isEmpty)
              _buildEmptyFavoritesMessage(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratePdfButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ElevatedButton.icon(
        onPressed: () {
          context.read<CompareBloc>().add(
                GenerateAndSharePdf(state.selectedCars),
              );
        },
        icon: const Icon(
          Icons.picture_as_pdf,
          color: AppColors.zDarkPrimaryText,
        ),
        label:  Text(
          'Share Comparison PDF',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.zPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }

  Widget _buildSaveComparisonButton(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ElevatedButton.icon(
        onPressed: () {
          context.read<CompareBloc>().add(
                SaveComparison(userId, state.selectedCars),
              );
        },
        icon: const Icon(
          Icons.save,
          color: AppColors.zDarkPrimaryText,
        ),
        label:  Text(
          'Save Comparison',
          style:  Theme.of(context).textTheme.labelMedium,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.zPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }

  Widget _buildEmptyFavoritesMessage(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final subtitleColor =
        isDarkMode
            ? AppColors.zDarkSecondaryText
            : AppColors.zLightSecondaryText;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text(
        'No favorite cars added yet. Add some cars to your favorites to compare them!',
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: subtitleColor),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCarSlot(BuildContext context, int slotIndex) {
    final isSlotFilled = slotIndex < state.selectedCars.length;
    final car = isSlotFilled ? state.selectedCars[slotIndex] : null;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? AppColors.zDarkCardBackground : AppColors.zWhite;
    final borderColor =
        isDarkMode ? AppColors.zDarkCardBorder : AppColors.zLightCardBorder;
    final textColor =
        isDarkMode ? AppColors.zDarkPrimaryText : AppColors.zLightPrimaryText;
    final subtitleColor =
        isDarkMode
            ? AppColors.zDarkSecondaryText
            : AppColors.zLightSecondaryText;
    final placeholderColor =
        isDarkMode ? AppColors.zDarkGrey : AppColors.zGrey.shade200;

    return GestureDetector(
      onTap: () {
        FavoritesBottomSheet.show(context, state, slotIndex);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.41,
        height: 266,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: isSlotFilled ? AppColors.zPrimaryColor : borderColor,
            width: isSlotFilled ? 2.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  isDarkMode
                      ? Colors.black.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child:
            isSlotFilled
                ? FilledCarSlot(
                    car: car!,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    placeholderColor: placeholderColor,
                  )
                : _buildEmptyCarSlot(context, subtitleColor),
      ),
    );
  }

  Widget _buildEmptyCarSlot(BuildContext context, Color subtitleColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.add_circle_outline, size: 50),
        const SizedBox(height: 12),
        Text(
          'Tap to select car',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: subtitleColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}