import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/presentation/screen_my_ads/active_ads_bloc/active_ads_bloc.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class ActiveAdWidget extends StatelessWidget {
  const ActiveAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return BlocProvider(
      create: (context) => sl<ActiveAdsBloc>()
        ..add(LoadActiveAds(currentUserId)),
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
          return _buildContentBasedOnState(context, state);
        },
      ),
    );
  }

  Widget _buildContentBasedOnState(BuildContext context, ActiveAdsState state) {
    if (state is ActiveAdsInitial || state is ActiveAdsLoading) {
      return _buildLoadingIndicator();
    }

    if (state is ActiveAdsError) {
      return _buildErrorWidget(context, state.message);
    }

    if (state is ActiveAdsLoaded) {
      return _buildAdsList(context, state.ads);
    }

    return const SizedBox();
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
              context.read<ActiveAdsBloc>().add(LoadActiveAds(userId));
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildAdsList(BuildContext context, List<AdWithUserModel> ads) {
    if (ads.isEmpty) {
      return const Center(
        child: Text('No active ads available'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        context.read<ActiveAdsBloc>().add(LoadActiveAds(userId));
      },
      child: ListView.builder(
        itemCount: ads.length,
        itemBuilder: (context, index) {
          final ad = ads[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${ad.ad.brand} ${ad.ad.model}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('Year: ${ad.ad.year}'),
                  Text('Price: \$${ad.ad.price.toStringAsFixed(1)}'),
                  Text('Location: ${ad.ad.location.city ?? ad.ad.location.address}'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          context.read<ActiveAdsBloc>().add(DeactivateAd(ad.ad.id!));
                        },
                        child: const Text('Deactivate'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}