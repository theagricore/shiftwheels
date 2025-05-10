import 'package:shiftwheels/core/config/theme/theme.dart';
import 'package:shiftwheels/presentation/add_post/get_fuels_bloc/get_fuels_bloc.dart';
import 'package:shiftwheels/presentation/main_screen/screen_profile/ProfileBloc/profile_bloc.dart';
import 'package:shiftwheels/presentation/add_post/add_post_bloc/add_post_bloc.dart';
import 'package:shiftwheels/presentation/auth/auth_bloc/auth_bloc.dart';
import 'package:shiftwheels/presentation/auth/google_auth/google_auth_bloc.dart';
import 'package:shiftwheels/presentation/splash/splash_bloc/splash_bloc.dart';
import 'package:shiftwheels/presentation/splash/screen/splash_screen.dart';
import 'package:shiftwheels/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
            BlocProvider<AddPostBloc>(
              create: (context) => sl<AddPostBloc>(),
            ),
            BlocProvider<GetFuelsBloc>(
              create: (context) => sl<GetFuelsBloc>(),
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