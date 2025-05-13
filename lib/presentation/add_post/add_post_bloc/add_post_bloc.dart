
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shiftwheels/data/add_post/models/brand_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_brand_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_models_usecase.dart';

part 'add_post_event.dart';
part 'add_post_state.dart';

class AddPostBloc extends Bloc<AddPostEvent, AddPostState> {
  final GetBrandUsecase _getBrandUsecase;
  final GetModelsUsecase _getModelsUsecase;

  AddPostBloc(
    this._getBrandUsecase,
    this._getModelsUsecase,
  ) : super(AddPostInitial()) {
    on<FetchBrandsEvent>(_onFetchBrands);
    on<FetchModelsEvent>(_onFetchModels);
  }

  Future<void> _onFetchBrands(
    FetchBrandsEvent event,
    Emitter<AddPostState> emit,
  ) async {
    emit(BrandsLoading(previousBrands: state is BrandsLoaded ? (state as BrandsLoaded).brands : null));
    final result = await _getBrandUsecase.call();
    result.fold(
      (error) => emit(BrandsError(error)),
      (brands) => emit(BrandsLoaded(brands)),
    );
  }

  Future<void> _onFetchModels(
    FetchModelsEvent event,
    Emitter<AddPostState> emit,
  ) async {
    emit(ModelsLoading(previousModels: state is ModelsLoaded ? (state as ModelsLoaded).models : null));
    final result = await _getModelsUsecase.call(param: event.brandId);
    result.fold(
      (error) => emit(ModelsError(error)),
      (models) => emit(ModelsLoaded(models)),
    );
  }
}