import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_alert_box.dart';
import 'package:shiftwheels/core/common_widget/widget/swipe_botton.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_interested_users_usecase.dart';
import 'package:shiftwheels/presentation/screen_my_ads/active_ads_bloc/active_ads_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/screen_edit_ad.dart';
import 'package:shiftwheels/presentation/screen_my_ads/update_ad_bloc/update_ad_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/widget/users_bottom_sheet.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

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
            Text(
              "Posted: ${_formatDate(adData.postedDate)}",
              style: TextStyle(fontSize: 12, color: AppColors.zGrey[500]),
            ),
            const SizedBox(height: 12),
            _buildAdMainDetails(context, adData),
            const SizedBox(height: 16),
            const Divider(),
            _buildActionButtons(context, secondaryTextColor!),
          ],
        ),
      ),
    );
  }

  Widget _buildAdMainDetails(BuildContext context, AdsModel adData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            adData.imageUrls.first,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 80),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${adData.brand} ${adData.model}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    "${adData.year}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.local_gas_station, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    "Fuel: ${adData.fuelType}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.settings, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    "Transmission: ${adData.transmissionType}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.speed, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    "KM Driven: ${adData.kmDriven}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _buildCountButton(
                    context,
                    icon: Icons.favorite,
                    color: AppColors.zPrimaryColor,
                    count: adData.favoritedByUsers.length,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  _buildCountButton(
                    context,
                    icon: Icons.thumb_up,
                    color: AppColors.zPrimaryColor,
                    count: adData.interestedUsers.length,
                    onTap:
                        () => _showInterestedUsersBottomSheet(
                          context,
                          adData.id!,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, Color secondaryTextColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            _buildActionButton(
              context,
              label: "Edit",
              onTap: () => _navigateToEditScreen(context, ad.ad),
              color: secondaryTextColor,
            ),
            const SizedBox(height: 10),
            _buildActionButton(
              context,
              label: "Delete",
              onTap: () {
                showDeleteConfirmationDialog(
                  context: context,
                  onConfirm: () {
                    context.read<ActiveAdsBloc>().add(DeactivateAd(ad.ad.id!));
                  },
                );
              },
              color: secondaryTextColor,
            ),
          ],
        ),
        CustomSwipeButton(
          onSwipe: () => _navigateToEditScreen(context, ad.ad),
          buttonText: "MARK AS SOLD",
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildCountButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.zGrey[900]
                  : AppColors.zGrey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.zGrey[300]!, width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              count.toString(),
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
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
                BlocProvider(create: (_) => sl<UpdateAdBloc>()),
              ],
              child: ScreenEditAd(ad: ad),
            ),
      ),
    ).then((_) {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      context.read<ActiveAdsBloc>().add(LoadActiveAds(userId));
    });
  }

  void _showInterestedUsersBottomSheet(
    BuildContext context,
    String adId,
  ) async {
    final getInterestedUsersUsecase = sl<GetInterestedUsersUsecase>();
    final result = await getInterestedUsersUsecase(param: adId);

    result.fold(
      (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      },
      (users) {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => InterestedUsersBottomSheet(users: users),
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy').format(date);
  }
}
