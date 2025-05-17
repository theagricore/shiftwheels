import 'package:get_it/get_it.dart';
import 'package:shiftwheels/data/add_post/data_source/cloudinary_service.dart';
import 'package:shiftwheels/data/add_post/data_source/firebase_post_service.dart';
import 'package:shiftwheels/data/add_post/repository/post_repository_impl.dart';
import 'package:shiftwheels/data/auth/data_dource/firebase_auth_service.dart';
import 'package:shiftwheels/data/auth/repository/auth_repository_impl.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_active_ads_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_brand_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_fuels_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_location_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_models_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/post_ad_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/search_location_usecase.dart';
import 'package:shiftwheels/domain/auth/repository/auth_repository.dart';
import 'package:shiftwheels/domain/auth/usecase/get_user_data_usecase.dart';
import 'package:shiftwheels/domain/auth/usecase/google_signin_usecase.dart';
import 'package:shiftwheels/domain/auth/usecase/is_loggedin.dart';
import 'package:shiftwheels/domain/auth/usecase/logout_usecase.dart';
import 'package:shiftwheels/domain/auth/usecase/password_reset_email.dart';
import 'package:shiftwheels/domain/auth/usecase/sigin_usecase.dart';
import 'package:shiftwheels/domain/auth/usecase/siginup_usecase.dart';
import 'package:shiftwheels/presentation/add_post/get_images_bloc/get_images_bloc.dart';
import 'package:shiftwheels/presentation/add_post/get_location_bloc/get_location_bloc.dart';
import 'package:shiftwheels/presentation/add_post/post_ad_bloc/post_ad_bloc.dart';
import 'package:shiftwheels/presentation/main_screen/screen_profile/ProfileBloc/profile_bloc.dart';
import 'package:shiftwheels/presentation/add_post/add_post_bloc/add_post_bloc.dart';
import 'package:shiftwheels/presentation/auth/google_auth/google_auth_bloc.dart';
import 'package:shiftwheels/presentation/add_post/get_fuels_bloc/get_fuels_bloc.dart';
import 'package:shiftwheels/presentation/screen_home/get_post_ad_bloc/get_post_ad_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //Service
  sl.registerSingleton<FirebaseAuthService>(
    AuthFirebaseServiceImpl(),
  );
  sl.registerSingleton<FirebasePostService>(
    PostFirebaseServiceImpl(),
  );
   sl.registerSingleton<CloudinaryService>(
    CloudinaryServiceImpl(),
  );
  //Repositories
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(),
  );
  sl.registerSingleton<PostRepository>(
    PostRepositoryImpl(),
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
  sl.registerSingleton<GoogleSignInUsecase>(
    GoogleSignInUsecase(),
  );
  sl.registerSingleton<GetBrandUsecase>(
    GetBrandUsecase(),
  );
  sl.registerSingleton<GetModelsUsecase>(
    GetModelsUsecase(),
  );
  sl.registerSingleton<GetFuelsUsecase>(
    GetFuelsUsecase(),
  );
  sl.registerSingleton<GetLocationUsecase>(
  GetLocationUsecase(),
  );
  sl.registerSingleton<SearchLocationUsecase>(
  SearchLocationUsecase(),
  );
  sl.registerSingleton<PostAdUsecase>(
    PostAdUsecase(sl<PostRepository>()),
    );
  sl.registerSingleton<GetActiveAdsUsecase>(
   GetActiveAdsUsecase(sl<PostRepository>()),
   );

  // Blocs
  sl.registerFactory<GoogleAuthBloc>(
    () => GoogleAuthBloc(),
  );
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(getUserDataUsecase: sl<GetUserDataUsecase>()),
  );
  sl.registerFactory<AddPostBloc>(
    () => AddPostBloc(sl<GetBrandUsecase>(), sl<GetModelsUsecase>()),
  );
  sl.registerFactory<GetFuelsBloc>(
    () => GetFuelsBloc(getFuelsUsecase: sl<GetFuelsUsecase>()),
  );
  sl.registerFactory<GetLocationBloc>(
  () => GetLocationBloc(
     getLocationUsecase: sl<GetLocationUsecase>(),
     searchLocationUsecase: sl<SearchLocationUsecase>(),   
  )
  );
    sl.registerFactory<GetImagesBloc>(
    () => GetImagesBloc(),
  );
  sl.registerFactory<PostAdBloc>(
    () => PostAdBloc(
     postAdUsecase: sl<PostAdUsecase>(),
     cloudinaryService: sl<CloudinaryService>(),
    ),
  );
  sl.registerFactory<GetPostAdBloc>(
  () => GetPostAdBloc(getActiveAdsUsecase: sl<GetActiveAdsUsecase>()),
  );
}