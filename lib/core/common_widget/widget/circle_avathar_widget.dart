import 'dart:io';

import 'package:flutter/material.dart';

class CircleAvatarWidget extends StatelessWidget {
  final String pickedimage;
  final double radius;

  const CircleAvatarWidget({
    super.key,
    required this.pickedimage,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: pickedimage.isEmpty
          ? null
          : FileImage(File(pickedimage)),
      child: pickedimage.isEmpty
          ? Icon(Icons.person, size: radius)
          : null, 
    );
  }
}