import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shiftwheels/data/add_post/data_source/pdf_service.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/compare_cars_usecase.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

part 'compare_event.dart';
part 'compare_state.dart';

class CompareBloc extends Bloc<CompareEvent, CompareState> {
  final CompareCarsUseCase compareCarsUseCase;
  final PdfService pdfService;

  CompareBloc({CompareCarsUseCase? compareCarsUseCase, PdfService? pdfService})
      : compareCarsUseCase = compareCarsUseCase ?? sl<CompareCarsUseCase>(),
        pdfService = pdfService ?? sl<PdfService>(),
        super(CompareInitial()) {
    on<LoadFavoritesForComparison>(_onLoadFavorites);
    on<SelectCarForComparison>(_onSelectCar);
    on<GenerateAndSharePdf>(_onGenerateAndSharePdf);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesForComparison event,
    Emitter<CompareState> emit,
  ) async {
    emit(CompareLoading());
    final result = await compareCarsUseCase.call(param: event.userId);

    result.fold(
      (error) => emit(CompareError(error)),
      (favorites) => emit(FavoritesLoadedForComparison(favorites)),
    );
  }

  Future<void> _onSelectCar(
    SelectCarForComparison event,
    Emitter<CompareState> emit,
  ) async {
    if (state is FavoritesLoadedForComparison) {
      final currentState = state as FavoritesLoadedForComparison;
      List<AdWithUserModel> updatedSelectedCars = List.from(currentState.selectedCars);

      if (event.isSelected) {
        if (updatedSelectedCars.length < 2 && !updatedSelectedCars.contains(event.car)) {
          updatedSelectedCars.add(event.car);
        }
      } else {
        updatedSelectedCars.removeWhere((car) => car.ad.id == event.car.ad.id);
      }

      emit(FavoritesLoadedForComparison(currentState.favorites, selectedCars: updatedSelectedCars));
    }
  }

  Future<void> _onGenerateAndSharePdf(
    GenerateAndSharePdf event,
    Emitter<CompareState> emit,
  ) async {
    if (event.selectedCars.length != 2) {
      emit(const CompareError('Please select exactly two cars to compare'));
      return;
    }

    emit(CompareLoading());
    try {
      final filePath = await pdfService.generateComparisonPdf(event.selectedCars);
      await pdfService.sharePdf(filePath);
      emit(PdfGenerated(filePath));
    } catch (e) {
      emit(CompareError('Failed to generate or share PDF: ${e.toString()}'));
    }
  }
}