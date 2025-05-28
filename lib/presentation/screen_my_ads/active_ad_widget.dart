import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shiftwheels/core/common_widget/widget/swipe_botton.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/presentation/screen_my_ads/active_ads_bloc/active_ads_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/update_ad_bloc/update_ad_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/screen_edit_ad.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';
import 'package:intl/intl.dart';

class ActiveAdWidget extends StatelessWidget {
  const ActiveAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return BlocProvider(
      create:
          (context) => sl<ActiveAdsBloc>()..add(LoadActiveAds(currentUserId)),
      child: const _ActiveAdContent(),
    );
  }
}

class _ActiveAdContent extends StatelessWidget {
  const _ActiveAdContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ActiveAdsBloc, ActiveAdsState>(
        builder: (context, state) {
          if (state is ActiveAdsInitial || state is ActiveAdsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ActiveAdsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final userId =
                          FirebaseAuth.instance.currentUser?.uid ?? '';
                      context.read<ActiveAdsBloc>().add(LoadActiveAds(userId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ActiveAdsLoaded) {
            if (state.ads.isEmpty) {
              return const Center(child: Text('No active ads available'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                context.read<ActiveAdsBloc>().add(LoadActiveAds(userId));
              },
              child: ListView.builder(
                itemCount: state.ads.length,
                itemBuilder: (context, index) {
                  final ad = state.ads[index];
                  return ActiveAdCard(ad: ad);
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class ActiveAdCard extends StatelessWidget {
  final AdWithUserModel ad;

  const ActiveAdCard({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    final adData = ad.ad;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final secondaryTextColor =
        isDarkMode ? AppColors.zSecondBackground : AppColors.zGrey[300];
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.zfontColor.withOpacity(0.2)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date posted
            Text(
              "Posted: ${_formatDate(adData.postedDate)}",
              style: TextStyle(fontSize: 12, color: AppColors.zGrey[500]),
            ),
            const SizedBox(height: 12),

            // Image and main details row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    adData.imageUrls.first,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => const Icon(Icons.image, size: 80),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${adData.brand} ${adData.model}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 4),
                          Text(
                            adData.year.toString(),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      Text(
                        "Fuel: ${adData.fuelType}",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        "Transmission: ${adData.transmissionType}",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        "KM Driven: ${adData.kmDriven}",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _navigateToEditScreen(context, ad.ad);
                      },
                      child: Container(
                        width: 70,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: secondaryTextColor,
                          borderRadius: BorderRadius.circular(4),
                         
                        ),
                        child: Text(
                          "Edit",
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(
                           
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        context.read<ActiveAdsBloc>().add(
                          DeactivateAd(ad.ad.id!),
                        );
                      },
                      child: Container(
                        width: 70,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: secondaryTextColor,
                          borderRadius: BorderRadius.circular(4),
                          
                        ),
                        child: Text(
                          "Delete",
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(
                            
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                CustomSwipeButton(
                  onSwipe: () {
                    _navigateToEditScreen(context, ad.ad);
                  },
                  buttonText: "MARK AS SOLD",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context, AdsModel ad) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: BlocProvider.of<ActiveAdsBloc>(context),
                ),
                BlocProvider(create: (context) => sl<UpdateAdBloc>()),
              ],
              child: ScreenEditAd(ad: ad),
            ),
      ),
    ).then((_) {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      context.read<ActiveAdsBloc>().add(LoadActiveAds(userId));
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy').format(date);
  }
}
