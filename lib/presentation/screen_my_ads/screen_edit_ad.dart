import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/text_form_feald_widget.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/common_widget/widget/bottom_sheet_list/bottom_sheet_selector.dart';
import 'package:shiftwheels/core/common_widget/widget/edit_image_widget.dart';
import 'package:shiftwheels/core/common_widget/widget/transmission_type_selecter.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/add_post/models/brand_model.dart';
import 'package:shiftwheels/data/add_post/models/fuels_model.dart';
import 'package:shiftwheels/presentation/add_post/add_post_bloc/add_post_bloc.dart';
import 'package:shiftwheels/presentation/add_post/get_fuels_bloc/get_fuels_bloc.dart';
import 'package:shiftwheels/presentation/add_post/get_images_bloc/get_images_bloc.dart';
import 'package:shiftwheels/presentation/add_post/seat_type_bloc/seat_type_bloc.dart';
import 'package:shiftwheels/presentation/add_post/seat_type_bloc/seat_type_state.dart';
import 'package:shiftwheels/presentation/screen_my_ads/update_ad_bloc/update_ad_bloc.dart';

class ScreenEditAd extends StatefulWidget {
  final AdsModel ad;

  const ScreenEditAd({super.key, required this.ad});

  @override
  State<ScreenEditAd> createState() => _ScreenEditAdState();
}

class _ScreenEditAdState extends State<ScreenEditAd> {
  BrandModel? selectedBrand;
  String? selectedModel;
  FuelsModel? selectedFuel;
  List<String> imagePaths = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController kmController = TextEditingController();
  final TextEditingController noOfOwnersController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    yearController.text = widget.ad.year.toString();
    kmController.text = widget.ad.kmDriven.toString();
    noOfOwnersController.text = widget.ad.noOfOwners.toString();
    descriptionController.text = widget.ad.description;
    priceController.text = widget.ad.price.toStringAsFixed(2);
    imagePaths = widget.ad.imageUrls;
  }

  @override
  void dispose() {
    yearController.dispose();
    kmController.dispose();
    noOfOwnersController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          "Edit Your Ad",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: BlocProvider.of<AddPostBloc>(context)),
              BlocProvider.value(value: BlocProvider.of<GetFuelsBloc>(context)),
              BlocProvider(
                create:
                    (_) => GetImagesBloc()..add(SetInitialImages(imagePaths)),
              ),
              BlocProvider(
                create:
                    (_) =>
                        SeatTypeBloc()..add(
                          ChangeTransmissionTypeEvent(
                            widget.ad.transmissionType,
                          ),
                        ),
              ),
            ],
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
                _buildDescriptionWidget(),
                const SizedBox(height: 20),
                _buildImagesWidget(),
                const SizedBox(height: 20),
                _buildPriceWidget(),
                const SizedBox(height: 30),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildYearWidget() {
    return TextFormFieldWidget(
      label: "Year*",
      controller: yearController,
      keyboardType: TextInputType.number,
    );
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

  Widget _buildDescriptionWidget() {
    return TextFormFieldWidget(
      label: "Description*",
      controller: descriptionController,
      multiline: true,
      keyboardType: TextInputType.multiline,
    );
  }

  Widget _buildPriceWidget() {
    return TextFormFieldWidget(
      label: "Price*",
      controller: priceController,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildImagesWidget() {
    return BlocBuilder<GetImagesBloc, GetImagesState>(
      builder: (context, state) {
        if (state is ImagesSelectedState) {
          imagePaths = state.imagePaths;
        }

        return EditImageWidget(imagePaths: imagePaths);
      },
    );
  }

  Widget _buildSaveButton() {
    return BlocConsumer<UpdateAdBloc, UpdateAdState>(
      listener: (context, state) {
        if (state is AdUpdated) {
          BasicSnackbar(
            message: "Ad updated successfully",
            backgroundColor: Colors.green,
          ).show(context);
          Navigator.pop(context);
        } else if (state is UpdateAdError) {
          BasicSnackbar(
            message: state.message,
            backgroundColor: Colors.red,
          ).show(context);
        }
      },
      builder: (context, state) {
        return BasicElevatedAppButton(
          onPressed: () => _saveChanges(context),
          isLoading: state is UpdateAdLoading,
          title: "Save Changes",
        );
      },
    );
  }

  void _saveChanges(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final year = int.tryParse(yearController.text);
      final kmDriven = int.tryParse(kmController.text);
      final noOfOwners = int.tryParse(noOfOwnersController.text);
      final price = double.tryParse(priceController.text);
      final transmissionType =
          context.read<SeatTypeBloc>().state.transmissionType;

      if (year == null ||
          kmDriven == null ||
          noOfOwners == null ||
          price == null) {
        BasicSnackbar(
          message: 'Please fill all required fields with valid values',
          backgroundColor: Colors.red,
        ).show(context);
        return;
      }

      final updatedAd = widget.ad.copyWith(
        brand: selectedBrand?.brandName ?? widget.ad.brand,
        model: selectedModel ?? widget.ad.model,
        fuelType: selectedFuel?.fuels ?? widget.ad.fuelType,
        transmissionType: transmissionType,
        year: year,
        kmDriven: kmDriven,
        noOfOwners: noOfOwners,
        description: descriptionController.text,
        imageUrls: imagePaths,
        price: price,
      );

      context.read<UpdateAdBloc>().add(UpdateAd(updatedAd));
    }
  }
}
