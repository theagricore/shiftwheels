import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shiftwheels/data/add_post/data_source/pdf_service.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/data/add_post/models/comparison_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/compare_cars_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/delete_comparisons_usecase';
import 'package:shiftwheels/domain/add_post/usecase/get_comparison_cars_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_saved_comparisons_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/save_comparison_usecase.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

part 'compare_event.dart';
part 'compare_state.dart';

class CompareBloc extends Bloc<CompareEvent, CompareState> {
  final CompareCarsUseCase compareCarsUseCase;
  final PdfService pdfService;
  final SaveComparisonUseCase saveComparisonUseCase;
  final GetSavedComparisonsUseCase getSavedComparisonsUseCase;
  final GetComparisonCarsUseCase getComparisonCarsUseCase;
  final DeleteComparisonUseCase deleteComparisonUseCase;
  CompareBloc({
    CompareCarsUseCase? compareCarsUseCase,
    PdfService? pdfService,
    SaveComparisonUseCase? saveComparisonUseCase,
    GetSavedComparisonsUseCase? getSavedComparisonsUseCase,
    GetComparisonCarsUseCase? getComparisonCarsUseCase,
    DeleteComparisonUseCase? deleteComparisonUseCase,
  }) : compareCarsUseCase = compareCarsUseCase ?? sl<CompareCarsUseCase>(),
       pdfService = pdfService ?? sl<PdfService>(),
       saveComparisonUseCase =
           saveComparisonUseCase ?? sl<SaveComparisonUseCase>(),
       getSavedComparisonsUseCase =
           getSavedComparisonsUseCase ?? sl<GetSavedComparisonsUseCase>(),
       getComparisonCarsUseCase =
           getComparisonCarsUseCase ?? sl<GetComparisonCarsUseCase>(),
       deleteComparisonUseCase =
           deleteComparisonUseCase ?? sl<DeleteComparisonUseCase>(),

       super(CompareInitial()) {
    on<LoadFavoritesForComparison>(_onLoadFavorites);
    on<SelectCarForComparison>(_onSelectCar);
    on<GenerateAndSharePdf>(_onGenerateAndSharePdf);
    on<SaveComparison>(_onSaveComparison);
    on<LoadSavedComparisons>(_onLoadSavedComparisons);
    on<LoadComparisonCars>(_onLoadComparisonCars);
    on<DeleteComparison>(_onDeleteComparison);
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
      List<AdWithUserModel> updatedSelectedCars = List.from(
        currentState.selectedCars,
      );

      if (event.isSelected) {
        if (updatedSelectedCars.length < 2 &&
            !updatedSelectedCars.contains(event.car)) {
          updatedSelectedCars.add(event.car);
        }
      } else {
        updatedSelectedCars.removeWhere((car) => car.ad.id == event.car.ad.id);
      }

      emit(
        FavoritesLoadedForComparison(
          currentState.favorites,
          selectedCars: updatedSelectedCars,
        ),
      );
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
      final filePath = await pdfService.generateComparisonPdf(
        event.selectedCars,
      );
      await pdfService.sharePdf(filePath);
      emit(PdfGenerated(filePath));
    } catch (e) {
      emit(CompareError('Failed to generate or share PDF: ${e.toString()}'));
    }
  }

  Future<void> _onSaveComparison(
    SaveComparison event,
    Emitter<CompareState> emit,
  ) async {
    if (event.selectedCars.length != 2) {
      emit(const CompareError('Please select exactly two cars to save'));
      return;
    }

    emit(CompareLoading());
    final carIds = event.selectedCars.map((car) => car.ad.id!).toList();

    final result = await saveComparisonUseCase.call(
      param: {'userId': event.userId, 'carIds': carIds},
    );

    result.fold(
      (error) => emit(CompareError(error)),
      (success) => emit(ComparisonSaved()),
    );
  }

  Future<void> _onLoadSavedComparisons(
    LoadSavedComparisons event,
    Emitter<CompareState> emit,
  ) async {
    emit(CompareLoading());
    final result = await getSavedComparisonsUseCase.call(param: event.userId);

    result.fold(
      (error) => emit(CompareError(error)),
      (comparisons) => emit(SavedComparisonsLoaded(comparisons)),
    );
  }

  Future<void> _onLoadComparisonCars(
    LoadComparisonCars event,
    Emitter<CompareState> emit,
  ) async {
    emit(CompareLoading());
    final result = await getComparisonCarsUseCase.call(param: event.carIds);

    result.fold((error) => emit(CompareError(error)), (cars) {
      if (cars.length == 2) {
        emit(ComparisonCarsLoaded(cars));
      } else {
        emit(const CompareError('Could not load both cars for comparison'));
      }
    });
  }

  Future<void> _onDeleteComparison(
    DeleteComparison event,
    Emitter<CompareState> emit,
  ) async {
    emit(CompareLoading());
    final result = await deleteComparisonUseCase.call(
      param: event.comparisonId,
    );

    result.fold((error) => emit(CompareError(error)), (_) {
      emit(ComparisonDeleted('Comparison deleted successfully'));
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      add(LoadSavedComparisons(userId));
    });
  }
}
