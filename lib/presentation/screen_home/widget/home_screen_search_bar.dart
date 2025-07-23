import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lottie/lottie.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/search_screen/search_bloc/search_bloc.dart';
import 'package:shiftwheels/presentation/search_screen/search_screen.dart';

class HomeScreenSearchBar extends StatelessWidget {
  const HomeScreenSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color baseColor = isDark ? const Color.fromARGB(255, 43, 37, 37) : AppColors.zWhite;
    Color textColor = isDark ? AppColors.zWhite : AppColors.zfontColor;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => BlocProvider.value(
                  value: BlocProvider.of<SearchBloc>(context),
                  child: const SearchScreen(),
                ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.zPrimaryColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Lottie.asset(
              'assets/images/Animation - search-w1000-h1000.json',
              height: 36,
              width: 36,
              repeat: false,
            ),
            const SizedBox(width: 10),
            Text(
              'Search for cars...',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold,fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
