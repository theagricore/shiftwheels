import 'package:shiftwheels/core/common_widget/Widget/bottom_nav_bar_widget.dart';
import 'package:shiftwheels/core/config/helper/navigator/app_navigator.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/main_screen/screen_home/screen_home.dart';
import 'package:shiftwheels/presentation/main_screen/screen_message/screen_message.dart';
import 'package:shiftwheels/presentation/main_screen/screen_my_ads/screen_my_ads.dart';
import 'package:shiftwheels/presentation/main_screen/screen_profile/screen_profile.dart';

import 'package:flutter/material.dart';
import 'package:shiftwheels/presentation/add_post/screen_add_post.dart';

class MainScreens extends StatefulWidget {
  const MainScreens({super.key});

  @override
  State<MainScreens> createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ScreenHome(),
    ScreenMessage(),
    ScreenMyAds(),
    ScreenProfile()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            AppNavigator.push(context, ScreenAddPost());
          },
          shape: const CircleBorder(),
          backgroundColor: AppColors.zPrimaryColor,
          child: const Icon(Icons.add, color: Colors.white, size: 40),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}