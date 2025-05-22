import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/widget/ad_cards.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/screen_home/get_post_ad_bloc/get_post_ad_bloc.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<GetPostAdBloc, GetPostAdState>(
          listener: (context, state) {
            if (state is GetPostAdError) {
              BasicSnackbar(
                message: state.message,
                backgroundColor: AppColors.zred,
              );
            }
          },
          builder: (context, state) {
            if (state is GetPostAdInitial ||
                (state is GetPostAdLoading && state.previousAds == null)) {
              return _buildLoading();
            }
        
            if (state is GetPostAdError) {
              return _buildError();
            }
        
            final ads =
                state is GetPostAdLoaded
                    ? state.ads
                    : (state as GetPostAdLoading).previousAds ?? [];
        
            if (ads.isEmpty) {
              return _buildEmpty();
            }
        
            return _buildAdGrid(context, ads);
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError() {
    return const Center(child: Text('Something went wrong. Retry.'));
  }

  Widget _buildEmpty() {
    return const Center(child: Text('No active listings found'));
  }

  Widget _buildAdGrid(BuildContext context, List ads) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GetPostAdBloc>().add(const RefreshActiveAds());
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemCount: ads.length,
        itemBuilder: (context, index) {
          return AdCard(ad: ads[index]);
        },
      ),
    );
  }
}
