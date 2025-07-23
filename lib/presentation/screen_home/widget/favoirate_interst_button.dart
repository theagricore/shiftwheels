import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/screen_my_ads/add_favourite_bloc/add_favourite_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/interest_bloc/interest_bloc.dart';

class FavoirateInterstButton extends StatelessWidget {
  const FavoirateInterstButton({
    super.key,
    required this.adId,
    required this.currentUserId,
  });

  final String adId;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.zDarkBackground,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 8),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Interest button
            BlocBuilder<InterestBloc, InterestState>(
              builder: (context, interestState) {
                bool isInterested = false;

                if (interestState is InitialInterestLoaded &&
                    interestState.adId == adId) {
                  isInterested = interestState.isInterested;
                } else if (interestState is InterestToggled &&
                    interestState.adId == adId) {
                  isInterested = interestState.isNowInterested;
                }

                return BlocListener<InterestBloc, InterestState>(
                  listener: (context, state) {
                    if (state is InterestError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  child: GestureDetector(
                    onTap: () {
                      context.read<InterestBloc>().add(
                        ToggleInterestEvent(adId, currentUserId, isInterested),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isInterested
                                ? AppColors.zBlue.withOpacity(0.2)
                                : AppColors.zWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isInterested
                                ? Icons.handshake
                                : Icons.handshake_outlined,
                            color:
                                isInterested
                                    ? AppColors.zBlue
                                    : AppColors.zWhite,
                            size: 22,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isInterested ? 'Interested' : 'Interested',
                            style: TextStyle(
                              color:
                                  isInterested
                                      ? AppColors.zBlue
                                      : AppColors.zWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            // Favorite button
            BlocBuilder<AddFavouriteBloc, AddFavouriteState>(
              builder: (context, favoriteState) {
                bool isFavorite = false;

                if (favoriteState is FavoritesLoaded) {
                  isFavorite = favoriteState.favorites.any(
                    (fav) => fav.ad.id == adId,
                  );
                } else if (favoriteState is FavoriteToggled &&
                    favoriteState.adId == adId) {
                  isFavorite = favoriteState.isNowFavorite;
                }

                return BlocListener<AddFavouriteBloc, AddFavouriteState>(
                  listener: (context, state) {
                    if (state is AddFavouriteError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  child: GestureDetector(
                    onTap: () {
                      context.read<AddFavouriteBloc>().add(
                        ToggleFavoriteEvent(adId, currentUserId),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isFavorite
                                ? AppColors.zred.withOpacity(0.2)
                                : AppColors.zWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color:
                                isFavorite ? AppColors.zred : AppColors.zWhite,
                            size: 22,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isFavorite ? 'Favorited' : 'Favorite',
                            style: TextStyle(
                              color:
                                  isFavorite
                                      ? AppColors.zred
                                      : AppColors.zWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
