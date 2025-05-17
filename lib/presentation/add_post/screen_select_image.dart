import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
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
  final int seatCount;
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
    required this.seatCount,
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
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        body: Padding(
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
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
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.zPrimaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            AppNavigator.push(
                              context,
                              ScreenPrice(
                                userId: userId,
                                brand: brand,
                                model: model,
                                fuelType: fuelType,
                                seatCount: seatCount,
                                year: year,
                                kmDriven: kmDriven,
                                noOfOwners: noOfOwners,
                                description: description,
                                location: location,
                                imagePaths: imagePaths,
                              ),
                            );
                          },
                          child: Text(
                            'Continue',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
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
          child: Icon(Icons.add, size: 40, color: AppColors.zPrimaryColor),
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
          size: 30,
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
          child: Image.file(
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
              child: const Icon(
                Icons.close,
                color: AppColors.zfontColor,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}