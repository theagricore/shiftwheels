import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shiftwheels/core/common_widget/widget/swipe_botton.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/presentation/screen_my_ads/active_ads_bloc/active_ads_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/screen_edit_ad.dart';
import 'package:shiftwheels/presentation/screen_my_ads/update_ad_bloc/update_ad_bloc.dart';
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
            _buildPostedDate(adData.postedDate),
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

  Widget _buildPostedDate(DateTime? date) {
    return Text(
      "Posted: ${_formatDate(date)}",
      style: TextStyle(fontSize: 12, color: AppColors.zGrey[500]),
    );
  }

  Widget _buildAdMainDetails(BuildContext context, AdsModel adData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAdImage(adData.imageUrls.first),
        const SizedBox(width: 12),
        Expanded(child: _buildAdInfoText(context, adData)),
      ],
    );
  }

  Widget _buildAdImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imageUrl,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 80),
      ),
    );
  }

  Widget _buildAdInfoText(BuildContext context, AdsModel adData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${adData.brand} ${adData.model}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            Text(
              adData.year.toString(),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text("Fuel: ${adData.fuelType}",
            style: Theme.of(context).textTheme.labelLarge),
        Text("Transmission: ${adData.transmissionType}",
            style: Theme.of(context).textTheme.labelMedium),
        Text("KM Driven: ${adData.kmDriven}",
            style: Theme.of(context).textTheme.labelMedium),
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
              onTap: () =>
                  context.read<ActiveAdsBloc>().add(DeactivateAd(ad.ad.id!)),
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

  Widget _buildActionButton(BuildContext context,
      {required String label,
      required VoidCallback onTap,
      required Color color}) {
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
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context, AdsModel ad) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
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
