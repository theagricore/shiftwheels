import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/widget/ad_cards.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/common_widget/widget/filter_brand_icon.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/data/add_post/models/brand_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_brand_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_models_usecase.dart';
import 'package:shiftwheels/presentation/add_post/add_post_bloc/add_post_bloc.dart';
import 'package:shiftwheels/presentation/screen_home/get_post_ad_bloc/get_post_ad_bloc.dart';
import 'package:shiftwheels/presentation/screen_home/widget/home_screen_search_bar.dart';
import 'package:shiftwheels/presentation/screen_home/widget/premium_ads_carousel.dart';
import 'package:shiftwheels/presentation/screen_home/widget/simmer%20effect.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ScreenHome> {
 @override
    Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  AddPostBloc(sl<GetBrandUsecase>(), sl<GetModelsUsecase>())
                    ..add(FetchBrandsEvent()),
        ),
        BlocProvider(
          create: (context) => sl<GetPostAdBloc>()..add(const FetchActiveAds()),
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocConsumer<GetPostAdBloc, GetPostAdState>(
          listener: (context, state) {
            if (state is GetPostAdError) {
              BasicSnackbar(
                message: state.message,
                backgroundColor: AppColors.zred,
              ).show(context);
            }
          },
          builder: (context, state) {
            final List<AdWithUserModel> ads = (state is GetPostAdLoaded)
                ? state.ads
                : (state is GetPostAdLoading
                    ? (state.previousAds ?? <AdWithUserModel>[])
                    : <AdWithUserModel>[]);

            final List<AdWithUserModel> premiumAds = (state is GetPostAdLoaded)
                ? state.premiumAds
                : (state is GetPostAdLoading
                    ? (state.previousPremiumAds ?? <AdWithUserModel>[])
                    : <AdWithUserModel>[]);

            return RefreshIndicator(
              onRefresh: () async {
                context.read<GetPostAdBloc>().add(const RefreshActiveAds());
              },
              child: CustomScrollView(
                slivers: [
                  // App bar containing search bar and brand filter
                  SliverAppBar(
                    expandedHeight: 90.0,
                    floating: true,
                    pinned: true,
                    snap: true,
                    backgroundColor: AppColors.zPrimaryColor,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildSearchBar(context),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  // Brand filter Section
                  _buildBrandFilter(),
                  // Premium Ads Section
                  _buildPremiumAdsSection(context, state, premiumAds),
                  // Regular Ads Grid Section
                  _buildAdGrid(context, state, ads),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the search bar widget for the home screen.
  Widget _buildSearchBar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: HomeScreenSearchBar(),
    );
  }

  Widget _buildBrandFilter() {
    return SliverToBoxAdapter(
      child: BlocBuilder<AddPostBloc, AddPostState>(
        builder: (context, state) {
          if (state is BrandsLoading) {
            return const SizedBox(height: 50, child: BrandSectionShimmer());
          }
          if (state is BrandsError) {
            return const SizedBox.shrink();
          }
          final brands = state is BrandsLoaded ? state.brands : <BrandModel>[];
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: 40,
              padding: const EdgeInsets.only(left: 1, right: 1),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: brands.length,
                separatorBuilder: (_, __) => const SizedBox(width: 2),
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  return FilterBrandIcon(
                    brandName: brand.brandName!,
                    imageUrl: brand.image,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPremiumAdsSection(
    BuildContext context,
    GetPostAdState state,
    List<AdWithUserModel> premiumAds,
  ) {
    if (state is GetPostAdLoading && premiumAds.isEmpty) {
      return const SliverToBoxAdapter(child: PremiumAdsCarouselShimmer());
    } else if (premiumAds.isNotEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: PremiumAdsCarousel(premiumAds: premiumAds),
        ),
      );
    } else {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }

  Widget _buildAdGrid(
    BuildContext context,
    GetPostAdState state,
    List<AdWithUserModel> ads,
  ) {
    if (state is GetPostAdLoading && ads.isEmpty) {
      // Return the shimmer effect directly as a Sliver widget
      return const SimmerWidget();
    } else if (ads.isNotEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 0.7,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                AdCard(ad: ads[index], showFavoriteBadge: false),
            childCount: ads.length,
          ),
        ),
      );
    } else if (state is GetPostAdLoaded && ads.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sentiment_dissatisfied_outlined,
                  size: 80,
                  color: AppColors.zfontColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No listings available. Check back later!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.zfontColor.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }
}