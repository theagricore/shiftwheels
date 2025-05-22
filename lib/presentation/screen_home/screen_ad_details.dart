import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';
import 'package:shiftwheels/presentation/screen_my_ads/add_favourite_bloc/add_favourite_bloc.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class ScreenAdDetails extends StatelessWidget {
  final AdWithUserModel adWithUser;

  const ScreenAdDetails({super.key, required this.adWithUser});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return BlocProvider(
      create:
          (context) =>
              AddFavouriteBloc(sl<PostRepository>())
                ..add(LoadFavoritesEvent(currentUserId)),
      child: _AdDetailsContent(
        adWithUser: adWithUser,
        currentUserId: currentUserId,
      ),
    );
  }
}

class _AdDetailsContent extends StatelessWidget {
  final AdWithUserModel adWithUser;
  final String currentUserId;

  const _AdDetailsContent({
    required this.adWithUser,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ad = adWithUser.ad;

    return BlocConsumer<AddFavouriteBloc, AddFavouriteState>(
      listener: (context, state) {
        if (state is AddFavouriteError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        bool isFavorite = adWithUser.isFavorite;

        if (state is FavoritesLoaded) {
          isFavorite = state.favorites.any((fav) => fav.ad.id == ad.id);
        } else if (state is FavoriteToggled && state.adId == ad.id) {
          isFavorite = state.isNowFavorite;
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Listing Details')),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
                  child: Stack(
                    children: [
                      PageView.builder(
                        itemCount: ad.imageUrls.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            ad.imageUrls[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.zWhite,
                                child: const Center(
                                  child: Icon(Icons.image_not_supported),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            context.read<AddFavouriteBloc>().add(
                              ToggleFavoriteEvent(ad.id!, currentUserId),
                            );
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? AppColors.zred : AppColors.zblack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${ad.brand} ${ad.model}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\₹${ad.price.toStringAsFixed(2)}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: AppColors.zPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
