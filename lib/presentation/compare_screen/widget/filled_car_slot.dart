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
  final bool isWeb;

  const FilledCarSlot({
    super.key,
    required this.car,
    required this.textColor,
    required this.subtitleColor,
    required this.placeholderColor,
    this.isWeb = false,
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
              height: isWeb ? 180 : 120,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: isWeb ? 180 : 120,
                color: placeholderColor,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.zPrimaryColor,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: isWeb ? 180 : 120,
                color: placeholderColor,
                child: Center(
                  child: Icon(
                    Icons.broken_image,
                    color: subtitleColor,
                    size: isWeb ? 50 : 40,
                  ),
                ),
              ),
            ),
          )
        else
          Container(
            height: isWeb ? 180 : 120,
            width: double.infinity,
            color: placeholderColor,
            child: Center(
              child: Icon(
                Icons.no_photography,
                color: subtitleColor,
                size: isWeb ? 50 : 40,
              ),
            ),
          ),
        SizedBox(height: isWeb ? 16 : 10),
        Text(
          '${car.ad.brand} ${car.ad.model}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
                fontSize: isWeb ? 18 : null,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '\$${car.ad.price.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.zGreen,
                fontWeight: FontWeight.w600,
                fontSize: isWeb ? 18 : null,
              ),
        ),
        Text(
          'Year: ${car.ad.year}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: subtitleColor,
                fontSize: isWeb ? 14 : null,
              ),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(
              Icons.cancel,
              color: AppColors.zred,
              size: isWeb ? 30 : 24,
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