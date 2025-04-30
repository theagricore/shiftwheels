import 'package:shiftwheels/core/config/helper/navigator/app_navigator.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/core/config/theme/image_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/presentation/MainScreen/main_screen.dart';
import 'package:shiftwheels/presentation/auth/screens/signIn_screen.dart';
import 'package:shiftwheels/presentation/splash/SplashBloc/splash_bloc.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocListener<SplashBloc,SplashState>(listener: (context,state){
      if(state is UnAuthenticated){
        AppNavigator.pushReplacement(context, SigninScreen());
      }else if(state is Authenticated){
        AppNavigator.pushReplacement(context,const MainScreens());
      }
    },
    child: Scaffold(
      backgroundColor: AppColors.zPrimaryColor,
      body: Center(
        child: Image(
          image: const AssetImage(zLogo),
          height: size.height * 0.3,
          width: size.height * 0.3,
        ),
      ),
    ),
    );
  }
}