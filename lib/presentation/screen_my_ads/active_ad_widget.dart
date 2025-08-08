import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shiftwheels/presentation/screen_home/widget/simmer%20effect.dart';
import 'package:shiftwheels/presentation/screen_my_ads/active_ads_bloc/active_ads_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/mark_as_sold_bloc/mark_as_sold_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/widget/active_ad_card.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class ActiveAdWidget extends StatelessWidget {
  const ActiveAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ActiveAdsBloc>()..add(LoadActiveAds(currentUserId)),
        ),
        BlocProvider(
          create: (context) => sl<MarkAsSoldBloc>(),
        ),
      ],
      child: const _ActiveAdContent(),
    );
  }
}

class _ActiveAdContent extends StatelessWidget {
  const _ActiveAdContent();

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      body: BlocListener<MarkAsSoldBloc, MarkAsSoldState>(
        listener: (context, state) {
          if (state is MarkAsSoldSuccess) {
            context.read<ActiveAdsBloc>().add(LoadActiveAds(currentUserId));
          } else if (state is MarkAsSoldError) {
          }
        },
        child: BlocBuilder<ActiveAdsBloc, ActiveAdsState>(
          builder: (context, state) {
            if (state is ActiveAdsInitial || state is ActiveAdsLoading) {
              return _buildShimmerLoading();
            } else if (state is ActiveAdsError) {
              return _buildError(context, state.message);
            } else if (state is ActiveAdsLoaded) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final isWeb = kIsWeb && constraints.maxWidth > 600;
                  return state.ads.isEmpty
                      ? _buildEmpty(isWeb)
                      : _buildAdList(context, state, isWeb);
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return const AdActiveCardShimmer();
      },
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final isWeb = kIsWeb;
    return Center(
      child: Text(
        message,
        style: TextStyle(fontSize: isWeb ? 16 : 18),
      ),
    );
  }

  Widget _buildEmpty(bool isWeb) {
    return Center(
      child: Text(
        'No active ads available',
        style: TextStyle(fontSize: isWeb ? 16 : 18),
      ),
    );
  }

  Widget _buildAdList(BuildContext context, ActiveAdsLoaded state, bool isWeb) {
    return RefreshIndicator(
      onRefresh: () async {
        final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        context.read<ActiveAdsBloc>().add(LoadActiveAds(userId));
      },
      child: isWeb
          ? Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                itemCount: state.ads.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.67,
                ),
                itemBuilder: (context, index) {
                  final ad = state.ads[index];
                  return ActiveAdCard(ad: ad);
                },
              ),
            )
          : ListView.builder(
              itemCount: state.ads.length,
              itemBuilder: (context, index) {
                final ad = state.ads[index];
                return ActiveAdCard(ad: ad);
              },
            ),
    );
  }
}