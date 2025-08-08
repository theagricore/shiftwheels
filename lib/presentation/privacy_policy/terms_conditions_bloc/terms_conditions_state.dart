part of 'terms_conditions_bloc.dart';

sealed class TermsState extends Equatable {
  const TermsState();
  
  @override
  List<Object> get props => [];
}

class TermsInitial extends TermsState {}

class TermsLoading extends TermsState {}

class TermsLoaded extends TermsState {
  final String content;

  const TermsLoaded(this.content);

  @override
  List<Object> get props => [content];
}

class TermsError extends TermsState {
  final String message;

  const TermsError(this.message);

  @override
  List<Object> get props => [message];
}