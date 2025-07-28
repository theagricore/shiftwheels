import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';
import 'package:shiftwheels/data/add_post/models/search_filter_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PostRepository _postRepository = sl<PostRepository>();
  SearchFilter _currentFilter = SearchFilter();

  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchFilterChanged>(_onSearchFilterChanged);
    on<SearchFilterCleared>(_onSearchFilterCleared);
    on<SearchLocationChanged>(_onSearchLocationChanged);
    on<SearchInitialFetch>(_onSearchInitialFetch);
    add(const SearchInitialFetch());
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    _currentFilter = _currentFilter.copyWith(query: event.query);
    await _performSearch(emit);
  }

  Future<void> _onSearchFilterChanged(
    SearchFilterChanged event,
    Emitter<SearchState> emit,
  ) async {
    _currentFilter = event.filter;
    await _performSearch(emit);
  }

  Future<void> _onSearchFilterCleared(
    SearchFilterCleared event,
    Emitter<SearchState> emit,
  ) async {
    _currentFilter = SearchFilter();
    await _performSearch(emit);
  }

  Future<void> _onSearchLocationChanged(
    SearchLocationChanged event,
    Emitter<SearchState> emit,
  ) async {
    _currentFilter = _currentFilter.copyWith(
      userLocation: event.location,
      maxDistanceInKm: event.maxDistance,
    );
    await _performSearch(emit);
  }

  Future<void> _onSearchInitialFetch(
    SearchInitialFetch event,
    Emitter<SearchState> emit,
  ) async {
    await _performSearch(emit);
  }

Future<void> _performSearch(Emitter<SearchState> emit) async {
  emit(SearchLoading());
  try {
    final result = await _postRepository.getActiveAdsWithUsers();
    result.fold(
      (error) => emit(SearchError(error)),
      (ads) {
        final filteredAds = SearchUtils.filterAndSortAds(
          ads: ads,
          filter: _currentFilter,
        );
        emit(SearchLoaded(filteredAds, _currentFilter));
      },
    );
  } catch (e) {
    emit(SearchError('Failed to perform search: ${e.toString()}'));
  }
}
}