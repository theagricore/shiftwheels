import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/user_post_limit.dart';
import 'package:shiftwheels/presentation/add_post/screen_payment/screen_payment.dart';
import 'package:shiftwheels/presentation/main_screen/screen_profile/widget/premium_card_bloc/premium_card_bloc.dart';

class PremiumCard extends StatelessWidget {
  final UserPostLimit limit;
  final Function()? onTap;
  final Function()? onRefresh;

  const PremiumCard({
    super.key,
    required this.limit,
    this.onTap,
    this.onRefresh,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

@override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (context) => PremiumCardBloc(),
    child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: limit.isPremiumActive
            ? _buildPremiumAccountCard(context)
            : _buildFreeAccountCard(context),
      ),
    ),
  );
}

  Widget _buildPremiumAccountCard(BuildContext context) {
    const int standardPremiumDurationInDays = 30;
    final DateTime now = DateTime.now();
    final DateTime expiryDate = limit.premiumExpiryDate!;
    final DateTime inferredActivationDate = expiryDate.subtract(
      Duration(days: standardPremiumDurationInDays),
    );
    final int totalDurationForProgressBar = standardPremiumDurationInDays;
    final int daysRemaining = expiryDate.difference(now).inDays;

    double progress = totalDurationForProgressBar > 0
        ? daysRemaining / totalDurationForProgressBar
        : 0.0;

    if (progress < 0) {
      progress = 0;
    } else if (progress > 1) {
      progress = 1;
    }

    Color progressColor;
    if (daysRemaining <= 0) {
      progressColor = Colors.red.shade600;
    } else if (daysRemaining <= 7) {
      progressColor = Colors.orange.shade600;
    } else {
      progressColor = AppColors.zGold;
    }

    return Stack(
      children: [
        Positioned.fill(
          child: Lottie.asset(
            'assets/images/Animation - card_bg.json',
            fit: BoxFit.cover,
            repeat: true,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Lottie.asset(
                      'assets/images/Animation - Premium-icon.json',
                      fit: BoxFit.contain,
                      width: 40,
                      height: 40,
                      repeat: false,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Premium Account',
                      style: GoogleFonts.poppins(
                        color: AppColors.zGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Expires: ${_formatDate(expiryDate)}',
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade300,
                  color: progressColor,
                  minHeight: 8,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  daysRemaining <= 0
                      ? 'Expired'
                      : '$daysRemaining days remaining',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _AnimatedLines(
                lines: const [
                  'Unlimited posts & exclusive features!',
                  'Get a premium badge and priority visibility!',
                  'Enjoy an ad-free experience!',
                  'Dedicated customer support!',
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFreeAccountCard(BuildContext context) {
    final int postsRemaining = 4 - limit.postCount;
    final double postProgress = limit.postCount / 4;

    return Stack(
      children: [
        Positioned.fill(
          child: Lottie.asset(
            'assets/images/Animation - card_bg.json',
            fit: BoxFit.cover,
            repeat: true,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScreenPayment(
                  limit: limit,
                  userId: limit.userId,
                ),
              ),
            ).then((_) {
              if (onRefresh != null) onRefresh!();
            });
          },
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Lottie.asset(
                      'assets/images/Animation - free-icon.json',
                      fit: BoxFit.contain,
                      width: 40,
                      height: 40,
                      repeat: false,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Free Account',
                      style: GoogleFonts.poppins(
                        color: AppColors.zGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Posts this month: ${limit.postCount}/4',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.zWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: postProgress,
                    backgroundColor: Colors.grey.shade300,
                    color: postsRemaining <= 1
                        ? Colors.red.shade600
                        : AppColors.zGold,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 14),
                _AnimatedLines(
                  lines: const [
                    "Tap to upgrade for unlimited posts!",
                    "Discover premium features!",
                    "Unlock priority visibility & no ads!",
                    "Learn more about premium benefits!",
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AnimatedLines extends StatelessWidget {
  final List<String> lines;
  
  const _AnimatedLines({required this.lines});

  @override
  Widget build(BuildContext context) {
    // Start the animation when widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PremiumCardBloc>().add(StartTextAnimation(lines));
    });
    
    return BlocBuilder<PremiumCardBloc, PremiumCardState>(
      builder: (context, state) {
        final currentText = state is PremiumCardTextChanged 
            ? state.currentText 
            : lines.first;
        
        return SizedBox(
          height: 20,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                ),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Text(
              currentText,
              key: ValueKey(currentText),
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.zWhite,
                shadows: [
                  Shadow(
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0.5, 0.5),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}