import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/deactive-ad_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_user_active_ads_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/mark_as_sold_usecase.dart';

part 'active_ads_event.dart';
part 'active_ads_state.dart';

class ActiveAdsBloc extends Bloc<ActiveAdsEvent, ActiveAdsState> {
  final GetUserActiveAdsUsecase getUserActiveAds;
  final DeactivateAdUsecase deactivateAd;
  final MarkAsSoldUsecase markAsSold;

  ActiveAdsBloc({
    required this.getUserActiveAds, 
    required this.deactivateAd,
    required this.markAsSold,
  }) : super(ActiveAdsInitial()) {
    on<LoadActiveAds>(_onLoadActiveAds);
    on<DeactivateAd>(_onDeactivateAd);
    on<MarkAdAsSold>(_onMarkAdAsSold);
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
          emit(currentState);
        },
        (_) {
          final updatedAds = currentState.ads
              .where((ad) => ad.ad.id != event.adId)
              .toList();
          emit(ActiveAdsLoaded(updatedAds));
        },
      );
    }
  }

  Future<void> _onMarkAdAsSold(
    MarkAdAsSold event,
    Emitter<ActiveAdsState> emit,
  ) async {
    if (state is ActiveAdsLoaded) {
      final currentState = state as ActiveAdsLoaded;
      emit(ActiveAdsLoading());
      final result = await markAsSold(param: event.adId);
      result.fold(
        (failure) {
          emit(ActiveAdsError(failure));
          emit(currentState);
        },
        (_) {
          final updatedAds = currentState.ads.map((ad) {
            if (ad.ad.id == event.adId) {
              return ad.copyWith(ad: ad.ad.copyWith(isSold: true));
            }
            return ad;
          }).toList();
          emit(ActiveAdsLoaded(updatedAds));
        },
      );
    }
  }
}