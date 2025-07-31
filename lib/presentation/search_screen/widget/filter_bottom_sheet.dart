import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

class _FilterBottomSheetState extends State<FilterBottomSheet> with SingleTickerProviderStateMixin {
  late SearchFilter _tempFilter;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tempFilter = widget.initialFilter;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 600;
        final textScaleFactor = isWeb ? 0.9 : 1.0;
        
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.zBackGround : AppColors.zLightCardBackground,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            constraints: BoxConstraints(
              maxHeight: isWeb ? constraints.maxHeight * 0.9 : constraints.maxHeight * 0.85,
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? 40.0 : 20.0,
                  vertical: isWeb ? 24.0 : 16.0,
                ),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: isWeb ? 60 : 50,
                            height: isWeb ? 6 : 5,
                            margin: EdgeInsets.only(bottom: isWeb ? 20 : 16),
                            decoration: BoxDecoration(
                              color: isDarkMode ? AppColors.zDarkDivider : AppColors.zLightDivider,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Text(
                          'Filter Options',
                          style: GoogleFonts.poppins(
                            fontSize: isWeb ? 22 : 20,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? AppColors.zDarkPrimaryText : AppColors.zLightPrimaryText,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // No of Owners
                        _buildSectionTitle(context, 'Number of Owners', isWeb),
                        Wrap(
                          spacing: isWeb ? 12 : 8,
                          runSpacing: isWeb ? 12 : 8,
                          children: [
                            _buildFilterChip(context, '1st', _tempFilter.ownerCounts?.contains(1) ?? false, 
                              (selected) => _updateOwnerCount(1, selected), isWeb),
                            _buildFilterChip(context, '2nd', _tempFilter.ownerCounts?.contains(2) ?? false, 
                              (selected) => _updateOwnerCount(2, selected), isWeb),
                            _buildFilterChip(context, '3rd', _tempFilter.ownerCounts?.contains(3) ?? false, 
                              (selected) => _updateOwnerCount(3, selected), isWeb),
                            _buildFilterChip(context, '4th', _tempFilter.ownerCounts?.contains(4) ?? false, 
                              (selected) => _updateOwnerCount(4, selected), isWeb),
                            _buildFilterChip(context, '5+', _tempFilter.ownerCounts?.contains(5) ?? false, 
                              (selected) => _updateOwnerCount(5, selected), isWeb),
                          ],
                        ),
                        SizedBox(height: isWeb ? 28 : 24),

                        // Fuel Type
                        _buildSectionTitle(context, 'Fuel Type', isWeb),
                        Wrap(
                          spacing: isWeb ? 12 : 8,
                          runSpacing: isWeb ? 12 : 8,
                          children: [
                            _buildFilterChip(context, 'Petrol', _tempFilter.fuelTypes?.contains('Petrol') ?? false, 
                              (selected) => _updateFuelType('Petrol', selected), isWeb),
                            _buildFilterChip(context, 'Diesel', _tempFilter.fuelTypes?.contains('Diesel') ?? false, 
                              (selected) => _updateFuelType('Diesel', selected), isWeb),
                            _buildFilterChip(context, 'Electric', _tempFilter.fuelTypes?.contains('Electric') ?? false, 
                              (selected) => _updateFuelType('Electric', selected), isWeb),
                            _buildFilterChip(context, 'Hybrid', _tempFilter.fuelTypes?.contains('Hybrid') ?? false, 
                              (selected) => _updateFuelType('Hybrid', selected), isWeb),
                          ],
                        ),
                        SizedBox(height: isWeb ? 28 : 24),

                        // Transmission
                        _buildSectionTitle(context, 'Transmission', isWeb),
                        Wrap(
                          spacing: isWeb ? 12 : 8,
                          runSpacing: isWeb ? 12 : 8,
                          children: [
                            _buildFilterChip(context, 'Manual', _tempFilter.transmissionTypes?.contains('Manual') ?? false, 
                              (selected) => _updateTransmissionType('Manual', selected), isWeb),
                            _buildFilterChip(context, 'Automatic', _tempFilter.transmissionTypes?.contains('Automatic') ?? false, 
                              (selected) => _updateTransmissionType('Automatic', selected), isWeb),
                          ],
                        ),
                        SizedBox(height: isWeb ? 28 : 24),

                        // Year Range
                        _buildSectionTitle(context, 'Year Range', isWeb),
                        Row(
                          children: [
                            _buildTextField(context, 'Min Year', _tempFilter.minYear?.toString(), 
                              (value) => _updateYear(value, true), isWeb),
                            SizedBox(width: isWeb ? 16 : 12),
                            _buildTextField(context, 'Max Year', _tempFilter.maxYear?.toString(), 
                              (value) => _updateYear(value, false), isWeb),
                          ],
                        ),
                        SizedBox(height: isWeb ? 28 : 24),

                        // Price Range
                        _buildSectionTitle(context, 'Price Range', isWeb),
                        Row(
                          children: [
                            _buildTextField(context, 'Min Price', _tempFilter.minPrice?.toString(), 
                              (value) => _updatePrice(value, true), isWeb),
                            SizedBox(width: isWeb ? 16 : 12),
                            _buildTextField(context, 'Max Price', _tempFilter.maxPrice?.toString(), 
                              (value) => _updatePrice(value, false), isWeb),
                          ],
                        ),
                        SizedBox(height: isWeb ? 28 : 24),

                        // Search Radius
                        _buildSectionTitle(context, 'Search Radius (km)', isWeb),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: isWeb ? 8 : 6,
                            thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: isWeb ? 14 : 12,
                            ),
                            overlayShape: RoundSliderOverlayShape(
                              overlayRadius: isWeb ? 28 : 24,
                            ),
                            activeTrackColor: AppColors.zLightAccentColor,
                            inactiveTrackColor: isDarkMode ? AppColors.zDarkDivider : AppColors.zLightDivider,
                            thumbColor: AppColors.zLightAccentColor,
                            overlayColor: AppColors.zLightAccentColor.withOpacity(0.2),
                          ),
                          child: Slider(
                            value: _tempFilter.maxDistanceInKm ?? 50,
                            min: 1,
                            max: 100,
                            divisions: 99,
                            label: '${(_tempFilter.maxDistanceInKm ?? 50).round()} km',
                            onChanged: (value) {
                              setState(() {
                                _tempFilter = _tempFilter.copyWith(maxDistanceInKm: value);
                              });
                            },
                          ),
                        ),
                        SizedBox(height: isWeb ? 28 : 24),

