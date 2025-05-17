import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/text_form_feald_widget.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';
import 'package:shiftwheels/presentation/add_post/post_ad_bloc/post_ad_bloc.dart';

class ScreenPrice extends StatelessWidget {
  final String userId;
  final String brand;
  final String model;
  final String fuelType;
  final int seatCount;
  final int year;
  final int kmDriven;
  final int noOfOwners;
  final String description;
  final LocationModel location;
  final List<String> imagePaths;

  ScreenPrice({
    super.key,
    required this.userId,
    required this.brand,
    required this.model,
    required this.fuelType,
    required this.seatCount,
    required this.year,
    required this.kmDriven,
    required this.noOfOwners,
    required this.description,
    required this.location,
    required this.imagePaths,
  });

  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostAdBloc, PostAdState>(
      listener: (context, state) {
        if (state is PostAdSuccess) {
          BasicSnackbar(message: "Post Uploaded Sucessfully", backgroundColor: Colors.green);
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else if (state is PostAdError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
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
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      final price = double.tryParse(value);
                      if (price == null || price <= 0) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                  ),
                  const Spacer(),
                  BlocBuilder<PostAdBloc, PostAdState>(
                    builder: (context, state) {
                      return BasicElevatedAppButton(
                        onPressed: () {
                          if (priceController.text.isEmpty) {
                            BasicSnackbar(
                              message: 'Please enter a price',
                              backgroundColor: Colors.red,
                            ).show(context);
                            return;
                          }

                          final price = double.tryParse(priceController.text);
                          if (price == null || price <= 0) {
                            BasicSnackbar(
                              message: 'Please enter a valid price',
                              backgroundColor: Colors.red,
                            ).show(context);
                            return;
                          }

                          context.read<PostAdBloc>().add(
                            SubmitAdEvent(
                              userId: userId,
                              brand: brand,
                              model: model,
                              fuelType: fuelType,
                              seatCount: seatCount,
                              year: year,
                              kmDriven: kmDriven,
                              noOfOwners: noOfOwners,
                              description: description,
                              location: location,
                              imageFiles: imagePaths,
                              price: price,
                            ),
                          );
                        },
                        isLoading: state is PostAdLoading,
                        title: "Post Ad",
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
