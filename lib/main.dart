import 'package:shiftwheels/core/config/theme/theme.dart';
import 'package:shiftwheels/data/add_post/data_source/cloudinary_service.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_active_ads_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/post_ad_usecase.dart';
import 'package:shiftwheels/presentation/add_post/get_fuels_bloc/get_fuels_bloc.dart';
import 'package:shiftwheels/presentation/add_post/get_location_bloc/get_location_bloc.dart';
import 'package:shiftwheels/presentation/add_post/post_ad_bloc/post_ad_bloc.dart';
import 'package:shiftwheels/presentation/main_screen/screen_profile/ProfileBloc/profile_bloc.dart';
import 'package:shiftwheels/presentation/add_post/add_post_bloc/add_post_bloc.dart';
import 'package:shiftwheels/presentation/auth/auth_bloc/auth_bloc.dart';
import 'package:shiftwheels/presentation/auth/google_auth/google_auth_bloc.dart';
import 'package:shiftwheels/presentation/screen_chat/chat_bloc/chat_bloc.dart';
import 'package:shiftwheels/presentation/screen_home/get_post_ad_bloc/get_post_ad_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/active_ads_bloc/active_ads_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/add_favourite_bloc/add_favourite_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/update_ad_bloc/update_ad_bloc.dart';
import 'package:shiftwheels/presentation/splash/splash_bloc/splash_bloc.dart';
import 'package:shiftwheels/presentation/splash/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     SystemChrome.setSystemUIOverlayStyle(
      Theme.of(context).brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    );
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<SplashBloc>(
              create: (context) => SplashBloc()..add(AppStarted()),
            ),
            BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
            BlocProvider<GoogleAuthBloc>(
              create: (context) => sl<GoogleAuthBloc>(),
            ),
            BlocProvider<ProfileBloc>(
              create: (context) => sl<ProfileBloc>()..add(FetchUserProfile()),
            ),
            BlocProvider<GetPostAdBloc>(
              create:
                  (context) => GetPostAdBloc(
                    getActiveAdsUsecase: sl<GetActiveAdsUsecase>(),
                  )..add(FetchActiveAds()),
            ),
            BlocProvider<AddPostBloc>(create: (context) => sl<AddPostBloc>()),
            BlocProvider<GetFuelsBloc>(create: (context) => sl<GetFuelsBloc>()),
            BlocProvider<GetLocationBloc>(
              create: (context) => sl<GetLocationBloc>(),
            ),
            BlocProvider<PostAdBloc>(
              create:
                  (context) => PostAdBloc(
                    postAdUsecase: sl<PostAdUsecase>(),
                    cloudinaryService: sl<CloudinaryService>(),
                  ),
            ),
            BlocProvider<AddFavouriteBloc>(
              create: (context) => sl<AddFavouriteBloc>(),
            ),
             BlocProvider<ActiveAdsBloc>(
              create: (context) => sl<ActiveAdsBloc>(),
            ),
             BlocProvider<UpdateAdBloc>(
              create: (context) => sl<UpdateAdBloc>(),
            ),
             BlocProvider<ChatBloc>(
              create: (context) => sl<ChatBloc>(),
            ),
          ],
          child: MaterialApp(
            title: 'Shift Wheels',
            theme: ZAppTheme.lightTheme,
            darkTheme: ZAppTheme.darkTheme,
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
