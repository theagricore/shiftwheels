import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: SearchAppBar(
        searchController: _searchController,
        onFilterPressed: () => _showFilterBottomSheet(context),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return Column(
            children: [Expanded(child: _buildSearchResults(state))],
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(SearchState state) {
    if (state is SearchLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is SearchError) {
      return Center(child: Text(state.message));
    }

    if (state is SearchLoaded) {
      final ads = state.ads;

      if (ads.isEmpty) {
        return const Center(child: Text('No results found'));
      }

      return RefreshIndicator(
        onRefresh: () async {
          context.read<SearchBloc>().add(
            SearchFilterChanged(state.currentFilter),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: ads.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: ListAdCard(ad: ads[index]),
              );
            },
          ),
        ),
      );
    }

    return const Center(child: CircularProgressIndicator());
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

