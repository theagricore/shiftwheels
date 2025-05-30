import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';
import 'package:shiftwheels/presentation/screen_home/widget/auto_scroll_image_carousel.dart';
import 'package:shiftwheels/presentation/screen_home/widget/bottom_contact_bar_widget.dart';
import 'package:shiftwheels/presentation/screen_home/widget/over_view_grid.dart';
import 'package:shiftwheels/presentation/screen_home/widget/user_info_widget.dart';
import 'package:shiftwheels/presentation/screen_my_ads/add_favourite_bloc/add_favourite_bloc.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';
import 'package:timeago/timeago.dart' as timeago;

class ScreenAdDetails extends StatelessWidget {
  final AdWithUserModel adWithUser;

  const ScreenAdDetails({super.key, required this.adWithUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              AddFavouriteBloc(sl<PostRepository>())
                ..add(LoadFavoritesEvent(adWithUser.ad.userId)),
      child: _AdDetailsContent(
        adWithUser: adWithUser,
        currentUserId: adWithUser.ad.userId,
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
    final ad = adWithUser.ad;
    final userData = adWithUser.userData;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<AddFavouriteBloc, AddFavouriteState>(
      listener: (context, state) {
        if (state is AddFavouriteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
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
          backgroundColor: AppColors.zWhite,
          appBar: AppBar(
            title: const Text(
              'Listing Details',
              style: TextStyle(color: AppColors.zblack),
            ),
            centerTitle: true,
            backgroundColor: AppColors.zWhite,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoScrollImageCarousel(
                  imageUrls: ad.imageUrls,
                  isFavorite: isFavorite,
                  adId: ad.id!,
                  currentUserId: currentUserId,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              "${ad.brand} ${ad.model} (${ad.year})",
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.zblack,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16, color: AppColors.zblack),
                              const SizedBox(width: 4),
                              Text(
                                timeago.format(ad.postedDate),
                                style: textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.zblack,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "₹${ad.price}",
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.zPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  elevation: 8,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.zblack,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Overview",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.zWhite,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OverviewGrid(
                          transmission: ad.transmissionType,
                          kmDriven: ad.kmDriven,
                          noOfOwners: ad.noOfOwners,
                          fuelType: ad.fuelType,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: UserInfoWidget(userData: userData, ad: ad),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.zWhite,
                          ),
                        ),
                        Text(
                          ad.description,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.zWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomContactBarWidget(
            onChatPressed: () {},
            onCallPressed: () {},
          ),
        );
      },
    );
  }
}