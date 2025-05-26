import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/add_post/get_images_bloc/get_images_bloc.dart';

class EditImageWidget extends StatelessWidget {
  const EditImageWidget({
    super.key,
    required this.imagePaths,
  });

  final List<String> imagePaths;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Images",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imagePaths.length + 1,
            itemBuilder: (context, index) {
              if (index < imagePaths.length) {
                return _buildImageItem(context, index);
              } else {
                return _buildAddImageButton(context);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageItem(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        children: [
          Image.network(
            imagePaths[index],
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                context.read<GetImagesBloc>().add(RemoveImageEvent(index));
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<GetImagesBloc>().add(PickImageEvent());
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.zPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 30,
            color: AppColors.zPrimaryColor,
          ),
        ),
      ),
    );
  }
}
