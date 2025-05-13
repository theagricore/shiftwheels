import 'package:flutter/material.dart';

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
  bool _showLabel = true;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        _showLabel = widget.controller.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _hasFocus = hasFocus;
        });
      },
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? _obscureText : false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLines: widget.multiline ? null : 1, 
        minLines: widget.multiline ? 4 : null, 
        decoration: InputDecoration(
          labelStyle: Theme.of(context).textTheme.titleSmall,
          hintStyle: Theme.of(context).textTheme.titleSmall,
          labelText: !_hasFocus && _showLabel ? widget.label : null,
          hintText: _hasFocus || !_showLabel ? widget.label : null,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
        validator: widget.validator ??
            (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty) {
                return '${widget.label} cannot be empty or just spaces';
              }
              if (widget.keyboardType == TextInputType.emailAddress &&
                  !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
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