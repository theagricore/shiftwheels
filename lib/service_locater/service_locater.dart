import 'package:get_it/get_it.dart';
import 'package:shiftwheels/data/auth/dataSource/firebase_auth_service.dart';
import 'package:shiftwheels/data/auth/repository/auth_repository_impl.dart';
import 'package:shiftwheels/domain/auth/repository/auth_repository.dart';
import 'package:shiftwheels/domain/auth/usecase/get_user_data_usecase.dart';
import 'package:shiftwheels/domain/auth/usecase/is_loggedin.dart';
import 'package:shiftwheels/domain/auth/usecase/logout_usecase.dart';
import 'package:shiftwheels/domain/auth/usecase/password_reset_email.dart';
import 'package:shiftwheels/domain/auth/usecase/sigin_usecase.dart';
import 'package:shiftwheels/domain/auth/usecase/siginup_usecase.dart';
import 'package:shiftwheels/presentation/MainScreen/ScreenProfile/ProfileBloc/profile_bloc.dart';

final sl = GetIt.instance;
Future<void> initializeDependencies() async {
  //Service
  sl.registerSingleton<FirebaseAuthService>(
    AuthFirebaseServiceImpl(),
  );


  //Repositories
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(),
  );
  
  //UseCase
  sl.registerSingleton<SiginupUsecase>(
    SiginupUsecase(),
  );
   sl.registerSingleton<SiginUsecase>(
    SiginUsecase(),
  );
   sl.registerSingleton<IsLoggedinusecase>(
    IsLoggedinusecase(),
  );
   sl.registerSingleton<LogoutUsecase>(
    LogoutUsecase(),
  );
    sl.registerSingleton<PasswordResetEmailUsecase>(
    PasswordResetEmailUsecase(),
  );
   sl.registerSingleton<GetUserDataUsecase>(
    GetUserDataUsecase(),
  );
  sl.registerFactory<ProfileBloc>(
  () => ProfileBloc(getUserDataUsecase: sl<GetUserDataUsecase>()),
);
}
