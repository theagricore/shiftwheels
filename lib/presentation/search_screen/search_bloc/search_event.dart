part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

final class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

final class SearchFilterChanged extends SearchEvent {
  final SearchFilter filter;

  const SearchFilterChanged(this.filter);

  @override
  List<Object> get props => [filter];
}

final class SearchFilterCleared extends SearchEvent {
  const SearchFilterCleared();
}

final class SearchLocationChanged extends SearchEvent {
  final LocationModel location;
  final double maxDistance;

  const SearchLocationChanged(this.location, this.maxDistance);

  @override
  List<Object> get props => [location, maxDistance];
}

final class SearchInitialFetch extends SearchEvent {
  const SearchInitialFetch();
}