import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/widget/ad_cards.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';
import 'package:shiftwheels/presentation/screen_home/widget/simmer%20effect.dart';
import 'package:shiftwheels/presentation/screen_my_ads/add_favourite_bloc/add_favourite_bloc.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class FavouriteWidget extends StatelessWidget {
  const FavouriteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return BlocProvider(
      create: (context) => AddFavouriteBloc(sl<PostRepository>())
        ..add(LoadFavoritesEvent(currentUserId)),
      child: const _FavouriteContent(),
    );
  }
}

class _FavouriteContent extends StatelessWidget {
  const _FavouriteContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AddFavouriteBloc, AddFavouriteState>(
        builder: (context, state) {
          return _buildContentBasedOnState(context, state);
        },
      ),
    );
  }

  Widget _buildContentBasedOnState(BuildContext context, AddFavouriteState state) {
    if (state is AddFavouriteInitial || state is AddFavouriteLoading) {
      return const CustomScrollView(
        slivers: [
          SimmerWidget(), 
        ],
      );
    }

    if (state is AddFavouriteError) {
      return _buildErrorWidget(context);
    }

    if (state is FavoritesLoaded) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return _buildFavoritesList(context, state, constraints);
        },
      );
    }

    return const SizedBox();
  }

  Widget _buildErrorWidget(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    
    return Center(
      child: Text(
        'Retry',
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
          fontSize: isWeb ? 24 : Theme.of(context).textTheme.displayLarge?.fontSize,
        ),
      ),
    );
  }

  Widget _buildFavoritesList(BuildContext context, FavoritesLoaded state, BoxConstraints constraints) {
    final isWeb = constraints.maxWidth > 600;
    
    return RefreshIndicator(
      onRefresh: () => _refreshFavorites(context),
      child: state.favorites.isEmpty
          ? _buildEmptyState(isWeb)
          : _buildGridView(state, isWeb),
    );
  }

  Future<void> _refreshFavorites(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    context.read<AddFavouriteBloc>().add(LoadFavoritesEvent(userId));
  }

  Widget _buildEmptyState(bool isWeb) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Text(
          'No favorites yet',
          style: TextStyle(fontSize: isWeb ? 18 : null),
        ),
      ),
    );
  }

  Widget _buildGridView(FavoritesLoaded state, bool isWeb) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isWeb ? 4 : 2,
          childAspectRatio: isWeb ? 0.85 : 0.75,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: state.favorites.length,
        itemBuilder: (context, index) {
          final ad = state.favorites[index];
          return AdCard(
            ad: ad, 
            showFavoriteBadge: true,
          );
        },
      ),
    );
  }
}