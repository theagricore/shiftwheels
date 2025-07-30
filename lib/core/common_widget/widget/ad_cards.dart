import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';
import 'package:shiftwheels/presentation/screen_home/screen_ad_details.dart';
import 'package:shiftwheels/presentation/screen_my_ads/add_favourite_bloc/add_favourite_bloc.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class AdCard extends StatelessWidget {
  final AdWithUserModel ad;
  final bool showFavoriteBadge;

  const AdCard({super.key, required this.ad, this.showFavoriteBadge = false});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 600;
        final cardPadding = isWeb ? 16.0 : 12.0;
        final priceFontSize = isWeb ? 13.0 : 12.0;
        final iconSize = isWeb ? 18.0 : 16.0;
        final titleFontSize = isWeb ? 14.0 : 16.0;
        final yearFontSize = isWeb ? 12.0 : 14.0;

        return BlocProvider(
          create: (context) => AddFavouriteBloc(sl<PostRepository>()),
          child: BlocConsumer<AddFavouriteBloc, AddFavouriteState>(
            listener: (context, state) {
              if (state is AddFavouriteError) {
                _showSnackBar(context, state.message, Colors.red);
              } else if (state is FavoriteToggled) {
                _showSnackBar(
                  context,
                  state.isNowFavorite ? 'Added to favorites' : 'Removed from favorites',
                  Colors.green,
                );
              }
            },
            builder: (context, state) {
              final isFavorite = _getFavoriteStatus(state, ad.ad.id!);

              return Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: colorScheme.outline.withOpacity(0.4)),
                ),
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _navigateToAdDetails(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: _buildImageBox(context, colorScheme, isFavorite, currentUserId),
                      ),
                      Padding(
                        padding: EdgeInsets.all(cardPadding),
                        child: _buildInfo(context, theme.textTheme, colorScheme, priceFontSize, iconSize, titleFontSize, yearFontSize),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  bool _getFavoriteStatus(AddFavouriteState state, String adId) {
    if (state is FavoritesLoaded) {
      return state.favorites.any((fav) => fav.ad.id == adId);
    } else if (state is FavoriteToggled && state.adId == adId) {
      return state.isNowFavorite;
    }
    return ad.isFavorite;
  }

  void _navigateToAdDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScreenAdDetails(adWithUser: ad)),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildImageBox(
    BuildContext context,
    ColorScheme colorScheme,
    bool isFavorite,
    String currentUserId,
  ) {
    return Stack(
      children: [
        ad.ad.imageUrls.isNotEmpty
            ? Hero(
                tag: 'ad-image-${ad.ad.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: ad.ad.imageUrls[0],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: colorScheme.surfaceVariant,
                      highlightColor: colorScheme.onSurfaceVariant.withOpacity(0.3),
                      child: Container(color: colorScheme.surfaceVariant),
                    ),
                    errorWidget: (context, url, error) => _buildFallbackImage(colorScheme),
                  ),
                ),
              )
            : _buildFallbackImage(colorScheme),
        if (showFavoriteBadge)
          Positioned(
            top: 8,
            right: 8,
            child: _buildFavoriteButton(context, isFavorite, currentUserId),
          ),
      ],
    );
  }

  Widget _buildFavoriteButton(
    BuildContext context,
    bool isFavorite,
    String currentUserId,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.zPrimaryColor.withOpacity(0.7),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            context.read<AddFavouriteBloc>().add(
              ToggleFavoriteEvent(ad.ad.id!, currentUserId),
            );
          },
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.favorite_border,
              size: 22,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackImage(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceVariant,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 48,
          color: colorScheme.onSurfaceVariant.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildInfo(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    double priceFontSize,
    double iconSize,
    double titleFontSize,
    double yearFontSize,
  ) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${ad.ad.brand} ${ad.ad.model}',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
            color: colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '${ad.ad.year}',
          style: textTheme.bodyMedium?.copyWith(
            fontSize: yearFontSize,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoChip(
              icon: Icons.currency_rupee,
              text: currencyFormat.format(ad.ad.price),
              color: AppColors.zPrimaryColor,
              context: context,
              fontSize: priceFontSize,
              iconSize: iconSize,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
    required BuildContext context,
    required double fontSize,
    required double iconSize,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                ),
          ),
        ],
      ),
    );
  }
}
