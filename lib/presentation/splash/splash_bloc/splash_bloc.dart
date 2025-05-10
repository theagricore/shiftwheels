import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shiftwheels/domain/auth/usecase/is_loggedin.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(DisplaySplash()) {
    on<AppStarted>(_onAppStarted);
  }

  Future<void> _onAppStarted(
      AppStarted event, Emitter<SplashState> emit) async {
    await Future.delayed(const Duration(seconds: 3));
    var isLoggedIn = await sl<IsLoggedinusecase>().call();
    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(UnAuthenticated());
    }
  }
}
