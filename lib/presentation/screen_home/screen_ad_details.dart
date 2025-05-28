import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';
import 'package:shiftwheels/presentation/screen_my_ads/add_favourite_bloc/add_favourite_bloc.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class ScreenAdDetails extends StatelessWidget {
  final AdWithUserModel adWithUser;

  const ScreenAdDetails({super.key, required this.adWithUser});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return BlocProvider(
      create:
          (context) =>
              AddFavouriteBloc(sl<PostRepository>())
                ..add(LoadFavoritesEvent(currentUserId)),
      child: Scaffold()
    );
  }
}


