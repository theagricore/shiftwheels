import 'package:flutter/material.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_tab_bar_widget.dart';
import 'package:shiftwheels/presentation/screen_my_ads/active_ad_widget.dart';
import 'package:shiftwheels/presentation/screen_my_ads/favourite_widget.dart';

class ScreenMyAds extends StatelessWidget {
  const ScreenMyAds({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BasicTabBarWidget(
          tabTitles: const ['FAVOURITE', ' ADS'],
          tabViews: const [FavouriteWidget(), ActiveAdWidget()],
        ),
      ),
    );
  }
}
