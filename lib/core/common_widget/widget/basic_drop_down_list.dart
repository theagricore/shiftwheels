import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class BasicDropDownList<T> extends StatelessWidget {
  final String hintText;
  final List<T> items;
  final T? value;
  final String Function(T) displayItem;
  final Function(T?) onChanged;
  final bool enabled;
  final bool isLoading;

  const BasicDropDownList({
    super.key,
    required this.hintText,
    required this.items,
    required this.value,
    required this.displayItem,
    required this.onChanged,
    this.enabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: isLoading
            ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.zPrimaryColor),
                  ),
                ),
              )
            : const Icon(Icons.arrow_drop_down),
      ),
      value: items.contains(value) ? value : null,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            displayItem(item),
            style: const TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
      onChanged: enabled && !isLoading ? onChanged : null,
      validator: (value) => value == null ? 'Please select an option' : null,
      icon: const SizedBox.shrink(),
     
      isExpanded: true,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
    );
  }
}