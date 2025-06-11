import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shiftwheels/presentation/screen_my_ads/active_ads_bloc/active_ads_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/widget/active_ad_card.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class ActiveAdWidget extends StatelessWidget {
  const ActiveAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return BlocProvider(
      create: (context) =>
          sl<ActiveAdsBloc>()..add(LoadActiveAds(currentUserId)),
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
          if (state is ActiveAdsInitial || state is ActiveAdsLoading) {
            return _buildLoading();
          } else if (state is ActiveAdsError) {
            return _buildError(state.message);
          } else if (state is ActiveAdsLoaded) {
            if (state.ads.isEmpty) {
              return _buildEmpty();
            } else {
              return _buildAdList(context, state);
            }
          } else {
            return const SizedBox(); 
          }
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(message)],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(child: Text('No active ads available'));
  }

  Widget _buildAdList(BuildContext context, ActiveAdsLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        context.read<ActiveAdsBloc>().add(LoadActiveAds(userId));
      },
      child: ListView.builder(
        itemCount: state.ads.length,
        itemBuilder: (context, index) {
          final ad = state.ads[index];
          return ActiveAdCard(ad: ad);
        },
      ),
    );
  }
}
