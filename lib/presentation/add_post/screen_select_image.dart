import 'package:flutter/material.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/common_widget/widget/select_image_widget.dart';
import 'package:shiftwheels/core/config/helper/navigator/app_navigator.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';
import 'package:shiftwheels/presentation/add_post/screen_price.dart';

class ScreenSelectImage extends StatelessWidget {
  const ScreenSelectImage({super.key, required this.location});
  final LocationModel location;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          "Select the Image",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SelectImagesWidget(onLeft: () {}, onRight: () {}),
              const Spacer(),
              BasicElevatedAppButton(
                onPressed: () {
                  AppNavigator.push(context, ScreenPrice());
                },
                title: "Continue",
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
