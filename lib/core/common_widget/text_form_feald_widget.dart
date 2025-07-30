import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool multiline;
  final String? Function(String?)? validator;

  const TextFormFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.multiline = false,
    this.validator,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWeb = screenWidth > 600;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isWeb ? 500 : double.infinity),
      child: TextFormField(
        
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? _obscureText : false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLines: widget.multiline ? null : 1,
        minLines: widget.multiline ? 4 : null,
        style: TextStyle(
          fontSize: isWeb ? 14 : 16,
          height: isWeb ? 1.2 : 1.5,
          
        ),
        cursorHeight: isWeb ? 16 : null,
        decoration: InputDecoration(
          errorStyle: TextStyle(
              fontSize: isWeb ? 12 : null, 
          color: Colors.red,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: isWeb ? 10 : 16,
            horizontal: 12,
          ),
          labelText: widget.label,
          labelStyle: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontSize: isWeb ? 13 : null),
          hintStyle: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontSize: isWeb ? 13 : null),
          
          suffixIcon:
              widget.isPassword
                  ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.zfontColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                  : null,
        ),
        validator:
            widget.validator ??
            (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty) {
                return '${widget.label} cannot be empty or just spaces';
              }
              if (widget.keyboardType == TextInputType.emailAddress &&
                  !RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  ).hasMatch(value)) {
                return 'Enter a valid email';
              }
              if (widget.keyboardType == TextInputType.number &&
                  double.tryParse(value) == null) {
                return 'Enter a valid number';
              }
              return null;
            },
      ),
    );
  }
}
