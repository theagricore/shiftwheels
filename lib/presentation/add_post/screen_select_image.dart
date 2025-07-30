import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/config/helper/navigator/app_navigator.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';
import 'package:shiftwheels/presentation/add_post/get_images_bloc/get_images_bloc.dart';
import 'package:shiftwheels/presentation/add_post/screen_price.dart';

class ScreenSelectImage extends StatelessWidget {
  final String userId;
  final String brand;
  final String model;
  final String fuelType;
  final String transmissionType;
  final int year;
  final int kmDriven;
  final int noOfOwners;
  final String description;
  final LocationModel location;

  const ScreenSelectImage({
    super.key,
    required this.userId,
    required this.brand,
    required this.model,
    required this.fuelType,
    required this.transmissionType,
    required this.year,
    required this.kmDriven,
    required this.noOfOwners,
    required this.description,
    required this.location,
  });

  static const int gridSlots = 9;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetImagesBloc(),
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            "Select Images",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: kIsWeb ? 20 : 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWeb = kIsWeb;
            final crossAxisCount = isWeb ? 5 : 3;
            final spacing = isWeb ? 16.0 : 12.0;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<GetImagesBloc, GetImagesState>(
                builder: (context, state) {
                  final imagePaths =
                      state is ImagesSelectedState ? state.imagePaths : <String>[];
                  final hasImages = imagePaths.isNotEmpty;
                  final totalItems = imagePaths.length + 1;
                  final isScrollable = totalItems > gridSlots;

                  return Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: isScrollable
                              ? const AlwaysScrollableScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: spacing,
                            mainAxisSpacing: spacing,
                            childAspectRatio: 1,
                          ),
                          itemCount: isScrollable ? totalItems : gridSlots,
                          itemBuilder: (context, index) {
                            final addButtonIndex = imagePaths.length;

                            if (index < imagePaths.length) {
                              return _buildImageItem(
                                context,
                                imagePaths[index],
                                index,
                              );
                            }

                            if (index == addButtonIndex && imagePaths.length < 100) {
                              return _buildAddButton(context);
                            }

                            return _buildEmptySlot(context);
                          },
                        ),
                      ),
                      if (hasImages)
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: SizedBox(
                            width: double.infinity,
                            child: BasicElevatedAppButton(
                              onPressed: () {
                                AppNavigator.push(
                                  context,
                                  ScreenPrice(
                                    userId: userId,
                                    brand: brand,
                                    model: model,
                                    fuelType: fuelType,
                                    transmissionType: transmissionType,
                                    year: year,
                                    kmDriven: kmDriven,
                                    noOfOwners: noOfOwners,
                                    description: description,
                                    location: location,
                                    imagePaths: imagePaths,
                                  ),
                                );
                              },
                              title: "Continue",
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<GetImagesBloc>().add(PickImageEvent()),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.zPrimaryColor, width: 2),
        ),
        child: Center(
          child: Icon(Icons.add, size: kIsWeb ? 30 : 40, color: AppColors.zPrimaryColor),
        ),
      ),
    );
  }

  Widget _buildEmptySlot(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.zfontColor, width: 1),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: kIsWeb ? 24 : 30,
          color: AppColors.zfontColor,
        ),
      ),
    );
  }

  Widget _buildImageItem(BuildContext context, String imagePath, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: kIsWeb
              ? Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              : Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: () =>
                context.read<GetImagesBloc>().add(RemoveImageEvent(index)),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.zblack,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: AppColors.zfontColor,
                size: kIsWeb ? 12 : 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}