import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shiftwheels/presentation/search_screen/search_bloc/search_bloc.dart';
import 'package:shiftwheels/presentation/search_screen/widget/filter_bottom_sheet.dart';
import 'package:shiftwheels/presentation/search_screen/widget/list_ad_card.dart';
import 'package:shiftwheels/presentation/search_screen/widget/screen_appbar_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppbarWidget(
        searchController: _searchController,
        onFilterPressed: () => _showFilterBottomSheet(context),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth > 600;
          return BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? constraints.maxWidth * 0.1 : 0,
                      ),
                      child: _buildSearchResults(state, isWeb),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(SearchState state, bool isWeb) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (state is SearchLoading) {
      return Center(
        child: Container(
          child: Lottie.asset(
            'assets/images/Animation - search-w1000-h1000.json',
            height: 200,
            width: 200,
            fit: BoxFit.contain,
            repeat: false,
          ),
        ),
      );
    }

    if (state is SearchError) {
      return Center(
        child: Text(
          state.message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDarkMode ? Colors.redAccent : Colors.redAccent,
                fontSize: isWeb ? 14 : null,
              ),
        ),
      );
    }

    if (state is SearchLoaded) {
      final ads = state.ads;

      if (ads.isEmpty) {
        return Center(
          child: Text(
            'No results found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: isDarkMode
                      ? Theme.of(context).colorScheme.onBackground
                      : Colors.grey.shade700,
                  fontSize: isWeb ? 20 : null,
                ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          context.read<SearchBloc>().add(
                SearchFilterChanged(state.currentFilter),
              );
        },
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? 20.0 : 6.0,
            vertical: 8.0,
          ),
          child: isWeb
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _calculateCrossAxisCount(context),
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: ads.length,
                  itemBuilder: (context, index) {
                    return ListAdCard(ad: ads[index], isWeb: isWeb);
                  },
                )
              : ListView.builder(
                  itemCount: ads.length,
                  itemBuilder: (context, index) {
                    return ListAdCard(ad: ads[index], isWeb: isWeb);
                  },
                ),
        ),
      );
    }

    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 3;
    if (width > 800) return 2;
    return 1;
  }

  void _showFilterBottomSheet(BuildContext context) {
    final currentState = context.read<SearchBloc>().state;
    if (currentState is! SearchLoaded) return;

    final currentFilter = currentState.currentFilter;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FilterBottomSheet(
          initialFilter: currentFilter,
          onApply: (newFilter) {
            context.read<SearchBloc>().add(SearchFilterChanged(newFilter));
            Navigator.pop(context);
          },
        );
      },
    );
  }
}