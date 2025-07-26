import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/search_filter_model.dart';

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
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('1st'),
                      selected: _tempFilter.ownerCounts?.contains(1) ?? false,
                      onSelected: (selected) {
                        setState(() {
                          _tempFilter = _tempFilter.copyWith(
                            ownerCounts: _updateList(
                              _tempFilter.ownerCounts ?? [],
                              1,
                              selected,
                            ),
                          );
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('2nd'),
                      selected: _tempFilter.ownerCounts?.contains(2) ?? false,
                      onSelected: (selected) {
                        setState(() {
                          _tempFilter = _tempFilter.copyWith(
                            ownerCounts: _updateList(
                              _tempFilter.ownerCounts ?? [],
                              2,
                              selected,
                            ),
                          );
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('3rd'),
                      selected: _tempFilter.ownerCounts?.contains(3) ?? false,
                      onSelected: (selected) {
                        setState(() {
                          _tempFilter = _tempFilter.copyWith(
                            ownerCounts: _updateList(
                              _tempFilter.ownerCounts ?? [],
                              3,
                              selected,
                            ),
                          );
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('4th'),
                      selected: _tempFilter.ownerCounts?.contains(4) ?? false,
                      onSelected: (selected) {
                        setState(() {
                          _tempFilter = _tempFilter.copyWith(
                            ownerCounts: _updateList(
                              _tempFilter.ownerCounts ?? [],
                              4,
                              selected,
                            ),
                          );
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('5+'),
                      selected: _tempFilter.ownerCounts?.contains(5) ?? false,
                      onSelected: (selected) {
                        setState(() {
                          _tempFilter = _tempFilter.copyWith(
                            ownerCounts: _updateList(
                              _tempFilter.ownerCounts ?? [],
                              5,
                              selected,
                            ),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Fuel Type
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Fuel Type'),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('Petrol'),
                      selected: _tempFilter.fuelTypes?.contains('Petrol') ?? false,
                      onSelected: (selected) {
                        setState(() {
                          _tempFilter = _tempFilter.copyWith(
                            fuelTypes: _updateList(
                              _tempFilter.fuelTypes ?? [],
                              'Petrol',
                              selected,
                            ),
                          );
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('Diesel'),
                      selected: _tempFilter.fuelTypes?.contains('Diesel') ?? false,
                      onSelected: (selected) {
                        setState(() {
                          _tempFilter = _tempFilter.copyWith(
                            fuelTypes: _updateList(
                              _tempFilter.fuelTypes ?? [],
                              'Diesel',
                              selected,
                            ),
                          );
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('Electric'),
                      selected: _tempFilter.fuelTypes?.contains('Electric') ?? false,
                      onSelected: (selected) {
                        setState(() {
                          _tempFilter = _tempFilter.copyWith(
                            fuelTypes: _updateList(
                              _tempFilter.fuelTypes ?? [],
                              'Electric',
                              selected,
                            ),
                          );
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('Hybrid'),
                      selected: _tempFilter.fuelTypes?.contains('Hybrid') ?? false,
                      onSelected: (selected) {
                        setState(() {
                          _tempFilter = _tempFilter.copyWith(
                            fuelTypes: _updateList(
                              _tempFilter.fuelTypes ?? [],
                              'Hybrid',
                              selected,
                            ),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Transmission
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Transmission'),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('Manual'),
                      selected: _tempFilter.transmissionTypes?.contains('Manual') ?? false,
                      onSelected: (selected) {
                        setState(() {
                          _tempFilter = _tempFilter.copyWith(
                            transmissionTypes: _updateList(
                              _tempFilter.transmissionTypes ?? [],
                              'Manual',
                              selected,
                            ),
                          );
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('Automatic'),
                      selected: _tempFilter.transmissionTypes?.contains('Automatic') ?? false,
                      onSelected: (selected) {
                        setState(() {
                          _tempFilter = _tempFilter.copyWith(
                            transmissionTypes: _updateList(
                              _tempFilter.transmissionTypes ?? [],
                              'Automatic',
                              selected,
                            ),
                          );
                        });
                      },
                    ),
                  ],
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

  List<T> _updateList<T>(List<T> currentList, T value, bool selected) {
    final newList = List<T>.from(currentList);
    if (selected) {
      if (!newList.contains(value)) {
        newList.add(value);
      }
    } else {
      newList.remove(value);
    }
    return newList;
  }
}