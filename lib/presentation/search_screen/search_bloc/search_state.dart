part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchLoaded extends SearchState {
  final List<AdWithUserModel> ads;
  final SearchFilter currentFilter;

  const SearchLoaded(this.ads, this.currentFilter);

  @override
  List<Object> get props => [ads, currentFilter];
}

final class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}