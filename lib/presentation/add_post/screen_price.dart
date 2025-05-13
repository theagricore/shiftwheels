import 'package:flutter/material.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/text_form_feald_widget.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_elevated_app_button.dart';

class ScreenPrice extends StatelessWidget {
  ScreenPrice({super.key});
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          "Set a price",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            child: Column(
              children: [
                TextFormFieldWidget(
                  label: "Price*",
                  controller: priceController,
                ),
                const Spacer(),
                BasicElevatedAppButton(onPressed: () {}, title: "Continue"),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
