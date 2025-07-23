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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color baseColor = isDark ? AppColors.zWhite : AppColors.zWhite;
    return BlocBuilder<GetPostAdBloc, GetPostAdState>(
      builder: (context, state) {
        final isSelected =
            state is GetPostAdLoaded && state.selectedBrand == brandName;

        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () {
              final getPostAdBloc = context.read<GetPostAdBloc>();
              if (isSelected) {
                getPostAdBloc.add(const FilterByBrandEvent('ALL'));
              } else {
                getPostAdBloc.add(FilterByBrandEvent(brandName));
              }
            },
            child: Container(
              width: 70,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.zPrimaryColor : baseColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.zfontColor.withOpacity(0.4)),
              ),
              child: imageUrl != null
                  ? SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.network(
                        imageUrl!,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.car_rental,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.car_rental,
                      color: Colors.black,
                    ),
            ),
          ),
        );
      },
    );
  }
}