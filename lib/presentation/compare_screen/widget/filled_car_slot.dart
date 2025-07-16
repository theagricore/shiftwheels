import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/presentation/compare_screen/compare_bloc/compare_bloc.dart';

class FilledCarSlot extends StatelessWidget {
  final AdWithUserModel car;
  final Color textColor;
  final Color subtitleColor;
  final Color placeholderColor;

  const FilledCarSlot({
    super.key,
    required this.car,
    required this.textColor,
    required this.subtitleColor,
    required this.placeholderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (car.ad.imageUrls.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: car.ad.imageUrls.first,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 120,
                color: placeholderColor,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.zPrimaryColor,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 120,
                color: placeholderColor,
                child: Center(
                  child: Icon(
                    Icons.broken_image,
                    color: subtitleColor,
                    size: 40,
                  ),
                ),
              ),
            ),
          )
        else
          Container(
            height: 120,
            width: double.infinity,
            color: placeholderColor,
            child: Center(
              child: Icon(
                Icons.no_photography,
                color: subtitleColor,
                size: 40,
              ),
            ),
          ),
        const SizedBox(height: 10),
        Text(
          '${car.ad.brand} ${car.ad.model}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '\$${car.ad.price.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.zGreen,
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          'Year: ${car.ad.year}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: subtitleColor),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(
              Icons.cancel,
              color: AppColors.zred,
              size: 24,
            ),
            onPressed: () {
              context.read<CompareBloc>().add(SelectCarForComparison(car, false));
            },
          ),
        ),
      ],
    );
  }
}