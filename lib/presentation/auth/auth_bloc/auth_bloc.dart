import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/data/auth/models/user_sigin_model.dart';
import 'package:shiftwheels/domain/auth/usecase/logout_usecase.dart';
import 'package:shiftwheels/domain/auth/usecase/password_reset_email.dart';
import 'package:shiftwheels/domain/auth/usecase/sigin_usecase.dart';
import 'package:shiftwheels/domain/auth/usecase/siginup_usecase.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
    on<LogoutEvent>(_onLogout);
    on<ForgotPasswordEvent>(_onForgotPassword);
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    if (state is! AuthLoading) {
      emit(AuthLoading());
    }

    try {
      final usecase = sl<SiginupUsecase>();
      Either failureOrSuccess = await usecase.call(param: event.user);

      failureOrSuccess.fold(
        (failure) {
          if (state is! AuthFailure) emit(AuthFailure(failure));
        },
        (successMessage) {
          if (state is! AuthSuccess) emit(AuthSuccess(successMessage));
        },
      );
    } catch (e) {
      if (state is! AuthFailure) emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    if (state is! AuthLoading) {
      emit(AuthLoading());
    }

    try {
      final usecase = sl<SiginUsecase>();
      Either failureOrSuccess = await usecase.call(param: event.userSiginModel);

      failureOrSuccess.fold(
        (failure) {
          if (state is! AuthFailure) emit(AuthFailure(failure));
        },
        (successMessage) {
          if (state is! AuthSuccess) emit(AuthSuccess(successMessage));
        },
      );
    } catch (e) {
      if (state is! AuthFailure) emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      final usecase = sl<LogoutUsecase>();
      Either result = await usecase.call();

      result.fold(
        (failure) {
          emit(AuthFailure(failure));
        },
        (message) {
          emit(AuthInitial()); // Emit AuthInitial after successful logout
        },
      );
    } catch (e) {
      emit(AuthFailure("Logout failed: $e"));
    }
  }

  Future<void> _onForgotPassword(ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      final usecase = sl<PasswordResetEmailUsecase>();
      Either result = await usecase.call(param: event.email);

      result.fold(
        (failure) {
          emit(AuthFailure(failure));
        },
        (successMessage) {
          emit(AuthPasswordResetState(successMessage));
        },
      );
    } catch (e) {
      emit(AuthFailure("Password reset failed: $e"));
    }
  }
}