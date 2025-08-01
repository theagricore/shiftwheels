import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class YearPickerWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isWeb;

  const YearPickerWidget({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.isWeb = false,
  });

  @override
  State<YearPickerWidget> createState() => _YearPickerWidgetState();
}

class _YearPickerWidgetState extends State<YearPickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: widget.isWeb ? 14 : null,
              ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showYearPickerDialog(context),
          child: SizedBox(
            height: widget.isWeb ? 50 : 60,
            child: InputDecorator(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: widget.isWeb ? 16 : 22,
                ),
                border: InputBorder.none,
                suffixIcon: Icon(Icons.calendar_today, size: widget.isWeb ? 20 : 25),
              ),
              child: Text(
                widget.controller.text.isEmpty
                    ? "Select Year"
                    : widget.controller.text,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: widget.isWeb ? 14 : null,
                    ),
              ),
            ),
          ),
        ),
        if (widget.validator != null &&
            widget.validator!(widget.controller.text) != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              widget.validator!(widget.controller.text)!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.zred,
                    fontSize: 12,
                  ),
            ),
          ),
      ],
    );
  }

  Future<void> _showYearPickerDialog(BuildContext context) async {
    final currentYear = DateTime.now().year;
    int? selectedYear = widget.controller.text.isNotEmpty
        ? int.tryParse(widget.controller.text)
        : null;

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxWidth: widget.isWeb ? 600 : double.infinity,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Year",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.zPrimaryColor,
                        fontSize: widget.isWeb ? 20 : null,
                      ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  width: double.maxFinite,
                  child: YearPickerGrid(
                    currentYear: currentYear,
                    selectedYear: selectedYear,
                    onYearSelected: (year) {
                      setState(() {
                        widget.controller.text = year.toString();
                      });
                      Navigator.pop(context);
                    },
                    isWeb: widget.isWeb,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: AppColors.zred,
                              fontWeight: FontWeight.w600,
                              fontSize: widget.isWeb ? 14 : null,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class YearPickerGrid extends StatelessWidget {
  final int currentYear;
  final int? selectedYear;
  final Function(int) onYearSelected;
  final bool isWeb;

  const YearPickerGrid({
    super.key,
    required this.currentYear,
    this.selectedYear,
    required this.onYearSelected,
    this.isWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final theme = Theme.of(context);

    final Color textColor = isDarkMode
        ? AppColors.zDarkPrimaryText
        : AppColors.zLightPrimaryText;
    final Color selectedTextColor = AppColors.zPrimaryColor;
    final Color selectedBackgroundColor =
        AppColors.zPrimaryColor.withOpacity(0.15);
    final Color borderColor = isDarkMode
        ? AppColors.zDarkCardBorder
        : AppColors.zLightCardBorder;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWeb ? 4 : 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: isWeb ? 1.8 : 1.6,
      ),
      itemCount: 30,
      itemBuilder: (context, index) {
        final year = currentYear - index;
        final isSelected = year == selectedYear;

        return Card(
          elevation: isSelected ? 4 : 1,
          shadowColor: AppColors.zPrimaryColor.withOpacity(0.3),
          color: isSelected ? selectedBackgroundColor : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? AppColors.zPrimaryColor : borderColor,
              width: isSelected ? 1 : 0.3,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onYearSelected(year),
            child: Center(
              child: Text(
                year.toString(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isSelected ? selectedTextColor : textColor,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: isWeb ? 14 : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}