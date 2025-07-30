import 'package:flutter/material.dart';

class AppBottomSheet {
  static Future<void> display(BuildContext context, Widget widget, {bool isWeb = false}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: isWeb 
          ? BoxConstraints(maxWidth: 600) 
          : null,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: widget,
        );
      },
    );
  }
}