import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/text_form_feald_widget.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/common_widget/widget/bottom_sheet_list/bottom_sheet_selector.dart';
import 'package:shiftwheels/core/common_widget/widget/transmission_type_selecter.dart';
import 'package:shiftwheels/core/common_widget/widget/year_picker_widget.dart';
import 'package:shiftwheels/core/config/helper/navigator/app_navigator.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/brand_model.dart';
import 'package:shiftwheels/data/add_post/models/fuels_model.dart';
import 'package:shiftwheels/presentation/add_post/add_post_bloc/add_post_bloc.dart';
import 'package:shiftwheels/presentation/add_post/get_fuels_bloc/get_fuels_bloc.dart';
import 'package:shiftwheels/presentation/add_post/screen_select_location.dart';
import 'package:shiftwheels/presentation/add_post/seat_type_bloc/seat_type_bloc.dart';
import 'package:shiftwheels/presentation/add_post/seat_type_bloc/seat_type_state.dart';

class ScreenAddPost extends StatefulWidget {
  const ScreenAddPost({super.key});

  @override
  State<ScreenAddPost> createState() => _ScreenAddPostState();
}

class _ScreenAddPostState extends State<ScreenAddPost> {
  BrandModel? selectedBrand;
  String? selectedModel;
  FuelsModel? selectedFuel;
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
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
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
    return BlocBuilder<SeatTypeBloc, SeatTypeState>(
      builder: (context, state) {
        return TransmissionTypeSelector(
          initialType: state.transmissionType,
          onTransmissionSelected: (type) {
            context.read<SeatTypeBloc>().add(ChangeTransmissionTypeEvent(type));
          },
        );
      },
    );
  }

  Widget _buildBrandBottomSheet() {
    return BottomSheetSelector<BrandModel>(
      title: 'Select Brand',
      displayText: selectedBrand?.brandName ?? 'Select Brand*',
      onTapFetchEvent:
          (context) => context.read<AddPostBloc>().add(FetchBrandsEvent()),
      selectorBloc: context.read<AddPostBloc>(),
      itemsSelector: (state) => state is BrandsLoaded ? state.brands : [],
      itemText: (brand) => brand.brandName ?? 'Unknown',
      onItemSelected: (brand) {
        setState(() {
          selectedBrand = brand;
          selectedModel = null;
        });
        context.read<AddPostBloc>().add(FetchModelsEvent(brand.id!));
      },
      loadingSelector: (state) => state is BrandsLoading,
      errorSelector: (state) => state is BrandsError ? state.message : null,
    );
  }

  Widget _buildModelBottomSheet() {
    return BottomSheetSelector<String>(
      title: 'Select Model',
      displayText: selectedModel ?? 'Select Model*',
      isDisabled: selectedBrand == null,
      onTapFetchEvent:
          (context) => context.read<AddPostBloc>().add(
            FetchModelsEvent(selectedBrand!.id!),
          ),
      selectorBloc: context.read<AddPostBloc>(),
      itemsSelector: (state) => state is ModelsLoaded ? state.models : [],
      itemText: (model) => model,
      onItemSelected: (model) {
        setState(() {
          selectedModel = model;
        });
      },
      loadingSelector: (state) => state is ModelsLoading,
      errorSelector: (state) => state is ModelsError ? state.message : null,
    );
  }

  Widget _buildFuelsBottomSheet() {
    return BottomSheetSelector<FuelsModel>(
      title: 'Select Fuel Type',
      displayText: selectedFuel?.fuels ?? 'Select Fuel Type*',
      onTapFetchEvent:
          (context) => context.read<GetFuelsBloc>().add(FetchFuels()),
      selectorBloc: context.read<GetFuelsBloc>(),
      itemsSelector: (state) => state is GetFuelsLoaded ? state.fuels : [],
      itemText: (fuel) => fuel.fuels ?? 'Unknown',
      onItemSelected: (fuel) {
        setState(() {
          selectedFuel = fuel;
        });
      },
      loadingSelector: (state) => state is GetFuelsLoading,
      errorSelector: (state) => state is GetFuelsError ? state.message : null,
    );
  }

  Widget _buildYearWidget() {
    return YearPickerWidget(label: "Year*", controller: yearController);
  }

  Widget _buildKmDrivenWidget() {
    return TextFormFieldWidget(
      label: "KM driven*",
      controller: kmController,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildNoOfOwnersWidget() {
    return TextFormFieldWidget(
      label: "No.of Owners*",
      controller: noOfOwnersController,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDiscribtionWidget() {
    return TextFormFieldWidget(
      label: "Describe what you are selling*",
      controller: discribeController,
      multiline: true,
      keyboardType: TextInputType.multiline,
    );
  }

  Widget _buildContinueWidget(BuildContext context) {
    return BlocBuilder<SeatTypeBloc, SeatTypeState>(
      builder: (context, state) {
        return BasicElevatedAppButton(
          onPressed:
              () => _validateAndContinue(context, state.transmissionType),
          title: "Continue",
        );
      },
    );
  }

  void _validateAndContinue(BuildContext context, String transmissionType) {
    if (_formKey.currentState!.validate()) {
      if (selectedBrand == null ||
          selectedModel == null ||
          selectedFuel == null ||
          transmissionType.isEmpty) {
        BasicSnackbar(
          message: 'Please fill all required fields',
          backgroundColor: AppColors.zred,
        ).show(context);
        return;
      }
      final year = int.tryParse(yearController.text);
      final kmDriven = int.tryParse(kmController.text);
      final noofOwners = int.tryParse(noOfOwnersController.text);

      if (year == null || kmDriven == null || noofOwners == null) {
        BasicSnackbar(
          message: 'Please enter valid numbers',
          backgroundColor: AppColors.zred,
        ).show(context);
        return;
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        BasicSnackbar(
          message: 'Please login to post an ad',
          backgroundColor: AppColors.zred,
        ).show(context);
        return;
      }

      AppNavigator.push(
        context,
        ScreenSelectLocation(
          userId: currentUser.uid,
          brand: selectedBrand!.brandName!,
          model: selectedModel!,
          fuelType: selectedFuel!.fuels!,
          transmissionType: transmissionType,
          year: year,
          kmDriven: kmDriven,
          noOfOwners: noofOwners,
          description: discribeController.text,
        ),
      );
    }
  }
}
