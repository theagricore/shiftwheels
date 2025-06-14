import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';
import 'package:shiftwheels/presentation/screen_chat/chat_bloc/chat_bloc.dart';
import 'package:shiftwheels/presentation/screen_chat/screen_ad_chat.dart';
import 'package:shiftwheels/presentation/screen_home/widget/auto_scroll_image_carousel.dart';
import 'package:shiftwheels/presentation/screen_home/widget/deatils_app_bar_widget.dart';
import 'package:shiftwheels/presentation/screen_home/widget/over_view_grid.dart';
import 'package:shiftwheels/presentation/screen_home/widget/user_info_widget.dart';
import 'package:shiftwheels/presentation/screen_my_ads/add_favourite_bloc/add_favourite_bloc.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';
import 'package:timeago/timeago.dart' as timeago;

class ScreenAdDetails extends StatelessWidget {
  final AdWithUserModel adWithUser;

  const ScreenAdDetails({super.key, required this.adWithUser});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddFavouriteBloc(sl<PostRepository>())
            ..add(LoadFavoritesEvent(adWithUser.ad.userId)),
        ),
        BlocProvider.value(value: sl<ChatBloc>()),
      ],
      child: _AdDetailsContent(adWithUser: adWithUser),
    );
  }
}

class _AdDetailsContent extends StatefulWidget {
  final AdWithUserModel adWithUser;

  const _AdDetailsContent({required this.adWithUser});

  @override
  State<_AdDetailsContent> createState() => _AdDetailsContentState();
}

class _AdDetailsContentState extends State<_AdDetailsContent> {
  StreamSubscription<ChatState>? _chatSubscription;

  @override
  void dispose() {
    _chatSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddFavouriteBloc, AddFavouriteState>(
      listener: (context, state) {
        if (state is AddFavouriteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isFavorite = _getFavoriteStatus(state, widget.adWithUser.ad);
        final ad = widget.adWithUser.ad;
        final userData = widget.adWithUser.userData;
        final textTheme = Theme.of(context).textTheme;

        return Scaffold(
          backgroundColor: AppColors.zWhite,
          appBar: const DeatilsAppBarWidget(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(context, isFavorite),
                _buildBasicInfoSection(textTheme, ad),
                _buildDetailsSection(ad, userData),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomButtons(context, ad),
        );
      },
    );
  }

  bool _getFavoriteStatus(AddFavouriteState state, AdsModel ad) {
    if (state is FavoritesLoaded) {
      return state.favorites.any((fav) => fav.ad.id == ad.id);
    } else if (state is FavoriteToggled && state.adId == ad.id) {
      return state.isNowFavorite;
    }
    return widget.adWithUser.isFavorite;
  }

  Widget _buildImageSection(BuildContext context, bool isFavorite) {
    return AutoScrollImageCarousel(
      imageUrls: widget.adWithUser.ad.imageUrls,
      isFavorite: isFavorite,
      adId: widget.adWithUser.ad.id!,
      currentUserId: widget.adWithUser.ad.userId,
    );
  }

  Widget _buildBasicInfoSection(TextTheme textTheme, AdsModel ad) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${ad.brand} ${ad.model} (${ad.year})",
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.zblack,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: AppColors.zblack),
                  const SizedBox(width: 4),
                  Text(
                    timeago.format(ad.postedDate),
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.zblack,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "₹${ad.price}",
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.zPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(AdsModel ad, UserModel? userData) {
    return Material(
      elevation: 8,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.zblack,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Overview",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.zWhite,
              ),
            ),
            const SizedBox(height: 12),
            OverviewGrid(
              transmission: ad.transmissionType,
              kmDriven: ad.kmDriven,
              noOfOwners: ad.noOfOwners,
              fuelType: ad.fuelType,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: UserInfoWidget(userData: userData, ad: ad),
            ),
            const SizedBox(height: 12),
            const Text(
              "Description",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.zWhite,
              ),
            ),
            Text(
              ad.description,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.zWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context, AdsModel ad) {
    return Container(
      color: AppColors.zblack,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _handleChatPressed(context, ad),
              icon: const Icon(Icons.chat, color: Colors.white, size: 25),
              label: const Text(
                "Chat",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.zPrimaryColor,
                minimumSize: const Size(double.infinity, 58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _handleChatPressed(BuildContext context, AdsModel ad) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to start a chat')),
      );
      return;
    }
    if (currentUserId == ad.userId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You cannot chat with yourself')),
      );
      return;
    }
    if (ad.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid ad ID')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final chatBloc = context.read<ChatBloc>();
    chatBloc.add(CreateChatEvent(
      adId: ad.id!,
      sellerId: ad.userId,
      buyerId: currentUserId,
    ));

    _chatSubscription?.cancel();
    _chatSubscription = chatBloc.stream.listen((state) {
      if (state is ChatCreated) {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: chatBloc,
              child: ScreenAdChat(
                chatId: state.chatId,
                otherUser: widget.adWithUser.userData,
                ad: ad,
              ),
            ),
          ),
        );
      } else if (state is ChatError) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    });
  }


}