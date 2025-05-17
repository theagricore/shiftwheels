import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class SearchFealdWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final VoidCallback? onSearch;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry? padding;

  const SearchFealdWidget({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.onSearch,
    this.onChanged,
    this.padding,
  });

  @override
  State<SearchFealdWidget> createState() => _SearchFealdWidgetState();
}

class _SearchFealdWidgetState extends State<SearchFealdWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(widget.controller.text);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
          prefixIcon: Icon(Icons.search, color: AppColors.zfontColor),
          suffixIcon:
              widget.controller.text.isNotEmpty
                  ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Theme.of(
                        context,
                      ).iconTheme.color?.withOpacity(0.6),
                    ),
                    onPressed: () {
                      widget.controller.clear();
                      if (widget.onChanged != null) {
                        widget.onChanged!('');
                      }
                    },
                  )
                  : null,
          filled: true,

          contentPadding: const EdgeInsets.symmetric(
            vertical: 18.0,
            horizontal: 30.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide:
                isDarkMode ? BorderSide.none : BorderSide(color: primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide:
                isDarkMode ? BorderSide.none : BorderSide(color: primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide:
                isDarkMode ? BorderSide.none : BorderSide(color: primaryColor),
          ),
        ),
        onFieldSubmitted: (value) {
          if (widget.onSearch != null) {
            widget.onSearch!();
          }
        },
      ),
    );
  }
}
