part of 'premium_card_bloc.dart';

abstract class PremiumCardState extends Equatable {
  const PremiumCardState();

  @override
  List<Object> get props => [];
}

class PremiumCardInitial extends PremiumCardState {}

class PremiumCardTextChanged extends PremiumCardState {
  final int currentIndex;
  final String currentText;

  const PremiumCardTextChanged(this.currentIndex, this.currentText);

  @override
  List<Object> get props => [currentIndex, currentText];
}