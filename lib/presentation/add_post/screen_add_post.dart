import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/text_form_feald_widget.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_drop_down_list.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/data/add_post/models/brand_model.dart';
import 'package:shiftwheels/data/add_post/models/fuels_model.dart';
import 'package:shiftwheels/presentation/add_post/add_post_bloc/add_post_bloc.dart';
import 'package:shiftwheels/presentation/add_post/get_fuels_bloc/get_fuels_bloc.dart';

class ScreenAddPost extends StatefulWidget {
  const ScreenAddPost({super.key});

  @override
  State<ScreenAddPost> createState() => _ScreenAddPostState();
}

class _ScreenAddPostState extends State<ScreenAddPost> {
  BrandModel? selectedBrand;
  String? selectedModel;
  FuelsModel? selectedFuel;
  bool _brandsLoading = false;
  bool _modelsLoading = false;
  bool _fuelsLoading = false;

  final TextEditingController yearController = TextEditingController();
  final TextEditingController kmController = TextEditingController();
  final TextEditingController noOfOwnersController = TextEditingController();
  final TextEditingController discribeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(title: const Text("Include Some Details")),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AddPostBloc, AddPostState>(
            listener: (context, state) {
              if (state is BrandsError || state is ModelsError) {
                BasicSnackbar(
                  message: state is BrandsError 
                    ? state.message 
                    : (state as ModelsError).message,
                  backgroundColor: Colors.red,
                ).show(context);
              }
            },
          ),
          BlocListener<GetFuelsBloc, GetFuelsState>(
            listener: (context, state) {
              if (state is GetFuelsError) {
                BasicSnackbar(
                  message: state.message,
                  backgroundColor: Colors.red,
                ).show(context);
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            child: Column(
              children: [
                BlocBuilder<AddPostBloc, AddPostState>(
                  builder: (context, state) {
                    _brandsLoading = state is BrandsLoading;
                    return _buildBrandDropdown(state);
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<AddPostBloc, AddPostState>(
                  builder: (context, state) {
                    _modelsLoading = state is ModelsLoading;
                    return _buildModelDropdown(state);
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<GetFuelsBloc, GetFuelsState>(
                  builder: (context, state) {
                    _fuelsLoading = state is GetFuelsLoading;
                    return _buildFuelsDropdown(state);
                  },
                ),
                const SizedBox(height: 20),
                TextFormFieldWidget(label: "Year*", controller: yearController),
                const SizedBox(height: 20),
                TextFormFieldWidget(label: "KM driven*", controller: kmController),
                const SizedBox(height: 20),
                TextFormFieldWidget(label: "No.of Owners*", controller: noOfOwnersController),
                const SizedBox(height: 20),
                TextFormFieldWidget(label: "Describe what you are selling*", controller: discribeController),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandDropdown(AddPostState state) {
    List<BrandModel> brands = [];
    if (state is BrandsLoaded) {
      brands = state.brands;
    } else if (state is BrandsLoading && state.previousBrands != null) {
      brands = state.previousBrands!;
    }

    return BasicDropDownList<BrandModel>(
      hintText: "Select Brand",
      items: brands,
      value: selectedBrand,
      displayItem: (brand) => brand.brandName ?? 'Unknown Brand',
      onChanged: (BrandModel? newValue) {
        if (newValue != null) {
          setState(() {
            selectedBrand = newValue;
            selectedModel = null;
          });
          context.read<AddPostBloc>().add(FetchModelsEvent(newValue.id!));
        }
      },
      enabled: !_brandsLoading,
      isLoading: _brandsLoading,
    );
  }

  Widget _buildModelDropdown(AddPostState state) {
    List<String> models = [];
    if (state is ModelsLoaded) {
      models = state.models;
    } else if (state is ModelsLoading && state.previousModels != null) {
      models = state.previousModels!;
    }

    return BasicDropDownList<String>(
      hintText: "Select Model",
      items: models,
      value: selectedModel,
      displayItem: (model) => model,
      onChanged: (String? newValue) {
        setState(() {
          selectedModel = newValue;
        });
      },
      enabled: !_modelsLoading && selectedBrand != null,
      isLoading: _modelsLoading,
    );
  }

  Widget _buildFuelsDropdown(GetFuelsState state) {
    List<FuelsModel> fuels = [];
    if (state is GetFuelsLoaded) {
      fuels = state.fuels;
    } 
    return BasicDropDownList<FuelsModel>(
      hintText: "Select Fuel Type",
      items: fuels,
      value: selectedFuel,
      displayItem: (fuel) => fuel.fuels ?? 'Unknown Fuel',
      onChanged: (FuelsModel? newValue) {
        setState(() {
          selectedFuel = newValue;
        });
      },
      enabled: !_fuelsLoading,
      isLoading: _fuelsLoading,
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<AddPostBloc>().add(FetchBrandsEvent());
    context.read<GetFuelsBloc>().add(FetchFuels());
  }
}