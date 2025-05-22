import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/text_form_feald_widget.dart';
import 'package:shiftwheels/core/common_widget/widget/app_bottom_sheet.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/common_widget/widget/drop_down_sheet.dart';
import 'package:shiftwheels/core/common_widget/widget/list_widget.dart';
import 'package:shiftwheels/core/common_widget/widget/seat_type_selector.dart';
import 'package:shiftwheels/core/config/helper/navigator/app_navigator.dart';
import 'package:shiftwheels/data/add_post/models/brand_model.dart';
import 'package:shiftwheels/data/add_post/models/fuels_model.dart';
import 'package:shiftwheels/presentation/add_post/add_post_bloc/add_post_bloc.dart';
import 'package:shiftwheels/presentation/add_post/get_fuels_bloc/get_fuels_bloc.dart';
import 'package:shiftwheels/presentation/add_post/screen_select_location.dart';
import 'package:shiftwheels/presentation/add_post/seat_type_bloc/seat_type_bloc.dart';

class ScreenAddPost extends StatefulWidget {
  const ScreenAddPost({super.key});

  @override
  State<ScreenAddPost> createState() => _ScreenAddPostState();
}

class _ScreenAddPostState extends State<ScreenAddPost> {
  BrandModel? selectedBrand;
  String? selectedModel;
  FuelsModel? selectedFuel;
  int? selectedSeatCount;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController kmController = TextEditingController();
  final TextEditingController noOfOwnersController = TextEditingController();
  final TextEditingController discribeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SeatTypeBloc(),
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            "Include Some Details",
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildBrandBottomSheet(),
                const SizedBox(height: 20),
                _buildModelBottomSheet(),
                const SizedBox(height: 20),
                _buildFuelsBottomSheet(),
                const SizedBox(height: 20),
                _buildToggleButton(),
                const SizedBox(height: 20),
                _buildYearWidget(),
                const SizedBox(height: 20),
                _buildKmDrivenWidget(),
                const SizedBox(height: 20),
                _buildNoOfOwnersWidget(),
                const SizedBox(height: 20),
                _buildDiscribtionWidget(),
                const SizedBox(height: 20),
                _buildContinueWidget(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return SeatTypeSelector(
      onSeatTypeSelected: (seatCount) {
        setState(() {
          selectedSeatCount = seatCount;
        });
      },
    );
  }

