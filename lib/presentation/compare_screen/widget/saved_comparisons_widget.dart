import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/data/add_post/models/comparison_model.dart';
import 'package:shiftwheels/presentation/compare_screen/compare_bloc/compare_bloc.dart';
import 'package:shiftwheels/presentation/compare_screen/widget/comparison_table.dart';

class SavedComparisonsWidget extends StatelessWidget {
  const SavedComparisonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    context.read<CompareBloc>().add(LoadSavedComparisons(userId));

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode ? AppColors.zDarkPrimaryText : AppColors.zLightPrimaryText;
    final subtitleColor =
        isDarkMode
            ? AppColors.zDarkSecondaryText
            : AppColors.zLightSecondaryText;
    final placeholderColor =
        isDarkMode ? AppColors.zDarkGrey : AppColors.zGrey.shade200;
    final cardColor =
        isDarkMode ? AppColors.zDarkCardBackground : AppColors.zWhite;
    final borderColor =
        isDarkMode ? AppColors.zDarkCardBorder : AppColors.zLightCardBorder;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<CompareBloc, CompareState>(
          listener: (context, state) {
            if (state is CompareError) {
              BasicSnackbar(
                message: state.message,
                backgroundColor: AppColors.zred,
              ).show(context);
            } else if (state is ComparisonDeleted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                BasicSnackbar(
                  message: state.message,
                  backgroundColor: AppColors.zGreen,
                ).show(context);
              });
            }
          },
          builder: (context, state) {
            if (state is CompareLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.zPrimaryColor,
                ),
              );
            } else if (state is CompareError) {
              return ComparisonErrorView(state: state);
            } else if (state is SavedComparisonsLoaded) {
              return ComparisonsListView(
                comparisons: state.comparisons,
                textColor: textColor,
                subtitleColor: subtitleColor,
                placeholderColor: placeholderColor,
                cardColor: cardColor,
                borderColor: borderColor,
              );
            } else if (state is ComparisonCarsLoaded) {
              return ComparisonDetailsView(cars: state.cars);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class ComparisonsListView extends StatelessWidget {
  final List<ComparisonModel> comparisons;
  final Color textColor;
  final Color subtitleColor;
  final Color placeholderColor;
  final Color cardColor;
  final Color borderColor;

  const ComparisonsListView({
    super.key,
    required this.comparisons,
    required this.textColor,
    required this.subtitleColor,
    required this.placeholderColor,
    required this.cardColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (comparisons.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.compare_arrows, color: subtitleColor, size: 60),
              const SizedBox(height: 16),
              Text(
                'No saved comparisons yet!\n\nSave comparisons to view them here.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: subtitleColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        context.read<CompareBloc>().add(LoadSavedComparisons(userId));
      },
      color: AppColors.zPrimaryColor,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: comparisons.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final comparison = comparisons[index];
          return ComparisonItemWidget(
            comparison: comparison,
            index: index,
            textColor: textColor,
            subtitleColor: subtitleColor,
            placeholderColor: placeholderColor,
            cardColor: cardColor,
            borderColor: borderColor,
          );
        },
      ),
    );
  }
}

class ComparisonItemWidget extends StatelessWidget {
  final ComparisonModel comparison;
  final int index;
  final Color textColor;
  final Color subtitleColor;
  final Color placeholderColor;
  final Color cardColor;
  final Color borderColor;

  const ComparisonItemWidget({
    super.key,
    required this.comparison,
    required this.index,
    required this.textColor,
    required this.subtitleColor,
    required this.placeholderColor,
    required this.cardColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(comparison.id ?? 'comparison_$index'),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.zred.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: AppColors.zred),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder:
              (context) =>
                  DeleteConfirmationDialog(comparisonId: comparison.id),
        );
      },
      onDismissed: (direction) {
        if (comparison.id != null) {
          context.read<CompareBloc>().add(DeleteComparison(comparison.id!));
        }
      },
      child: GestureDetector(
        onTap: () {
          context.read<CompareBloc>().add(
            LoadComparisonCars(comparison.carIds),
          );
        },
        onLongPress: () {
          if (comparison.id != null) {
            showDialog(
              context: context,
              builder:
                  (context) =>
                      DeleteConfirmationDialog(comparisonId: comparison.id),
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comparison #${index + 1}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatDate(comparison.createdAt),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: subtitleColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FutureBuilder<List<AdWithUserModel>>(
                  future: context
                      .read<CompareBloc>()
                      .getComparisonCarsUseCase
                      .call(param: comparison.carIds)
                      .then(
                        (either) => either.fold(
                          (error) => Future.error(error),
                          (cars) => cars,
                        ),
                      ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.zPrimaryColor,
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.length < 2) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Could not load car details',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: subtitleColor),
                        ),
                      );
                    }
                    final cars = snapshot.data!;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildCarPreview(
                            cars[0],
                            placeholderColor,
                            textColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'VS',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              color: AppColors.zPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _buildCarPreview(
                            cars[1],
                            placeholderColor,
                            textColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarPreview(
    AdWithUserModel car,
    Color placeholderColor,
    Color textColor,
  ) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: placeholderColor,
          ),
          child:
              car.ad.imageUrls.isNotEmpty
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: car.ad.imageUrls.first,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Center(
                            child: CircularProgressIndicator(
                              color: AppColors.zPrimaryColor,
                              strokeWidth: 2,
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Icon(
                            Icons.car_rental,
                            color: AppColors.zPrimaryColor,
                            size: 30,
                          ),
                    ),
                  )
                  : Icon(
                    Icons.car_rental,
                    color: AppColors.zPrimaryColor,
                    size: 30,
                  ),
        ),
        const SizedBox(height: 8),
        Text(
          car.ad.brand,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          car.ad.model,
          style: const TextStyle(fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${car.ad.year}',
          style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.7)),
        ),
      ],
    );
  }

String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy').format(date);
  }
}

class DeleteConfirmationDialog extends StatelessWidget {
  final String? comparisonId;

  const DeleteConfirmationDialog({super.key, this.comparisonId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Comparison'),
      content: const Text('Are you sure you want to delete this comparison?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            if (comparisonId != null) {
              context.read<CompareBloc>().add(DeleteComparison(comparisonId!));
            }
          },
          child: const Text('Delete', style: TextStyle(color: AppColors.zred)),
        ),
      ],
    );
  }
}

class ComparisonDetailsView extends StatelessWidget {
  final List<AdWithUserModel> cars;

  const ComparisonDetailsView({super.key, required this.cars});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode ? AppColors.zDarkPrimaryText : AppColors.zLightPrimaryText;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Comparison Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ComparisonTable(selectedCars: cars),
          const SizedBox(height: 30),
          _buildGeneratePdfButton(context, cars),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildGeneratePdfButton(
    BuildContext context,
    List<AdWithUserModel> cars,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ElevatedButton.icon(
        onPressed: () {
          context.read<CompareBloc>().add(GenerateAndSharePdf(cars));
        },
        icon: const Icon(
          Icons.picture_as_pdf,
          color: AppColors.zDarkPrimaryText,
        ),
        label: const Text(
          'Generate and Share PDF',
          style: TextStyle(color: AppColors.zDarkPrimaryText),
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
}

class ComparisonErrorView extends StatelessWidget {
  final CompareError state;

  const ComparisonErrorView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final errorTextColor = isDarkMode ? AppColors.zred : Colors.red;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: errorTextColor, size: 60),
            const SizedBox(height: 20),
            Text(
              state.message,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: errorTextColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
