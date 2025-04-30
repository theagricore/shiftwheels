import 'package:shiftwheels/core/commonWidget/Widget/bottom_nav_bar_widget.dart';
import 'package:shiftwheels/core/config/helper/navigator/app_navigator.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/MainScreen/ScreenAddPost/screen_add_post.dart';
import 'package:shiftwheels/presentation/MainScreen/ScreenHome/screen_home.dart';
import 'package:shiftwheels/presentation/MainScreen/ScreenMessage/screen_message.dart';
import 'package:shiftwheels/presentation/MainScreen/ScreenMyAds/screen_my_ads.dart';
import 'package:shiftwheels/presentation/MainScreen/ScreenProfile/screen_profile.dart';

import 'package:flutter/material.dart';

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