import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'premium_card_event.dart';
part 'premium_card_state.dart';

class PremiumCardBloc extends Bloc<PremiumCardEvent, PremiumCardState> {
  PremiumCardBloc() : super(PremiumCardInitial()) {
    on<StartTextAnimation>(_onStartTextAnimation);
    on<ChangeText>(_onChangeText);
  }

  Timer? _timer;
  int _currentIndex = 0;
  List<String> _lines = [];

  Future<void> _onStartTextAnimation(
    StartTextAnimation event,
    Emitter<PremiumCardState> emit,
  ) async {
    _lines = event.lines;
    _currentIndex = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      add(ChangeText());
    });
    emit(PremiumCardTextChanged(_currentIndex, _lines[_currentIndex]));
  }

  Future<void> _onChangeText(
    ChangeText event,
    Emitter<PremiumCardState> emit,
  ) async {
    _currentIndex = (_currentIndex + 1) % _lines.length;
    emit(PremiumCardTextChanged(_currentIndex, _lines[_currentIndex]));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}