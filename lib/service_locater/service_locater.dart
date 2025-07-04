import 'package:get_it/get_it.dart';
import 'package:shiftwheels/data/add_post/data_source/cloudinary_service.dart';
import 'package:shiftwheels/data/add_post/data_source/firebase_post_service.dart';
import 'package:shiftwheels/data/add_post/repository/post_repository_impl.dart';
import 'package:shiftwheels/data/auth/data_dource/firebase_auth_service.dart';
import 'package:shiftwheels/data/auth/repository/auth_repository_impl.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/create_chat_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/delete_message_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/get_chats_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/get_messages_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/mark_messages_read_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/send_message_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/check_post_limit_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/create_payment_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/deactive-ad_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_active_ads_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_brand_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_favorites_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_fuels_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_interested_users_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_location_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_models_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_user_active_ads_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/post_ad_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/search_location_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/toggleIntrestUsecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/toggle_favoriteUsecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/upadate_ad_usecate.dart';
import 'package:shiftwheels/domain/add_post/usecase/update_payment_status_usecase.dart';
import 'package:shiftwheels/domain/auth/repository/auth_repository.dart';
import 'package:shiftwheels/domain/auth/usecase/get_user_data_usecase.dart';
import 'package:shiftwheels/domain/auth/usecase/google_signin_usecase.dart';
import 'package:shiftwheels/domain/auth/usecase/is_loggedin.dart';
import 'package:shiftwheels/domain/auth/usecase/logout_usecase.dart';
import 'package:shiftwheels/domain/auth/usecase/password_reset_email.dart';
import 'package:shiftwheels/domain/auth/usecase/sigin_usecase.dart';
import 'package:shiftwheels/domain/auth/usecase/siginup_usecase.dart';
import 'package:shiftwheels/domain/auth/usecase/update_profile_image_usecase.dart';
import 'package:shiftwheels/presentation/add_post/get_images_bloc/get_images_bloc.dart';
import 'package:shiftwheels/presentation/add_post/get_location_bloc/get_location_bloc.dart';
import 'package:shiftwheels/presentation/add_post/post_ad_bloc/post_ad_bloc.dart';
import 'package:shiftwheels/presentation/add_post/post_limit_bloc/post_limit_bloc.dart';
import 'package:shiftwheels/presentation/main_screen/screen_profile/ProfileBloc/profile_bloc.dart';
import 'package:shiftwheels/presentation/add_post/add_post_bloc/add_post_bloc.dart';
import 'package:shiftwheels/presentation/auth/google_auth/google_auth_bloc.dart';
import 'package:shiftwheels/presentation/add_post/get_fuels_bloc/get_fuels_bloc.dart';
import 'package:shiftwheels/presentation/main_screen/screen_profile/profile_image_bloc/profile_image_bloc.dart';
import 'package:shiftwheels/presentation/screen_chat/chat_bloc/chat_bloc.dart';
import 'package:shiftwheels/presentation/screen_home/get_post_ad_bloc/get_post_ad_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/active_ads_bloc/active_ads_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/add_favourite_bloc/add_favourite_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/interest_bloc/interest_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/update_ad_bloc/update_ad_bloc.dart';
import 'package:shiftwheels/presentation/search_screen/search_bloc/search_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Services
  sl.registerSingleton<FirebaseAuthService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<FirebasePostService>(PostFirebaseServiceImpl());
  sl.registerSingleton<CloudinaryService>(CloudinaryServiceImpl());

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<PostRepository>(PostRepositoryImpl());

  // UseCases
  sl.registerSingleton<SiginupUsecase>(SiginupUsecase());
  sl.registerSingleton<SiginUsecase>(SiginUsecase());
  sl.registerSingleton<IsLoggedinusecase>(IsLoggedinusecase());
  sl.registerSingleton<LogoutUsecase>(LogoutUsecase());
  sl.registerSingleton<PasswordResetEmailUsecase>(PasswordResetEmailUsecase());
  sl.registerSingleton<GetUserDataUsecase>(GetUserDataUsecase());
  sl.registerSingleton<GoogleSignInUsecase>(GoogleSignInUsecase());
  sl.registerSingleton<GetBrandUsecase>(GetBrandUsecase());
  sl.registerSingleton<GetModelsUsecase>(GetModelsUsecase());
  sl.registerSingleton<GetFuelsUsecase>(GetFuelsUsecase());
  sl.registerSingleton<GetLocationUsecase>(GetLocationUsecase());
  sl.registerSingleton<SearchLocationUsecase>(SearchLocationUsecase());
  sl.registerSingleton<PostAdUsecase>(PostAdUsecase(sl<PostRepository>()));
  sl.registerSingleton<GetActiveAdsUsecase>(
    GetActiveAdsUsecase(sl<PostRepository>()),
  );
  sl.registerSingleton<ToggleFavoriteUsecase>(
    ToggleFavoriteUsecase(sl<PostRepository>()),
  );
  sl.registerSingleton<GetFavoritesUsecase>(
    GetFavoritesUsecase(sl<PostRepository>()),
  );
  sl.registerSingleton<GetUserActiveAdsUsecase>(
    GetUserActiveAdsUsecase(sl<PostRepository>()),
  );
  sl.registerSingleton<DeactivateAdUsecase>(
    DeactivateAdUsecase(sl<PostRepository>()),
  );
  sl.registerSingleton<UpdateAdUsecase>(UpdateAdUsecase(sl<PostRepository>()));
  sl.registerSingleton<CreateChatUseCase>(
    CreateChatUseCase(sl<PostRepository>()),
  );
  sl.registerSingleton<GetChatsUseCase>(GetChatsUseCase(sl<PostRepository>()));
  sl.registerSingleton<GetMessagesUseCase>(
    GetMessagesUseCase(sl<PostRepository>()),
  );
  sl.registerSingleton<SendMessageUseCase>(
    SendMessageUseCase(sl<PostRepository>()),
  );
  sl.registerSingleton<MarkMessagesReadUseCase>(
    MarkMessagesReadUseCase(sl<PostRepository>()),
  );
  sl.registerSingleton<DeleteMessageUseCase>(
    DeleteMessageUseCase(sl<PostRepository>()),
  );
  sl.registerSingleton<ToggleInterestUsecase>(
    ToggleInterestUsecase(sl<PostRepository>()),
  );
  sl.registerSingleton<GetInterestedUsersUsecase>(
    GetInterestedUsersUsecase(sl<PostRepository>()),
  );
  sl.registerSingleton<UpdateProfileImageUsecase>(
    UpdateProfileImageUsecase(sl<AuthRepository>()),
  );
  sl.registerSingleton<CheckPostLimitUsecase>(
    CheckPostLimitUsecase(sl<PostRepository>()),
  );
  sl.registerSingleton<CreatePaymentUsecase>(
    CreatePaymentUsecase(sl<PostRepository>()),
  );
  sl.registerSingleton<UpdatePaymentStatusUsecase>(
    UpdatePaymentStatusUsecase(sl<PostRepository>()),
  );

  // Blocs
  sl.registerFactory<GoogleAuthBloc>(() => GoogleAuthBloc());
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
    ),
  );
  sl.registerFactory<GetImagesBloc>(() => GetImagesBloc());
  sl.registerFactory<PostAdBloc>(
    () => PostAdBloc(
      postAdUsecase: sl<PostAdUsecase>(),
      cloudinaryService: sl<CloudinaryService>(),
      checkPostLimitUsecase: sl<CheckPostLimitUsecase>(),
      createPaymentUsecase: sl<CreatePaymentUsecase>(),
    ),
  );
  sl.registerFactory<PostLimitBloc>(
    () => PostLimitBloc(sl<CheckPostLimitUsecase>()),
  );
  sl.registerFactory<GetPostAdBloc>(
    () => GetPostAdBloc(getActiveAdsUsecase: sl<GetActiveAdsUsecase>()),
  );
  sl.registerFactory<AddFavouriteBloc>(
    () => AddFavouriteBloc(sl<PostRepository>()),
  );
  sl.registerFactory<ActiveAdsBloc>(
    () => ActiveAdsBloc(
      getUserActiveAds: sl<GetUserActiveAdsUsecase>(),
      deactivateAd: sl<DeactivateAdUsecase>(),
    ),
  );
  sl.registerFactory<UpdateAdBloc>(
    () => UpdateAdBloc(updateAdUsecase: sl<UpdateAdUsecase>()),
  );
  sl.registerFactory<ChatBloc>(
    () => ChatBloc(
      createChatUseCase: sl<CreateChatUseCase>(),
      getChatsUseCase: sl<GetChatsUseCase>(),
      getMessagesUseCase: sl<GetMessagesUseCase>(),
      sendMessageUseCase: sl<SendMessageUseCase>(),
      markMessagesReadUseCase: sl<MarkMessagesReadUseCase>(),
      deleteMessageUseCase: sl<DeleteMessageUseCase>(),
    ),
  );
  sl.registerFactory<SearchBloc>(() => SearchBloc());

  sl.registerFactory<InterestBloc>(() => InterestBloc(sl<PostRepository>()));
  sl.registerFactory<ProfileImageBloc>(() => ProfileImageBloc());
}
