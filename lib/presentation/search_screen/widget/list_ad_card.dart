import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/presentation/screen_home/screen_ad_details.dart';

class ListAdCard extends StatelessWidget {
  final AdWithUserModel ad;
  final bool isWeb;

  const ListAdCard({
    super.key, 
    required this.ad,
    this.isWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      color: isDarkMode
          ? AppColors.zDarkCardBackground
          : AppColors.zLightCardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScreenAdDetails(adWithUser: ad),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageBox(context, isDarkMode),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleSection(context, isDarkMode),
                    const SizedBox(height: 8),
                    isWeb ? SizedBox() : _buildPriceAndDetailsSection(context, isDarkMode)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageBox(BuildContext context, bool isDarkMode) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      width: isWeb ? 200 : 160,
      height: isWeb ? 120 : 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDarkMode
            ? colorScheme.surfaceVariant.withOpacity(0.2)
            : colorScheme.surfaceVariant,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ad.ad.imageUrls.isNotEmpty
            ? Image.network(
                ad.ad.imageUrls.first,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppColors.zPrimaryColor,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    _fallbackImage(colorScheme, isDarkMode),
              )
            : _fallbackImage(colorScheme, isDarkMode),
      ),
    );
  }

  Widget _fallbackImage(ColorScheme colorScheme, bool isDarkMode) {
    return Center(
      child: Icon(
        Icons.car_repair,
        size: 40,
        color: isDarkMode
            ? colorScheme.onSurfaceVariant.withOpacity(0.6)
            : colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context, bool isDarkMode) {
    final adData = ad.ad;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${adData.brand} ${adData.model}',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDarkMode
                ? AppColors.zDarkPrimaryText
                : AppColors.zLightPrimaryText,
            fontSize: isWeb ? 16 : null,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: isWeb ? 16 : 14,
              color: isDarkMode
                  ? AppColors.zDarkSecondaryText
                  : AppColors.zLightSecondaryText,
            ),
            const SizedBox(width: 4),
            Text(
              '${adData.year}',
              style: textTheme.bodySmall?.copyWith(
                color: isDarkMode
                    ? AppColors.zDarkSecondaryText
                    : AppColors.zLightSecondaryText,
                fontSize: isWeb ? 12 : null,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.speed,
              size: isWeb ? 16 : 14,
              color: isDarkMode
                  ? AppColors.zDarkSecondaryText
                  : AppColors.zLightSecondaryText,
            ),
            const SizedBox(width: 4),
            Text(
              '${adData.kmDriven} km',
              style: textTheme.bodySmall?.copyWith(
                color: isDarkMode
                    ? AppColors.zDarkSecondaryText
                    : AppColors.zLightSecondaryText,
                fontSize: isWeb ? 12 : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceAndDetailsSection(BuildContext context, bool isDarkMode) {
    final adData = ad.ad;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '₹${adData.price.toStringAsFixed(0)}',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.zPrimaryColor,
              fontWeight: FontWeight.w700,
              fontSize: isWeb ? 18 : null,
            ),
          ),
          Container(
            height: isWeb ? 36 : 32,
            width: isWeb ? 90 : 80,
            decoration: BoxDecoration(
              color: AppColors.zPrimaryColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppColors.zPrimaryColor.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "Details",
                style: textTheme.labelLarge?.copyWith(
                  color: AppColors.zblack,
                  fontWeight: FontWeight.w600,
                  fontSize: isWeb ? 14 : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}