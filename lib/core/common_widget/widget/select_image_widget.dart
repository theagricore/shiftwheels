import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class SelectImagesWidget extends StatelessWidget {
  const SelectImagesWidget({
    super.key,
    required this.onLeft,
    required this.onRight,
  });

  final VoidCallback onLeft;
  final VoidCallback onRight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: onLeft,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.zfontColor,
                width: 2.0,
              ),
            ),
            width: 150,
            height: 100,
            child:  Padding(
              padding: EdgeInsets.only(top: 13),
              child: Column(
                children: [
                  Icon(
                    Icons.camera_alt_sharp,
                    color: AppColors.zfontColor,
                    size: 50,
                  ),
                  Text("TAKE A PICTURE",style: Theme.of(context).textTheme.displaySmall,),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: onRight,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.zfontColor,
                width: 2.0,
              ),
            ),
            width: 150,
            height: 100,
            child:  Padding(
              padding: EdgeInsets.only(top: 13),
              child: Column(
                children: [
                  Icon(
                    Icons.folder_outlined,
                    color: AppColors.zfontColor,
                    size: 50,
                  ),
                  Text("FOLDER",style: Theme.of(context).textTheme.displaySmall,),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}