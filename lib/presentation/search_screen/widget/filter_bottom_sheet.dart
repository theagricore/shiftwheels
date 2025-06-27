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
