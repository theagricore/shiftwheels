import 'package:flutter/material.dart';

class BasicSnackbar extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Icon? icon;
  final TextStyle? textStyle;

  const BasicSnackbar({
    super.key,
    required this.message,
    required this.backgroundColor,
    this.icon,
    this.textStyle,
  });

  void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) icon!, 
            SizedBox(width: icon != null ? 8.0 : 0), 
            Expanded(
              child: Text(
                message,
                style: textStyle ??
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), 
        ),
        margin: EdgeInsets.all(16), 
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}