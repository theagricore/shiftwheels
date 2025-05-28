import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_active_ads_usecase.dart';

part 'get_post_ad_event.dart';
part 'get_post_ad_state.dart';

class GetPostAdBloc extends Bloc<GetPostAdEvent, GetPostAdState> {
  final GetActiveAdsUsecase getActiveAdsUsecase;
  List<AdWithUserModel> _allAds = []; // Store all ads for filtering

  GetPostAdBloc({required this.getActiveAdsUsecase})
      : super(GetPostAdInitial()) {
    on<FetchActiveAds>(_onFetchActiveAds);
    on<RefreshActiveAds>(_onRefreshActiveAds);
    on<FilterByBrandEvent>(_onFilterByBrand);
  }

  Future<void> _onFetchActiveAds(
    FetchActiveAds event,
    Emitter<GetPostAdState> emit,
  ) async {
    emit(GetPostAdLoading());
    final result = await getActiveAdsUsecase();
    result.fold(
      (error) => emit(GetPostAdError(error)),
      (ads) {
        _allAds = ads; // Store all ads
        emit(GetPostAdLoaded(ads));
      },
    );
  }

  Future<void> _onRefreshActiveAds(
    RefreshActiveAds event,
    Emitter<GetPostAdState> emit,
  ) async {
    final currentState = state;
    if (currentState is GetPostAdLoaded) {
      emit(GetPostAdLoading(previousAds: currentState.ads));
    } else {
      emit(GetPostAdLoading());
    }

    final result = await getActiveAdsUsecase();
    result.fold(
      (error) => emit(GetPostAdError(error)),
      (ads) {
        _allAds = ads; // Update all ads
        emit(GetPostAdLoaded(ads));
      },
    );
  }

  void _onFilterByBrand(
    FilterByBrandEvent event,
    Emitter<GetPostAdState> emit,
  ) {
    if (event.brandName == 'ALL') {
      emit(GetPostAdLoaded(_allAds));
      return;
    }

    final filteredAds = _allAds.where((ad) => ad.ad.brand == event.brandName).toList();
    emit(GetPostAdLoaded(filteredAds, selectedBrand: event.brandName));
  }
}