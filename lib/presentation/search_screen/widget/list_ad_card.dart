import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/presentation/screen_home/screen_ad_details.dart';

class ListAdCard extends StatelessWidget {
  final AdWithUserModel ad;

  const ListAdCard({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.zfontColor.withOpacity(0.3)),
      ),
      elevation: 3,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScreenAdDetails(adWithUser: ad),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageBox(colorScheme),
            Expanded(child: _buildInfo(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildImageBox(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: SizedBox(
        width: 150,
        height: 90,
        child: ClipRRect(
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(12),
            right: Radius.circular(12),
          ),
          child:
              ad.ad.imageUrls.isNotEmpty
                  ? Image.network(
                    ad.ad.imageUrls.first,
                    fit: BoxFit.cover,
                    loadingBuilder:
                        (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    errorBuilder:
                        (context, error, stackTrace) =>
                            _fallbackImage(colorScheme),
                  )
                  : _fallbackImage(colorScheme),
        ),
      ),
    );
  }

  Widget _fallbackImage(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceVariant,
      child: Center(
        child: Icon(
          Icons.car_repair,
          size: 40,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    final adData = ad.ad;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${adData.brand} ${adData.model} (${adData.year})',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${adData.price.toStringAsFixed(2)}',
                      style: TextStyle(color: AppColors.zPrimaryColor),
                    ),
                    const SizedBox(height: 4),
                    Text('${adData.kmDriven} km',style: Theme.of(context).textTheme.labelSmall,),
                  ],
                ),
              ),
              Container(
                height: 30,
                width: 70,
                decoration: BoxDecoration(
                  color: AppColors.zPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Details",
                    style: TextStyle(
                      color: AppColors.zblack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
