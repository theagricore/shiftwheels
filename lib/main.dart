import 'package:shiftwheels/core/config/theme/theme.dart';
import 'package:shiftwheels/presentation/MainScreen/ScreenProfile/ProfileBloc/profile_bloc.dart';
import 'package:shiftwheels/presentation/auth/AuthBloc/auth_bloc.dart';
import 'package:shiftwheels/presentation/auth/GoogleAuth/google_auth_bloc.dart';
import 'package:shiftwheels/presentation/splash/SplashBloc/splash_bloc.dart';
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