  Widget _buildBrandBottomSheet() {
    return BlocBuilder<AddPostBloc, AddPostState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<AddPostBloc>().add(FetchBrandsEvent());
            AppBottomSheet.display(
              context,
              BlocProvider.value(
                value: BlocProvider.of<AddPostBloc>(context),
                child: BlocBuilder<AddPostBloc, AddPostState>(
                  builder: (context, state) {
                    final sheetIsLoading = state is BrandsLoading;
                    final List<BrandModel> sheetBrands =
                        state is BrandsLoaded ? state.brands : [];
                    final sheetError =
                        state is BrandsError ? state.message : null;

                    return DropdownSheet<BrandModel>(
                      title: 'Select Brand',
                      items: sheetBrands,
                      itemText:
                          (BrandModel brand) => brand.brandName ?? 'Unknown',
                      onSelected: (BrandModel brand) {
                        setState(() {
                          selectedBrand = brand;
                          selectedModel = null;
                        });
                        context.read<AddPostBloc>().add(
                          FetchModelsEvent(brand.id!),
                        );
                      },
                      isLoading: sheetIsLoading,
                      error: sheetError,
                    );
                  },
                ),
              ),
            );
          },
          child: ListWidget(text: selectedBrand?.brandName ?? 'Select Brand*'),
        );
      },
    );
  }

  Widget _buildModelBottomSheet() {
    return BlocBuilder<AddPostBloc, AddPostState>(
      builder: (context, state) {
        final isDisabled = selectedBrand == null;

        return GestureDetector(
          onTap: () {
            if (isDisabled) return;

            context.read<AddPostBloc>().add(
              FetchModelsEvent(selectedBrand!.id!),
            );

            AppBottomSheet.display(
              context,
              BlocProvider.value(
                value: BlocProvider.of<AddPostBloc>(context),
                child: BlocBuilder<AddPostBloc, AddPostState>(
                  builder: (context, state) {
                    final sheetIsLoading = state is ModelsLoading;
                    final List<String> sheetModels =
                        state is ModelsLoaded ? state.models : [];
                    final sheetError =
                        state is ModelsError ? state.message : null;

                    return DropdownSheet<String>(
                      title: 'Select Model',
                      items: sheetModels,
                      itemText: (String model) => model,
                      onSelected: (String model) {
                        setState(() {
                          selectedModel = model;
                        });
                      },
                      isLoading: sheetIsLoading,
                      error: sheetError,
                    );
                  },
                ),
              ),
            );
          },
          child: ListWidget(text: selectedModel ?? 'Select Model*'),
        );
      },
    );
  }

  Widget _buildFuelsBottomSheet() {
    return BlocBuilder<GetFuelsBloc, GetFuelsState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<GetFuelsBloc>().add(FetchFuels());

            AppBottomSheet.display(
              context,
              BlocProvider.value(
                value: BlocProvider.of<GetFuelsBloc>(context),
                child: BlocBuilder<GetFuelsBloc, GetFuelsState>(
                  builder: (context, state) {
                    final sheetIsLoading = state is GetFuelsLoading;
                    final List<FuelsModel> sheetFuels =
                        state is GetFuelsLoaded ? state.fuels : [];
                    final sheetError =
                        state is GetFuelsError ? state.message : null;

                    return DropdownSheet<FuelsModel>(
                      title: 'Select Fuel Type',
                      items: sheetFuels,
                      itemText: (FuelsModel fuel) => fuel.fuels ?? 'Unknown',
                      onSelected: (FuelsModel fuel) {
                        setState(() {
                          selectedFuel = fuel;
                        });
                      },
                      isLoading: sheetIsLoading,
                      error: sheetError,
                    );
                  },
                ),
              ),
            );
          },
          child: ListWidget(text: selectedFuel?.fuels ?? 'Select Fuel Type*'),
        );
      },
    );
  }

  Widget _buildYearWidget() {
    return TextFormFieldWidget(label: "Year*", controller: yearController,keyboardType: TextInputType.number,);
  }

  Widget _buildKmDrivenWidget() {
    return TextFormFieldWidget(label: "KM driven*", controller: kmController,keyboardType: TextInputType.number);
  }

  Widget _buildNoOfOwnersWidget() {
    return TextFormFieldWidget(
      label: "No.of Owners*",
      controller: noOfOwnersController,
      keyboardType: TextInputType.number
    );
  }

  Widget _buildDiscribtionWidget() {
    return TextFormFieldWidget(
      label: "Describe what you are selling*",
      controller: discribeController,
      multiline: true,
    );
  }

  Widget _buildContinueWidget(BuildContext context) {
    return BasicElevatedAppButton(
      onPressed: () => _validateAndContinue(context),
      title: "Continue",
    );
  }

  void _validateAndContinue(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (selectedBrand == null ||
          selectedModel == null ||
          selectedFuel == Null ||
          selectedSeatCount == null) {
        BasicSnackbar(
          message: 'Please fill all required fields',
          backgroundColor: Colors.red,
        );
        return;
      }
      final year = int.tryParse(yearController.text);
      final kmDriven = int.tryParse(kmController.text);
      final noofOwners = int.tryParse(noOfOwnersController.text);

      if (year == null || kmDriven == null || noofOwners == null) {
        BasicSnackbar(
          message: 'Please fill all required fields',
          backgroundColor: Colors.red,
        );
        return;
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      BasicSnackbar(
        message: 'Please login to post an ad',
        backgroundColor: Colors.red,
      );
      AppNavigator.push(
        context,
        ScreenSelectLocation(
          userId: currentUser!.uid,
          brand: selectedBrand!.brandName!,
          model: selectedModel!,
          fuelType: selectedFuel!.fuels!,
          seatCount: selectedSeatCount!,
          year: year,
          kmDriven: kmDriven,
          noOfOwners: noofOwners,
          description: discribeController.text,
        ),
      );
    }
  }
}
