import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class TransmissionTypeSelector extends StatefulWidget {
  final Function(String) onTransmissionSelected;
  final String initialType;
  final bool isWeb;

  const TransmissionTypeSelector({
    Key? key,
    this.initialType = '',
    required this.onTransmissionSelected,
    this.isWeb = false,
  }) : super(key: key);

  @override
  _TransmissionTypeSelectorState createState() => _TransmissionTypeSelectorState();
}

class _TransmissionTypeSelectorState extends State<TransmissionTypeSelector> {
  late String selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = widget.initialType;
  }

  @override
  void didUpdateWidget(TransmissionTypeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialType != widget.initialType) {
      setState(() {
        selectedType = widget.initialType;
      });
    }
  }

  void select(String type) {
    setState(() => selectedType = type);
    widget.onTransmissionSelected(type);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Transmission Type*',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: widget.isWeb ? 14 : null,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildOption(
              label: 'Manual',
              isSelected: selectedType == 'Manual',
              onTap: () => select('Manual'),
              size: size,
              isDarkMode: isDarkMode,
              isWeb: widget.isWeb,
            ),
            const SizedBox(width: 10),
            _buildOption(
              label: 'Automatic',
              isSelected: selectedType == 'Automatic',
              onTap: () => select('Automatic'),
              size: size,
              isDarkMode: isDarkMode,
              isWeb: widget.isWeb,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Size size,
    required bool isDarkMode,
    required bool isWeb,
  }) {
    final Color backgroundColor = isDarkMode 
        ? AppColors.zBackGround 
        : AppColors.zWhite;
    
    final Color borderColor = isSelected
        ? AppColors.zPrimaryColor
        : (isDarkMode 
            ? AppColors.zWhite.withOpacity(0.4) 
            : AppColors.zfontColor);
    
    final Color textColor = isSelected
        ? AppColors.zPrimaryColor
        : (isDarkMode 
            ? AppColors.zWhite 
            : AppColors.zfontColor);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: isWeb ? size.height * 0.05 : size.height * 0.06,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: isWeb ? 14 : 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}