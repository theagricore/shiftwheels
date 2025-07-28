part of 'compare_bloc.dart';

sealed class CompareEvent extends Equatable {
  const CompareEvent();

  @override
  List<Object> get props => [];
}

class LoadFavoritesForComparison extends CompareEvent {
  final String userId;

  const LoadFavoritesForComparison(this.userId);

  @override
  List<Object> get props => [userId];
}

class SelectCarForComparison extends CompareEvent {
  final AdWithUserModel car;
  final bool isSelected;

  const SelectCarForComparison(this.car, this.isSelected);

  @override
  List<Object> get props => [car, isSelected];
}

class GenerateAndSharePdf extends CompareEvent {
  final List<AdWithUserModel> selectedCars;

  const GenerateAndSharePdf(this.selectedCars);

  @override
  List<Object> get props => [selectedCars];
}

class SaveComparison extends CompareEvent {
  final String userId;
  final List<AdWithUserModel> selectedCars;

  const SaveComparison(this.userId, this.selectedCars);

  @override
  List<Object> get props => [userId, selectedCars];
}

class LoadSavedComparisons extends CompareEvent {
  final String userId;

  const LoadSavedComparisons(this.userId);

  @override
  List<Object> get props => [userId];
}

class LoadComparisonCars extends CompareEvent {
  final List<String> carIds;

  const LoadComparisonCars(this.carIds);

  @override
  List<Object> get props => [carIds];
}

class DeleteComparison extends CompareEvent {
  final String comparisonId;

  const DeleteComparison(this.comparisonId);

  @override
  List<Object> get props => [comparisonId];
}
