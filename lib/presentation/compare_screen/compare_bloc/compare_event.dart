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