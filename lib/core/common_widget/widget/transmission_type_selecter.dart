import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class TransmissionTypeSelector extends StatefulWidget {
  final Function(String) onTransmissionSelected;
  final String initialType;

  const TransmissionTypeSelector({
    Key? key,
    this.initialType = 'Manual', 
    required this.onTransmissionSelected,
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildOption(
          label: 'Manual',
          isSelected: selectedType == 'Manual',
          onTap: () => select('Manual'),
          size: size,
        ),
        const SizedBox(width: 10),
        _buildOption(
          label: 'Automatic',
          isSelected: selectedType == 'Automatic',
          onTap: () => select('Automatic'),
          size: size,
        ),
      ],
    );
  }

  Widget _buildOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Size size,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.40,
        height: size.height * 0.06,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.zBackGround,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? AppColors.zPrimaryColor : AppColors.zfontColor,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.zPrimaryColor : AppColors.zWhite,
          ),
        ),
      ),
    );
  }
}