import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shiftwheels/data/add_post/models/user_post_limit.dart';
import 'package:shiftwheels/domain/add_post/usecase/check_post_limit_usecase.dart';

part 'post_limit_event.dart';
part 'post_limit_state.dart';

class PostLimitBloc extends Bloc<PostLimitEvent, PostLimitState> {
  final CheckPostLimitUsecase checkPostLimitUsecase;

  PostLimitBloc(this.checkPostLimitUsecase) : super(PostLimitInitial()) {
    on<CheckPostLimitEvent>(_onCheckPostLimit);
  }

  Future<void> _onCheckPostLimit(
    CheckPostLimitEvent event,
    Emitter<PostLimitState> emit,
  ) async {
    emit(PostLimitLoading());
    final result = await checkPostLimitUsecase.call(param: event.userId);
    result.fold(
      (error) => emit(PostLimitError(error)),
      (limit) => emit(PostLimitChecked(limit)),
    );
  }
}