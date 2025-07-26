import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_alert_box.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/common_widget/widget/swipe_botton.dart';
import 'package:shiftwheels/core/config/helper/navigator/app_navigator.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_interested_users_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/mark_as_sold_usecase.dart';
import 'package:shiftwheels/presentation/screen_home/screen_ad_details.dart';
import 'package:shiftwheels/presentation/screen_my_ads/active_ads_bloc/active_ads_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/mark_as_sold_bloc/mark_as_sold_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/screen_edit_ad.dart';
import 'package:shiftwheels/presentation/screen_my_ads/update_ad_bloc/update_ad_bloc.dart';
import 'package:shiftwheels/presentation/screen_my_ads/widget/users_bottom_sheet.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class ActiveAdCard extends StatefulWidget {
  final AdWithUserModel ad;

  const ActiveAdCard({super.key, required this.ad});

  @override
  State<ActiveAdCard> createState() => _ActiveAdCardState();
}

class _ActiveAdCardState extends State<ActiveAdCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _showActions = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleActions() {
    setState(() {
      _showActions = !_showActions;
      if (_showActions) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

 

  void _showInterestedUsersBottomSheet(BuildContext context, String adId) async {
    final getInterestedUsersUsecase = sl<GetInterestedUsersUsecase>();
    final result = await getInterestedUsersUsecase(param: adId);

    result.fold(
      (error) {
        BasicSnackbar(
          message: error,
          backgroundColor: AppColors.zred,
        ).show(context);
      },
      (users) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => InterestedUsersBottomSheet(
            users: users,
          ),
        );
      },
    );
  }

