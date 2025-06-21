import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/widget/ad_cards.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/search_filter_model.dart';
import 'package:shiftwheels/presentation/search_screen/search_bloc/search_bloc.dart';

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
      appBar: AppBar(
        title: const Text('Search Cars'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildSearchBar(context),
              _buildFilterChips(state),
              Expanded(child: _buildSearchResults(state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search by brand, model, etc...",
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: InputBorder.none,
                  isDense: true,
                ),
                onChanged: (query) {
                  context.read<SearchBloc>().add(SearchQueryChanged(query));
                },
              ),
            ),
            IconButton(
              onPressed: () => _showFilterBottomSheet(context),
              icon: Icon(Icons.tune, color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(SearchState state) {
    if (state is! SearchLoaded) return const SizedBox.shrink();

    final filter = state.currentFilter;
    final chips = <Widget>[];

    void addFilterChip(String label, VoidCallback onDeleted) {
      chips.add(
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: Chip(
            label: Text(label),
            deleteIcon: const Icon(Icons.close, size: 16),
            onDeleted: onDeleted,
          ),
        ),
      );
    }

    if (filter.brand != null) {
      addFilterChip(
        'Brand: ${filter.brand}',
        () => context.read<SearchBloc>().add(
          SearchFilterChanged(filter.copyWith(brand: null)),
        ),
      );
    }

    if (filter.model != null) {
      addFilterChip(
        'Model: ${filter.model}',
        () => context.read<SearchBloc>().add(
          SearchFilterChanged(filter.copyWith(model: null)),
        ),
      );
    }

    if (filter.fuelType != null) {
      addFilterChip(
        'Fuel: ${filter.fuelType}',
        () => context.read<SearchBloc>().add(
          SearchFilterChanged(filter.copyWith(fuelType: null)),
        ),
      );
    }

    if (filter.transmissionType != null) {
      addFilterChip(
        'Trans: ${filter.transmissionType}',
        () => context.read<SearchBloc>().add(
          SearchFilterChanged(filter.copyWith(transmissionType: null)),
        ),
      );
    }

    if (filter.minYear != null || filter.maxYear != null) {
      final yearText = filter.minYear != null && filter.maxYear != null
          ? 'Years: ${filter.minYear}-${filter.maxYear}'
          : filter.minYear != null
              ? 'Min Year: ${filter.minYear}'
              : 'Max Year: ${filter.maxYear}';
      addFilterChip(
        yearText,
        () => context.read<SearchBloc>().add(
          SearchFilterChanged(
            filter.copyWith(minYear: null, maxYear: null),
          ),
        ),
      );
    }

    if (filter.maxOwners != null) {
      addFilterChip(
        'Max Owners: ${filter.maxOwners}',
        () => context.read<SearchBloc>().add(
          SearchFilterChanged(filter.copyWith(maxOwners: null)),
        ),
      );
    }

    if (filter.minPrice != null || filter.maxPrice != null) {
      final priceText = filter.minPrice != null && filter.maxPrice != null
          ? 'Price: \$${filter.minPrice}-\$${filter.maxPrice}'
          : filter.minPrice != null
              ? 'Min Price: \$${filter.minPrice}'
              : 'Max Price: \$${filter.maxPrice}';
      addFilterChip(
        priceText,
        () => context.read<SearchBloc>().add(
          SearchFilterChanged(
            filter.copyWith(minPrice: null, maxPrice: null),
          ),
        ),
      );
    }

    if (filter.maxDistanceInKm != null && filter.userLocation != null) {
      addFilterChip(
        'Within ${filter.maxDistanceInKm}km',
        () => context.read<SearchBloc>().add(
          SearchFilterChanged(
            filter.copyWith(maxDistanceInKm: null, userLocation: null),
          ),
        ),
      );
    }

    if (filter.sortBy != null) {
      final sortLabel = _getSortLabel(filter.sortBy!);
      addFilterChip(
        'Sort: $sortLabel',
        () => context.read<SearchBloc>().add(
          SearchFilterChanged(filter.copyWith(sortBy: null)),
        ),
      );
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: chips),
    );
  }

  String _getSortLabel(String sortBy) {
    switch (sortBy) {
      case 'price_asc':
        return 'Price: Low to High';
      case 'price_desc':
        return 'Price: High to Low';
      case 'year_asc':
        return 'Year: Oldest First';
      case 'year_desc':
        return 'Year: Newest First';
      case 'distance_asc':
        return 'Distance: Nearest First';
      default:
        return sortBy;
    }
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
          context.read<SearchBloc>().add(SearchFilterChanged(state.currentFilter));
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 0.75,
            ),
            itemCount: ads.length,
            itemBuilder: (context, index) {
              return AdCard(ad: ads[index]);
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

class FilterBottomSheet extends StatefulWidget {
  final SearchFilter initialFilter;
  final ValueChanged<SearchFilter> onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late SearchFilter _tempFilter;

  @override
  void initState() {
    super.initState();
    _tempFilter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Text(
              'Filter Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // No of Owners
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('No of Owner'),
                DropdownButtonFormField<int>(
                  value: _tempFilter.maxOwners,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Any')),
                    DropdownMenuItem(value: 1, child: Text('1st')),
                    DropdownMenuItem(value: 2, child: Text('2nd')),
                    DropdownMenuItem(value: 3, child: Text('3rd')),
                    DropdownMenuItem(value: 4, child: Text('4th')),
                    DropdownMenuItem(value: 5, child: Text('5+')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _tempFilter = _tempFilter.copyWith(maxOwners: value);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Fuel Type and Transmission
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Fuel Type'),
                      DropdownButtonFormField<String>(
                        value: _tempFilter.fuelType,
                        items: const [
                          DropdownMenuItem(value: null, child: Text('Any')),
                          DropdownMenuItem(
                            value: 'Petrol',
                            child: Text('Petrol'),
                          ),
                          DropdownMenuItem(
                            value: 'Diesel',
                            child: Text('Diesel'),
                          ),
                          DropdownMenuItem(
                            value: 'Electric',
                            child: Text('Electric'),
                          ),
                          DropdownMenuItem(
                            value: 'Hybrid',
                            child: Text('Hybrid'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(fuelType: value);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Transmission'),
                      DropdownButtonFormField<String>(
                        value: _tempFilter.transmissionType,
                        items: const [
                          DropdownMenuItem(value: null, child: Text('Any')),
                          DropdownMenuItem(
                            value: 'Manual',
                            child: Text('Manual'),
                          ),
                          DropdownMenuItem(
                            value: 'Automatic',
                            child: Text('Automatic'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              transmissionType: value,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Year Range
            const Text('Year Range'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Min Year',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: _tempFilter.minYear?.toString(),
                    onChanged: (value) {
                      setState(() {
                        _tempFilter = _tempFilter.copyWith(
                          minYear:
                              value.isNotEmpty ? int.tryParse(value) : null,
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Max Year',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: _tempFilter.maxYear?.toString(),
                    onChanged: (value) {
                      setState(() {
                        _tempFilter = _tempFilter.copyWith(
                          maxYear:
                              value.isNotEmpty ? int.tryParse(value) : null,
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Price Range
            const Text('Price Range'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Min Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: _tempFilter.minPrice?.toString(),
                    onChanged: (value) {
                      setState(() {
                        _tempFilter = _tempFilter.copyWith(
                          minPrice:
                              value.isNotEmpty ? double.tryParse(value) : null,
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Max Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: _tempFilter.maxPrice?.toString(),
                    onChanged: (value) {
                      setState(() {
                        _tempFilter = _tempFilter.copyWith(
                          maxPrice:
                              value.isNotEmpty ? double.tryParse(value) : null,
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Radius
            const Text('Search Radius (km)'),
            Slider(
              value: _tempFilter.maxDistanceInKm ?? 50,
              min: 1,
              max: 100,
              divisions: 99,
              label: '${_tempFilter.maxDistanceInKm ?? 50} km',
              onChanged: (value) {
                setState(() {
                  _tempFilter = _tempFilter.copyWith(maxDistanceInKm: value);
                });
              },
            ),
            const SizedBox(height: 16),

            // Sort Options
            const Text('Sort By'),
            DropdownButtonFormField<String>(
              value: _tempFilter.sortBy ?? 'price_desc',
              items: const [
                DropdownMenuItem(
                  value: 'price_asc',
                  child: Text('Price: Low to High'),
                ),
                DropdownMenuItem(
                  value: 'price_desc',
                  child: Text('Price: High to Low'),
                ),
                DropdownMenuItem(
                  value: 'year_asc',
                  child: Text('Year: Oldest First'),
                ),
                DropdownMenuItem(
                  value: 'year_desc',
                  child: Text('Year: Newest First'),
                ),
                DropdownMenuItem(
                  value: 'distance_asc',
                  child: Text('Distance: Nearest First'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _tempFilter = _tempFilter.copyWith(sortBy: value);
                });
              },
            ),
            const SizedBox(height: 20),

            // Clear All Filters Button
            if (!_tempFilter.isEmpty)
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _tempFilter = SearchFilter();
                    });
                  },
                  child: const Text(
                    'Clear All Filters',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.zPrimaryColor,
                ),
                onPressed: () {
                  widget.onApply(_tempFilter);
                },
                child: const Text(
                  "Apply Filters",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}