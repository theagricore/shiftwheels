import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/presentation/screen_home/screen_ad_details.dart';

class PremiumAdsCarousel extends StatelessWidget {
  final List<AdWithUserModel> premiumAds;

  const PremiumAdsCarousel({super.key, required this.premiumAds});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            children: [
              Text(
                'Featured Listings',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade400, Colors.orange.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'Premium',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        CarouselSlider.builder(
          itemCount: premiumAds.length,
          itemBuilder: (context, index, realIndex) {
            final ad = premiumAds[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScreenAdDetails(adWithUser: ad),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        0.2,
                      ), 
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (ad.ad.imageUrls.isNotEmpty)
                        Image.network(
                          ad.ad.imageUrls.first,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(color: Colors.white),
                            );
                          },
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                color: Colors.grey.shade300,
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                    size: 50,
                                  ),
                                ),
                              ),
                        )
                      else
                        Container(
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 50,
                            ),
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.4, 0.7, 1.0],
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.85),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade400,
                                Colors.orange.shade700,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'PREMIUM',
                                style: Theme.of(
                                  context,
                                ).textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.9),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${ad.ad.brand} ${ad.ad.model}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 8,
                                          color: Colors.black,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    ad.ad.year.toString(),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.speed,
                                    size: 16,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${ad.ad.kmDriven} km',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Text(
                                    '₹${ad.ad.price.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Colors.amberAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 8,
                                          color: Colors.black,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 170,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeCenterPage: false,
            viewportFraction: 0.88,
            aspectRatio: 16 / 9,
            enableInfiniteScroll: premiumAds.length > 1,
            pauseAutoPlayOnTouch: true,
            pageSnapping: true,
            scrollPhysics: const BouncingScrollPhysics(),
          ),
        ),
      ],
    );
  }
}
