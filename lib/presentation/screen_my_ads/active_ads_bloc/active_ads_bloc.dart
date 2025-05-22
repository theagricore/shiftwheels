import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/deactive-ad_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_user_active_ads_usecase.dart';

part 'active_ads_event.dart';
part 'active_ads_state.dart';

class ActiveAdsBloc extends Bloc<ActiveAdsEvent, ActiveAdsState> {
  final GetUserActiveAdsUsecase getUserActiveAds;
  final DeactivateAdUsecase deactivateAd;
  
  ActiveAdsBloc({
    required this.getUserActiveAds,
    required this.deactivateAd,
  }) : super(ActiveAdsInitial()) {
    on<LoadActiveAds>(_onLoadActiveAds);
    on<DeactivateAd>(_onDeactivateAd);
  }

  Future<void> _onLoadActiveAds(
    LoadActiveAds event,
    Emitter<ActiveAdsState> emit,
  ) async {
    emit(ActiveAdsLoading());
    
    final result = await getUserActiveAds(param: event.userId);
    
    result.fold(
      (failure) => emit(ActiveAdsError(failure)),
      (ads) => emit(ActiveAdsLoaded(ads)),
    );
  }

  Future<void> _onDeactivateAd(
    DeactivateAd event,
    Emitter<ActiveAdsState> emit,
  ) async {
    if (state is ActiveAdsLoaded) {
      final currentState = state as ActiveAdsLoaded;
      
      emit(ActiveAdsLoading());
      
      final result = await deactivateAd(param: event.adId);
      
      result.fold(
        (failure) {
          emit(ActiveAdsError(failure));
          emit(currentState); // Revert to previous state on failure
        },
        (_) {
          // Remove the deactivated ad from the list
          final updatedAds = currentState.ads.where((ad) => ad.ad.id != event.adId).toList();
          emit(ActiveAdsLoaded(updatedAds));
        },
      );
    }
  }
}