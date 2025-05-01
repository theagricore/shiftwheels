import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:shiftwheels/domain/auth/usecase/google_signin_usecase.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

part 'google_auth_event.dart';
part 'google_auth_state.dart';

class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
  GoogleAuthBloc() : super(GoogleAuthInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<GoogleAuthState> emit,
  ) async {
    emit(GoogleAuthLoading());
    
    try {
      final usecase = sl<GoogleSignInUsecase>();
      Either failureOrSuccess = await usecase.call();

      failureOrSuccess.fold(
        (failure) => emit(GoogleAuthFailure(failure)),
        (successMessage) => emit(GoogleAuthSuccess(successMessage)),
      );
    } catch (e) {
      emit(GoogleAuthFailure(e.toString()));
    }
  }
}