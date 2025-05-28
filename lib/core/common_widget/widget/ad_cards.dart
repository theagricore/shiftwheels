import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/presentation/screen_home/screen_ad_details.dart';

class AdCard extends StatelessWidget {
  final AdWithUserModel ad;
  final bool showFavoriteBadge;

  const AdCard({super.key, required this.ad, this.showFavoriteBadge = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.zfontColor.withOpacity(0.4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScreenAdDetails(adWithUser: ad),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Expanded(flex: 4, child: _buildImageBox(context, colorScheme)),
            // Info section
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _buildInfo(context, colorScheme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageBox(BuildContext context, ColorScheme colorScheme) {
    return Stack(
      children: [
        // Main image
        ad.ad.imageUrls.isNotEmpty
            ? Hero(
              tag: 'ad-image-${ad.ad.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  ad.ad.imageUrls[0],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return _fallbackImage(colorScheme);
                  },
                ),
              ),
            )
            : _fallbackImage(colorScheme),

        // Favorite badge
        if (showFavoriteBadge)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.zPrimaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.favorite, size: 20, color: AppColors.zred),
            ),
          ),
      ],
    );
  }

  Widget _fallbackImage(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceVariant,
      child: Center(
        child: Icon(
          Icons.car_repair,
          size: 48,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title and price row
        Row(
          children: [
            Row(
              children: [
                Text(
                  '${ad.ad.brand} ${ad.ad.model}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 3),
                Text(
                  '${ad.ad.year}',
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
        // Details row
        Row(
          children: [
            Icon(
              Icons.currency_rupee,
              size: 16,
              color: AppColors.zPrimaryColor.withOpacity(0.8),
            ),
            Text(
              ad.ad.price.toStringAsFixed(2),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.speed,
              size: 16,
              color: AppColors.zPrimaryColor.withOpacity(0.8),
            ),
            const SizedBox(width: 4),
            Text(
              '${ad.ad.kmDriven} km',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: 12),
          ],
        ),
      ],
    );
  }
}