  void _navigateToEditScreen(BuildContext context, AdsModel ad) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: BlocProvider.of<ActiveAdsBloc>(context),
            ),
            BlocProvider(create: (_) => sl<UpdateAdBloc>()),
          ],
          child: ScreenEditAd(ad: ad),
        ),
      ),
    ).then((_) {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      context.read<ActiveAdsBloc>().add(LoadActiveAds(userId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final adData = widget.ad.ad;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MarkAsSoldBloc(sl<MarkAsSoldUsecase>()),
        ),
      ],
      child: BlocListener<MarkAsSoldBloc, MarkAsSoldState>(
        listener: (context, state) {
          if (state is MarkAsSoldSuccess) {
            final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
            context.read<ActiveAdsBloc>().add(LoadActiveAds(userId));
            
            BasicSnackbar(
              message: 'Ad marked as sold successfully',
              backgroundColor: Colors.green,
            ).show(context);
          } else if (state is MarkAsSoldError) {
            BasicSnackbar(
              message: state.message,
              backgroundColor: AppColors.zred,
            ).show(context);
          }
        },
        child: GestureDetector(
          onTap: (){
           AppNavigator.push(context, ScreenAdDetails(adWithUser: widget.ad));
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: isDarkMode
                    ? AppColors.zDarkCardBorder.withOpacity(0.5)
                    : AppColors.zLightCardBorder.withOpacity(0.5),
                width: 1.0,
              ),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            elevation: 10,
            color: isDarkMode ? AppColors.zDarkCardBackground : AppColors.zWhite,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                children: [
                  _buildHeroImageSection(context, adData, isDarkMode),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (adData.isSold) ...[
                          _buildSoldBadge(context),
                          const SizedBox(height: 8),
                        ],
                        Text(
                          '${adData.brand} ${adData.model}',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: isDarkMode
                                    ? AppColors.zDarkPrimaryText
                                    : AppColors.zLightPrimaryText,
                                letterSpacing: -0.5,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '₹${NumberFormat('#,##,###').format(adData.price)}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.zPrimaryColor,
                              ),
                        ),
                        const SizedBox(height: 10),

                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            _buildDetailChip(
                              context,
                              icon: Icons.calendar_today_outlined,
                              label: "${adData.year}",
                              isDarkMode: isDarkMode,
                            ),
                            _buildDetailChip(
                              context,
                              icon: Icons.local_gas_station_outlined,
                              label: adData.fuelType,
                              isDarkMode: isDarkMode,
                            ),
                            _buildDetailChip(
                              context,
                              icon: Icons.settings_outlined,
                              label: adData.transmissionType,
                              isDarkMode: isDarkMode,
                            ),
                            _buildDetailChip(
                              context,
                              icon: Icons.speed_outlined,
                              label: "${adData.kmDriven} KM",
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            _buildCountBubble(
                              context,
                              icon: Icons.favorite_border,
                              color: AppColors.zred,
                              count: adData.favoritedByUsers.length,
                              onTap: () {},
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(width: 16),
                            _buildCountBubble(
                              context,
                              icon: Icons.handshake_outlined,
                              color: AppColors.zBlue,
                              count: adData.interestedUsers.length,
                              onTap: () => _showInterestedUsersBottomSheet(context, adData.id!),
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        if (!adData.isSold) ...[
                          Align(
                            alignment: Alignment.center,
                            child: CustomSwipeButton(
                              onSwipe: () {
                                context.read<MarkAsSoldBloc>().add(MarkAdAsSoldEvent(adData.id!));
                              },
                              buttonText: "Mark as Sold",
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSoldBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.red, size: 18),
          const SizedBox(width: 8),
          Text(
            'SOLD',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          if (widget.ad.ad.soldDate != null) ...[
            const SizedBox(width: 8),
            Text(
              'on ${DateFormat('MMM dd').format(widget.ad.ad.soldDate!)}',
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeroImageSection(
      BuildContext context, AdsModel adData, bool isDarkMode) {
    return Stack(
      children: [
        // Large Image
        AspectRatio(
          aspectRatio: 1.8,
          child: Hero(
            tag: 'ad-image-${adData.id}',
            child: Image.network(
              adData.imageUrls.first,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: isDarkMode ? AppColors.zGrey[900] : AppColors.zGrey[100],
                child: Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: isDarkMode ? AppColors.zGrey[700] : AppColors.zGrey[400],
                    size: 100,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Gradient Overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),

        // "Posted" Date Tag
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.zPrimaryColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Posted: ${_formatDate(adData.postedDate)}",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.zblack,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),

        // Sold Overlay
        if (adData.isSold)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, size: 50, color: Colors.white),
                    const SizedBox(height: 8),
                    Text(
                      'SOLD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (adData.soldDate != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('MMM dd, yyyy').format(adData.soldDate!),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

        // Custom Animated Action Menu Button
        if (!adData.isSold)
          Positioned(
            top: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _toggleActions,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (isDarkMode ? AppColors.zDarkBackground : AppColors.zWhite)
                          .withOpacity(0.85),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _showActions ? Icons.close : Icons.more_horiz,
                      color: isDarkMode ? AppColors.zDarkIconColor : AppColors.zIconColor,
                      size: 24,
                    ),
                  ),
                ),
                if (_showActions) ...[
                  const SizedBox(height: 10),
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _animationController,
                      child: Column(
                        children: [
                          _buildActionButton(
                            context,
                            icon: Icons.edit_outlined,
                            label: 'Edit',
                            color: AppColors.zBlue,
                            onTap: () {
                              _toggleActions();
                              _navigateToEditScreen(context, adData);
                            },
                            isDarkMode: isDarkMode,
                          ),
                          const SizedBox(height: 8),
                          _buildActionButton(
                            context,
                            icon: Icons.delete_outline,
                            label: 'Delete',
                            color: AppColors.zred,
                            onTap: () {
                              _toggleActions();
                              showDeleteConfirmationDialog(
                                context: context,
                                onConfirm: () {
                                  context
                                      .read<ActiveAdsBloc>()
                                      .add(DeactivateAd(adData.id!));
                                },
                              );
                            },
                            isDarkMode: isDarkMode,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: (isDarkMode ? AppColors.zDarkCardBackground : AppColors.zWhite)
              .withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDarkMode
                        ? AppColors.zDarkPrimaryText
                        : AppColors.zLightPrimaryText,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.zDarkCountButton : AppColors.zLightCountButton,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDarkMode
              ? AppColors.zDarkCardBorder.withOpacity(0.4)
              : AppColors.zLightCardBorder.withOpacity(0.6),
          width: 0.6,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: isDarkMode
                ? AppColors.zDarkSecondaryText
                : AppColors.zLightSecondaryText,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDarkMode
                        ? AppColors.zDarkSecondaryText
                        : AppColors.zLightSecondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountBubble(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required int count,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withOpacity(0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              count.toString(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy').format(date);
  }
}