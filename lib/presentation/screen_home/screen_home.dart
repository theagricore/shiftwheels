import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/widget/ad_cards.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/common_widget/widget/filter_brand_icon.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/brand_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_brand_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_models_usecase.dart';
import 'package:shiftwheels/presentation/add_post/add_post_bloc/add_post_bloc.dart';
import 'package:shiftwheels/presentation/screen_home/get_post_ad_bloc/get_post_ad_bloc.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  AddPostBloc(sl<GetBrandUsecase>(), sl<GetModelsUsecase>())
                    ..add(FetchBrandsEvent(),
              ),
        ),
        BlocProvider(
          create: (context) => sl<GetPostAdBloc>()..add(const FetchActiveAds()),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(context),
              _buildBrandFilter(),
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
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is GetPostAdError) {
                      return const Center(
                        child: Text('Something went wrong. Retry.'),
                      );
                    }

                    final ads =
                        state is GetPostAdLoaded
                            ? state.ads
                            : (state as GetPostAdLoading).previousAds ?? [];

                    if (ads.isEmpty) {
                      return const Center(
                        child: Text('No active listings found'),
                      );
                    }

                    return _buildAdList(context, ads);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                );
              },
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColors.zPrimaryColor,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: AppColors.zPrimaryColor.withOpacity(0.7),
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.location_on,
              size: 40,
              color: AppColors.zPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandFilter() {
    return BlocBuilder<AddPostBloc, AddPostState>(
      builder: (context, state) {
        List<BrandModel> brands = [];
        if (state is BrandsLoaded) {
          brands = state.brands;
        }
        return Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const FilterBrandIcon(brandName: 'ALL'),
              ...brands.map(
                (brand) => FilterBrandIcon(
                  brandName: brand.brandName!,
                  imageUrl: brand.image,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Ad Grid View
  Widget _buildAdList(BuildContext context, List ads) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GetPostAdBloc>().add(const RefreshActiveAds());
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 0.75,
          ),
          itemCount: ads.length,
          itemBuilder: (context, index) {
            return AdCard(ad: ads[index]);
          },
        ),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const Center(
        child: Text('Search functionality will be implemented here'),
      ),
    );
  }
}
