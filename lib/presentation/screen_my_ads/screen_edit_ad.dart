import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/text_form_feald_widget.dart';
import 'package:shiftwheels/core/common_widget/widget/bottom_sheet_list/app_bottom_sheet.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/common_widget/widget/bottom_sheet_list/drop_down_sheet.dart';
import 'package:shiftwheels/core/common_widget/widget/edit_image_widget.dart';
import 'package:shiftwheels/core/common_widget/widget/list_widget.dart';
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
              BlocProvider(create: (_) => GetImagesBloc()..add(SetInitialImages(imagePaths))),
              BlocProvider(
                create: (_) => SeatTypeBloc()..add(ChangeTransmissionTypeEvent(widget.ad.transmissionType)),
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
          child: ListWidget(
            text: selectedBrand?.brandName ?? widget.ad.brand,
          ),
        );
      },
    );
  }

  Widget _buildModelBottomSheet() {
    return BlocBuilder<AddPostBloc, AddPostState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (selectedBrand == null) return;

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
          child: ListWidget(
            text: selectedModel ?? widget.ad.model,
          ),
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
          child: ListWidget(
            text: selectedFuel?.fuels ?? widget.ad.fuelType,
          ),
        );
      },
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
      final transmissionType = context.read<SeatTypeBloc>().state.transmissionType;

      if (year == null || kmDriven == null || noOfOwners == null || price == null) {
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

