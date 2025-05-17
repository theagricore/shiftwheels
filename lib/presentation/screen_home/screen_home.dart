import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/presentation/screen_home/get_post_ad_bloc/get_post_ad_bloc.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Listings'),
       centerTitle: true,
      ),
      body: BlocConsumer<GetPostAdBloc, GetPostAdState>(
        listener: (context, state) {
          if (state is GetPostAdError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          // Handle loading state
          if (state is GetPostAdInitial || 
              (state is GetPostAdLoading && state.previousAds == null)) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (state is GetPostAdError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GetPostAdBloc>().add(const FetchActiveAds());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Get the current ads list
          final ads = state is GetPostAdLoaded 
              ? state.ads 
              : (state as GetPostAdLoading).previousAds ?? [];

          // Handle empty state
          if (ads.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.car_rental, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No active listings found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GetPostAdBloc>().add(const RefreshActiveAds());
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<GetPostAdBloc>().add(const RefreshActiveAds());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: ads.length,
              itemBuilder: (context, index) {
                final ad = ads[index];
                return _buildAdCard(context, ad);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdCard(BuildContext context, AdWithUserModel ad) {
    final theme = Theme.of(context);
    final priceTextStyle = theme.textTheme.titleLarge?.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Car Images
              if (ad.ad.imageUrls.isNotEmpty)
                SizedBox(
                  height: 180,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: PageView.builder(
                      itemCount: ad.ad.imageUrls.length,
                      itemBuilder: (context, imgIndex) {
                        return Image.network(
                          ad.ad.imageUrls[imgIndex],
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.image_not_supported),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 12),

              // Title and Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${ad.ad.brand} ${ad.ad.model}',
                      style: theme.textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '\$${ad.ad.price}',
                    style: priceTextStyle,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildDetailChip(Icons.calendar_today, '${ad.ad.year}'),
                  _buildDetailChip(Icons.local_gas_station, ad.ad.fuelType),

                ],
              ),
              const SizedBox(height: 12),

              // User Info
              if (ad.userData != null)
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: ad.userData!['photoUrl'] != null
                          ? NetworkImage(ad.userData!['photoUrl'])
                          : null,
                      child: ad.userData!['photoUrl'] == null
                          ? const Icon(Icons.person, size: 16)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ad.userData!['fullName'] ?? 'Unknown',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(text),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}