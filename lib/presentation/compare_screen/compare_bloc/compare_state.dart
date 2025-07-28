part of 'compare_bloc.dart';

sealed class CompareState extends Equatable {
  const CompareState();

  @override
  List<Object> get props => [];
}

class CompareInitial extends CompareState {}

class CompareLoading extends CompareState {}

class FavoritesLoadedForComparison extends CompareState {
  final List<AdWithUserModel> favorites;
  final List<AdWithUserModel> selectedCars;

  const FavoritesLoadedForComparison(
    this.favorites, {
    this.selectedCars = const [],
  });

  @override
  List<Object> get props => [favorites, selectedCars];
}

class CompareError extends CompareState {
  final String message;

  const CompareError(this.message);

  @override
  List<Object> get props => [message];
}

class PdfGenerated extends CompareState {
  final String filePath;

  const PdfGenerated(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class ComparisonSaved extends CompareState {}

class SavedComparisonsLoaded extends CompareState {
  final List<ComparisonModel> comparisons;

  const SavedComparisonsLoaded(this.comparisons);

  @override
  List<Object> get props => [comparisons];
}

class ComparisonCarsLoaded extends CompareState {
  final List<AdWithUserModel> cars;

  const ComparisonCarsLoaded(this.cars);

  @override
  List<Object> get props => [cars];
}

class ComparisonDeleted extends CompareState {
  final String message;

  const ComparisonDeleted(this.message);

  @override
  List<Object> get props => [message];
}
