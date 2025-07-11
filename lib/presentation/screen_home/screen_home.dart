import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shiftwheels/presentation/screen_home/widget/simmer%20effect.dart';
import 'package:shiftwheels/presentation/search_screen/search_bloc/search_bloc.dart';
import 'package:shiftwheels/presentation/search_screen/search_screen.dart';
import 'package:shiftwheels/core/common_widget/widget/ad_cards.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/common_widget/widget/filter_brand_icon.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/brand_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_brand_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_models_usecase.dart';
import 'package:shiftwheels/presentation/add_post/add_post_bloc/add_post_bloc.dart';
import 'package:shiftwheels/presentation/screen_home/get_post_ad_bloc/get_post_ad_bloc.dart';
import 'package:shiftwheels/presentation/screen_home/widget/premium_ads_carousel.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AddPostBloc(sl<GetBrandUsecase>(), sl<GetModelsUsecase>())
                ..add(FetchBrandsEvent()),
        ),
        BlocProvider(
          create: (context) => sl<GetPostAdBloc>()..add(const FetchActiveAds()),
        ),
        BlocProvider(create: (context) => SearchBloc()),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: BlocProvider.of<SearchBloc>(context),
                      child: const SearchScreen(),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: AppColors.zPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Lottie.asset(
                      'assets/images/Animation - search-w1000-h1000.json',
                      height: 40,
                      width: 40,
                      fit: BoxFit.contain,
                      repeat: false,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Search for cars...',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: AppColors.zfontColor.withOpacity(0.7),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          toolbarHeight: 70,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AddPostBloc, AddPostState>(
                builder: (context, state) {
                  if (state is BrandsLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            'Explore Brands',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        _buildBrandFilter(),
                      ],
                    );
                  } else {
                    return _buildBrandSectionShimmer(context);
                  }
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocConsumer<GetPostAdBloc, GetPostAdState>(
                  listener: (context, state) {
                    if (state is GetPostAdError) {
                      BasicSnackbar(
                        message: state.message,
                        backgroundColor: AppColors.zred,
                      ).show(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is GetPostAdInitial ||
                        (state is GetPostAdLoading &&
                            state.previousAds == null)) {
                      return _buildAdListShimmer(context);
                    }

                    if (state is GetPostAdError) {
                      return Center(
                        child: Text(
                          'Failed to load listings. Please try again.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppColors.zred),
                        ),
                      );
                    }

                    final ads = state is GetPostAdLoaded
                        ? state.ads
                        : (state as GetPostAdLoading).previousAds ?? [];

                    final premiumAds = state is GetPostAdLoaded
                        ? state.premiumAds
                        : (state as GetPostAdLoading).previousPremiumAds ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (premiumAds.isNotEmpty) ...[
                          PremiumAdsCarousel(premiumAds: premiumAds),
                          const SizedBox(height: 16),
                        ],
                        Expanded(child: _buildAdList(context, ads)),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandFilter() {
    return BlocBuilder<AddPostBloc, AddPostState>(
      builder: (context, state) {
        final brands =
            state is BrandsLoaded ? state.brands : <BrandModel>[];
        return Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: brands.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final brand = brands[index];
              return FilterBrandIcon(
                brandName: brand.brandName!,
                imageUrl: brand.image,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAdList(BuildContext context, List ads) {
    return RefreshIndicator(
      onRefresh: () async {
        final currentState = context.read<GetPostAdBloc>().state;
        if (currentState is GetPostAdLoaded &&
            currentState.selectedBrand != null) {
          context
              .read<GetPostAdBloc>()
              .add(RefreshActiveAds(selectedBrand: currentState.selectedBrand));
        } else {
          context.read<GetPostAdBloc>().add(const RefreshActiveAds());
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: ads.length,
          itemBuilder: (context, index) {
            return AdCard(ad: ads[index], showFavoriteBadge: false);
          },
        ),
      ),
    );
  }

  Widget _buildBrandSectionShimmer(BuildContext context) {
    return BrandSectionShimmer();
  }

  Widget _buildAdListShimmer(BuildContext context) {
    return AdListShimmer();
  }
}
