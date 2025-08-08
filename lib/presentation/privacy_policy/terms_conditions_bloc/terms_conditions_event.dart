part of 'terms_conditions_bloc.dart';

sealed class TermsEvent extends Equatable {
  const TermsEvent();

  @override
  List<Object> get props => [];
}

class LoadTermsEvent extends TermsEvent {}