                        // Sort Options
                        _buildSectionTitle(context, 'Sort By', isWeb),
                        DropdownButtonFormField<String>(
                          value: _tempFilter.sortBy ?? 'price_desc',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDarkMode ? AppColors.zDarkDivider : AppColors.zLightDivider,
                              ),
                            ),
                            filled: true,
                            fillColor: isDarkMode ? AppColors.zDarkCountButton : AppColors.zLightCountButton,
                          ),
                          items: const [
                            DropdownMenuItem(value: 'price_asc', child: Text('Price: Low to High')),
                            DropdownMenuItem(value: 'price_desc', child: Text('Price: High to Low')),
                            DropdownMenuItem(value: 'year_asc', child: Text('Year: Oldest First')),
                            DropdownMenuItem(value: 'year_desc', child: Text('Year: Newest First')),
                            DropdownMenuItem(value: 'distance_asc', child: Text('Distance: Nearest First')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _tempFilter = _tempFilter.copyWith(sortBy: value);
                            });
                          },
                          style: GoogleFonts.poppins(
                            color: isDarkMode ? AppColors.zDarkPrimaryText : AppColors.zLightPrimaryText,
                            fontSize: isWeb ? 14 : null,
                          ),
                        ),
                        SizedBox(height: isWeb ? 28 : 24),

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
                              child: Text(
                                'Clear All Filters',
                                style: GoogleFonts.poppins(
                                  color: AppColors.zred,
                                  fontWeight: FontWeight.w500,
                                  fontSize: isWeb ? 15 : null,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: isWeb ? 20 : 16),

                        // Apply Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: isWeb ? 18 : 16),
                              backgroundColor: AppColors.zLightAccentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () {
                              widget.onApply(_tempFilter);
                            },
                            child: Text(
                              'Apply Filters',
                              style: GoogleFonts.poppins(
                                color: AppColors.zWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: isWeb ? 17 : 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: isWeb ? 20 : 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, bool isWeb) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: isWeb ? 17 : 16,
          fontWeight: FontWeight.w500,
          color: isDarkMode ? AppColors.zDarkSecondaryText : AppColors.zLightSecondaryText,
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, 
    String label, 
    bool selected, 
    ValueChanged<bool> onSelected,
    bool isWeb,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return FilterChip(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: isWeb ? 14 : 13,
          color: selected
              ? AppColors.zDarkBackground
              : isDarkMode
                  ? AppColors.zDarkPrimaryText
                  : AppColors.zLightPrimaryText,
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      selectedColor: AppColors.zLightAccentColor,
      backgroundColor: isDarkMode ? AppColors.zDarkCountButton : AppColors.zLightCountButton,
      checkmarkColor: AppColors.zDarkBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDarkMode ? AppColors.zDarkDivider : AppColors.zLightDivider,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 14 : 12,
        vertical: isWeb ? 10 : 8,
      ),
      elevation: selected ? 2 : 0,
    );
  }

  Widget _buildTextField(
    BuildContext context, 
    String label, 
    String? initialValue, 
    ValueChanged<String> onChanged,
    bool isWeb,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: isDarkMode ? AppColors.zDarkSecondaryText : AppColors.zLightSecondaryText,
            fontSize: isWeb ? 14 : null,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDarkMode ? AppColors.zDarkDivider : AppColors.zLightDivider,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDarkMode ? AppColors.zDarkDivider : AppColors.zLightDivider,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.zLightAccentColor,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: isDarkMode ? AppColors.zDarkCountButton : AppColors.zLightCountButton,
          contentPadding: EdgeInsets.symmetric(
            horizontal: isWeb ? 16 : 12,
            vertical: isWeb ? 18 : 16,
          ),
        ),
        keyboardType: TextInputType.number,
        initialValue: initialValue,
        onChanged: onChanged,
        style: GoogleFonts.poppins(
          color: isDarkMode ? AppColors.zDarkPrimaryText : AppColors.zLightPrimaryText,
          fontSize: isWeb ? 15 : null,
        ),
      ),
    );
  }

  void _updateOwnerCount(int value, bool selected) {
    setState(() {
      _tempFilter = _tempFilter.copyWith(
        ownerCounts: _updateList(_tempFilter.ownerCounts ?? [], value, selected),
      );
    });
  }

  void _updateFuelType(String value, bool selected) {
    setState(() {
      _tempFilter = _tempFilter.copyWith(
        fuelTypes: _updateList(_tempFilter.fuelTypes ?? [], value, selected),
      );
    });
  }

  void _updateTransmissionType(String value, bool selected) {
    setState(() {
      _tempFilter = _tempFilter.copyWith(
        transmissionTypes: _updateList(_tempFilter.transmissionTypes ?? [], value, selected),
      );
    });
  }

  void _updateYear(String value, bool isMin) {
    setState(() {
      _tempFilter = isMin
          ? _tempFilter.copyWith(minYear: value.isNotEmpty ? int.tryParse(value) : null)
          : _tempFilter.copyWith(maxYear: value.isNotEmpty ? int.tryParse(value) : null);
    });
  }

  void _updatePrice(String value, bool isMin) {
    setState(() {
      _tempFilter = isMin
          ? _tempFilter.copyWith(minPrice: value.isNotEmpty ? double.tryParse(value) : null)
          : _tempFilter.copyWith(maxPrice: value.isNotEmpty ? double.tryParse(value) : null);
    });
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