import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/upadate_ad_usecate.dart';

part 'update_ad_event.dart';
part 'update_ad_state.dart';

class UpdateAdBloc extends Bloc<UpdateAdEvent, UpdateAdState> {
  final UpdateAdUsecase updateAdUsecase;

  UpdateAdBloc({required this.updateAdUsecase}) : super(UpdateAdInitial()) {
    on<UpdateAd>((event, emit) async {
      emit(UpdateAdLoading());
      final result = await updateAdUsecase.call(param: event.ad);
      
      result.fold(
        (failure) => emit(UpdateAdError(failure)),
        (_) => emit(AdUpdated()),
      );
    });
  }
}