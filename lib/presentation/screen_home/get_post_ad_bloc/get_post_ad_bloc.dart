import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_active_ads_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_premium_ads_usecase.dart';

part 'get_post_ad_event.dart';
part 'get_post_ad_state.dart';

class GetPostAdBloc extends Bloc<GetPostAdEvent, GetPostAdState> {
  final GetActiveAdsUsecase getActiveAdsUsecase;
  final GetPremiumAdsUsecase getPremiumAdsUsecase;
  List<AdWithUserModel> _allAds = [];
  List<AdWithUserModel> _premiumAds = [];
  String? _currentSelectedBrand;

  GetPostAdBloc({
    required this.getActiveAdsUsecase,
    required this.getPremiumAdsUsecase,
  }) : super(GetPostAdInitial()) {
    on<FetchActiveAds>(_onFetchActiveAds);
    on<RefreshActiveAds>(_onRefreshActiveAds);
    on<FilterByBrandEvent>(_onFilterByBrand);
  }

  Future<void> _onFetchActiveAds(
    FetchActiveAds event,
    Emitter<GetPostAdState> emit,
  ) async {
    emit(GetPostAdLoading(selectedBrand: _currentSelectedBrand));
    final activeAdsResult = await getActiveAdsUsecase();
    final premiumAdsResult = await getPremiumAdsUsecase();

    return activeAdsResult.fold(
      (error) => emit(GetPostAdError(error)),
      (ads) {
        _allAds = ads;
        premiumAdsResult.fold(
          (error) => emit(GetPostAdError(error)),
          (premiumAds) {
            _premiumAds = premiumAds;
            if (_currentSelectedBrand != null && _currentSelectedBrand != 'ALL') {
              final filteredAds = _allAds.where((ad) => ad.ad.brand == _currentSelectedBrand).toList();
              final filteredPremiumAds = _premiumAds.where((ad) => ad.ad.brand == _currentSelectedBrand).toList();
              emit(GetPostAdLoaded(
                filteredAds,
                premiumAds: filteredPremiumAds,
                selectedBrand: _currentSelectedBrand,
              ));
            } else {
              emit(GetPostAdLoaded(
                ads,
                premiumAds: _premiumAds,
                selectedBrand: _currentSelectedBrand,
              ));
            }
          },
        );
      },
    );
  }

  Future<void> _onRefreshActiveAds(
    RefreshActiveAds event,
    Emitter<GetPostAdState> emit,
  ) async {
    final brandToRefresh = event.selectedBrand ?? _currentSelectedBrand;

    final currentState = state;
    if (currentState is GetPostAdLoaded) {
      emit(GetPostAdLoading(
        previousAds: currentState.ads,
        previousPremiumAds: currentState.premiumAds,
        selectedBrand: brandToRefresh,
      ));
    } else {
      emit(GetPostAdLoading(selectedBrand: brandToRefresh));
    }

    final activeAdsResult = await getActiveAdsUsecase();
    final premiumAdsResult = await getPremiumAdsUsecase();

    return activeAdsResult.fold(
      (error) => emit(GetPostAdError(error)),
      (ads) {
        _allAds = ads;
        premiumAdsResult.fold(
          (error) => emit(GetPostAdError(error)),
          (premiumAds) {
            _premiumAds = premiumAds;
            if (brandToRefresh != null && brandToRefresh != 'ALL') {
              final filteredAds = _allAds.where((ad) => ad.ad.brand == brandToRefresh).toList();
              final filteredPremiumAds = _premiumAds.where((ad) => ad.ad.brand == brandToRefresh).toList();
              emit(GetPostAdLoaded(
                filteredAds,
                premiumAds: filteredPremiumAds,
                selectedBrand: brandToRefresh,
              ));
            } else {
              emit(GetPostAdLoaded(
                ads,
                premiumAds: _premiumAds,
                selectedBrand: null,
              ));
            }
          },
        );
      },
    );
  }

  void _onFilterByBrand(
    FilterByBrandEvent event,
    Emitter<GetPostAdState> emit,
  ) {
    if (event.brandName == 'ALL') {
      _currentSelectedBrand = null;
      emit(GetPostAdLoaded(
        _allAds,
        premiumAds: _premiumAds,
        selectedBrand: null,
      ));
      return;
    }

    _currentSelectedBrand = event.brandName;
    final filteredAds = _allAds.where((ad) => ad.ad.brand == event.brandName).toList();
    final filteredPremiumAds = _premiumAds.where((ad) => ad.ad.brand == event.brandName).toList();
    emit(GetPostAdLoaded(
      filteredAds,
      premiumAds: filteredPremiumAds,
      selectedBrand: event.brandName,
    ));
  }
}