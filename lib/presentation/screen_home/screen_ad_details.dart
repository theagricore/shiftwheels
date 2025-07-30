import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';
import 'package:shiftwheels/presentation/screen_chat/chat_bloc/chat_bloc.dart';
import 'package:shiftwheels/presentation/screen_chat/screen_ad_chat.dart';
import 'package:shiftwheels/presentation/screen_home/call_bloc/call_bloc.dart';
import 'package:shiftwheels/presentation/screen_home/widget/auto_scroll_image_carousel.dart';
import 'package:shiftwheels/presentation/screen_home/widget/bottom_contact_bar_widget.dart';
import 'package:shiftwheels/presentation/screen_home/widget/deatils_app_bar_widget.dart';
import 'package:shiftwheels/presentation/screen_home/widget/favoirate_interst_button.dart';
import 'package:shiftwheels/presentation/screen_home/widget/over_view_grid.dart';
import 'package:shiftwheels/presentation/screen_home/widget/user_info_widget.dart';
import 'package:shiftwheels/presentation/screen_my_ads/add_favourite_bloc/add_favourite_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/interest_bloc/interest_bloc.dart';
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
          create: (context) =>
              AddFavouriteBloc(sl<PostRepository>())
                ..add(LoadFavoritesEvent(adWithUser.ad.userId)),
        ),
        BlocProvider(create: (context) => InterestBloc(sl<PostRepository>())),
        BlocProvider.value(value: sl<ChatBloc>()),
        BlocProvider(create: (context) => CallBloc()),
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
  StreamSubscription? _favoriteSubscription;
  StreamSubscription? _interestSubscription;

  @override
  void dispose() {
    _chatSubscription?.cancel();
    _favoriteSubscription?.cancel();
    _interestSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 600;
        
        return MultiBlocListener(
          listeners: [
            BlocListener<AddFavouriteBloc, AddFavouriteState>(
              listener: (context, state) {
                if (state is AddFavouriteError) {
                  BasicSnackbar(
                    message: state.message,
                    backgroundColor: AppColors.zred,
                  ).show(context);
                }
              },
            ),
            BlocListener<InterestBloc, InterestState>(
              listener: (context, state) {
                if (state is InterestError) {
                  BasicSnackbar(
                    message: state.message,
                    backgroundColor: AppColors.zred,
                  ).show(context);
                }
              },
            ),
          ],
          child: Scaffold(
            backgroundColor: AppColors.zWhite,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(isWeb ? 72 : 64),
              child: DeatilsAppBarWidget(),
            ),
            body: isWeb 
                ? _buildWebLayout(context, constraints.maxWidth)
                : _buildMobileLayout(context),
          ),
        );
      },
    );
  }

  Widget _buildWebLayout(BuildContext context, double maxWidth) {
    final contentWidth = maxWidth * 0.7 > 800 ? 800 : maxWidth * 0.7;
    
    return Center(
      child: SizedBox(
        width: contentWidth.toDouble(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(context, true),
              _buildActionButtons(context),
              _buildBasicInfoSection(true),
              _buildDetailsSection(true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(context, false),
          _buildActionButtons(context),
          _buildBasicInfoSection(false),
          _buildDetailsSection(false),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, bool isWeb) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final adId = widget.adWithUser.ad.id!;

    return AutoScrollImageCarousel(
      imageUrls: widget.adWithUser.ad.imageUrls,
      adId: adId,
      currentUserId: currentUserId,
      isSold: widget.adWithUser.ad.isSold,
      isWeb: isWeb,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final adId = widget.adWithUser.ad.id!;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return widget.adWithUser.ad.isSold
        ? const SizedBox.shrink()
        : FavoirateInterstButton(adId: adId, currentUserId: currentUserId);
  }

  Widget _buildBasicInfoSection(bool isWeb) {
    final ad = widget.adWithUser.ad;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 40 : 20,
        vertical: isWeb ? 24 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "${ad.brand} ${ad.model} (${ad.year})",
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.zblack,
                    fontSize: isWeb ? 22 : 18,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: isWeb ? 22 : 20,
                    color: AppColors.zblack.withOpacity(0.7),
                  ),
                  SizedBox(width: isWeb ? 10 : 8),
                  Text(
                    timeago.format(ad.postedDate),
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.zblack.withOpacity(0.7),
                      fontSize: isWeb ? 16 : 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: isWeb ? 8 : 5),
          Text(
            "₹${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(ad.price)}",
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.zPrimaryColor,
              fontSize: isWeb ? 24 : 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(bool isWeb) {
    final ad = widget.adWithUser.ad;
    final userData = widget.adWithUser.userData;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.zblack,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isWeb ? 40 : 32),
          topRight: Radius.circular(isWeb ? 40 : 32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.all(isWeb ? 32 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Overview",
            style: TextStyle(
              fontSize: isWeb ? 28 : 24,
              fontWeight: FontWeight.w700,
              color: AppColors.zWhite,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: isWeb ? 24 : 20),
          OverviewGrid(
            transmission: ad.transmissionType,
            kmDriven: ad.kmDriven,
            noOfOwners: ad.noOfOwners,
            fuelType: ad.fuelType,
            isWeb: isWeb,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: isWeb ? 32 : 28,
              bottom: isWeb ? 24 : 20,
            ),
            child: UserInfoWidget(userData: userData, ad: ad,),
          ),
          Text(
            "Description",
            style: TextStyle(
              fontSize: isWeb ? 28 : 24,
              fontWeight: FontWeight.w700,
              color: AppColors.zWhite,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: isWeb ? 16 : 12),
          Text(
            ad.description,
            style: TextStyle(
              fontSize: isWeb ? 18 : 16,
              fontWeight: FontWeight.w400,
              color: AppColors.zWhite.withOpacity(0.9),
              height: 1.6,
              letterSpacing: 0.3,
            ),
          ),
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return BlocListener<CallBloc, CallState>(
      listener: (context, state) {
        if (state is CallFailure) {
          BasicSnackbar(
            message: state.message,
            backgroundColor: AppColors.zred,
          ).show(context);
        }
      },
      child: BottomContactBarWidget(
        onChatPressed: () => _handleChatPressed(context),
        onCallPressed: () => _handleCallPressed(context),
        isAdSold: widget.adWithUser.ad.isSold,
      ),
    );
  }

  void _handleCallPressed(BuildContext context) {
    final phoneNumber = widget.adWithUser.userData?.phoneNo;

    if (phoneNumber == null || phoneNumber.isEmpty) {
      BasicSnackbar(
        message: 'Phone number not available',
        backgroundColor: AppColors.zred,
      ).show(context);
      return;
    }

    context.read<CallBloc>().add(MakePhoneCall(phoneNumber));
  }

  void _handleChatPressed(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final ad = widget.adWithUser.ad;

    if (currentUserId == null) {
      BasicSnackbar(
        message: 'Please log in to start a chat',
        backgroundColor: AppColors.zred,
      ).show(context);
      return;
    }
    if (currentUserId == ad.userId) {
      BasicSnackbar(
        message: 'You cannot chat with yourself',
        backgroundColor: AppColors.zred,
      ).show(context);
      return;
    }
    if (ad.id == null) {
      BasicSnackbar(
        message: 'Invalid ad ID',
        backgroundColor: AppColors.zred,
      ).show(context);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            AppColors.zPrimaryColor,
          ),
        ),
      ),
    );

    final chatBloc = context.read<ChatBloc>();
    chatBloc.add(
      CreateChatEvent(
        adId: ad.id!,
        sellerId: ad.userId,
        buyerId: currentUserId,
      ),
    );

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
        BasicSnackbar(
          message: state.message,
          backgroundColor: AppColors.zred,
        ).show(context);
      }
    });
  }
}