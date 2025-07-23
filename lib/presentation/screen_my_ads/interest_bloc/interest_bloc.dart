import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

part 'interest_event.dart';
part 'interest_state.dart';

class InterestBloc extends Bloc<InterestEvent, InterestState> {
  final PostRepository postRepository;

  InterestBloc(this.postRepository) : super(InterestInitial()) {
    on<ToggleInterestEvent>(_onToggleInterest);
    on<LoadInitialInterestEvent>(_onLoadInitialInterest);
  }

  Future<void> _onLoadInitialInterest(
    LoadInitialInterestEvent event,
    Emitter<InterestState> emit,
  ) async {
    emit(InterestLoading());
    final result = await postRepository.getUserInterests(event.userId);
    result.fold(
      (error) => emit(InterestError(error)),
      (interests) => emit(InitialInterestLoaded(
        isInterested: interests.any((ad) => ad.ad.id == event.adId),
        adId: event.adId,
      )),
    );
  }

  Future<void> _onToggleInterest(
    ToggleInterestEvent event,
    Emitter<InterestState> emit,
  ) async {
    emit(InterestLoading());
    final result = await postRepository.toggleInterest(
      event.adId,
      event.userId,
    );
    
    result.fold(
      (error) => emit(InterestError(error)),
      (_) => emit(InterestToggled(
        adId: event.adId,
        isNowInterested: !event.currentStatus,
      )),
    );
  }
}