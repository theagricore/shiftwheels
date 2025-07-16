import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:shiftwheels/presentation/screen_profile/profile_image_bloc/profile_image_bloc.dart';

class FullImageDialog extends StatelessWidget {
  final File image;

  const FullImageDialog({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          SizedBox.expand(
            child: Image.file(image, fit: BoxFit.cover),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.close, size: 30, color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<ProfileImageBloc>().add(
                          ConfirmProfileImageEvent(image),
                        );
                    Navigator.of(context).pop();
                  },
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.check, size: 30, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
