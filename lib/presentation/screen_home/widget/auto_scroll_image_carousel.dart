import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/screen_my_ads/interest_bloc/interest_bloc.dart';

class AutoScrollImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final String adId;
  final String currentUserId;

  const AutoScrollImageCarousel({
    super.key,
    required this.imageUrls,
    required this.adId,
    required this.currentUserId,
  });

  @override
  State<AutoScrollImageCarousel> createState() =>
      _AutoScrollImageCarouselState();
}

class _AutoScrollImageCarouselState extends State<AutoScrollImageCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();

    // Load initial interest state
    context.read<InterestBloc>().add(
      LoadInitialInterestEvent(widget.adId, widget.currentUserId),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final nextPage = (_currentPage + 1) % widget.imageUrls.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          // Image carousel
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return Image.network(
                widget.imageUrls[index],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.zWhite,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: AppColors.zblack),
                    ),
                  );
                },
              );
            },
          ),

          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.imageUrls.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 20 : 8,
                  height: 6,
                  decoration: BoxDecoration(
                    color:
                        _currentPage == index
                            ? AppColors.zPrimaryColor
                            : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
