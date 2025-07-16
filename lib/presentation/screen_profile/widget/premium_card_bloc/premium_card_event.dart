part of 'premium_card_bloc.dart';

abstract class PremiumCardEvent extends Equatable {
  const PremiumCardEvent();

  @override
  List<Object> get props => [];
}

class StartTextAnimation extends PremiumCardEvent {
  final List<String> lines;

  const StartTextAnimation(this.lines);

  @override
  List<Object> get props => [lines];
}

class ChangeText extends PremiumCardEvent {
  const ChangeText();
}