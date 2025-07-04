import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/widget/animated_lottie_button_widget.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/user_post_limit.dart';
import 'package:shiftwheels/presentation/add_post/screen_payment/screen_payment.dart';

class ScreenPostLimitReached extends StatelessWidget {
  final UserPostLimit limit;

  const ScreenPostLimitReached({super.key, required this.limit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zlite,
      appBar: BasicAppbar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        height: 200,
                        width: 200,
                        alignment: Alignment.center,
                        child: Lottie.asset(
                          'assets/images/Animation - error-w512-h512.json',
                          fit: BoxFit.contain,
                          repeat: false,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Monthly Post Limit Reached',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "You've reached your limit of 4 free posts this month.",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Upgrade to premium for unlimited posts.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      _buildLimitInfo(context),
                      const Spacer(),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedLottieButtonWidget(
                            animationAsset:
                                "assets/images/Animation - buttonanimation.json",
                            onTap: () {
                              _navigateToPremium(context);
                            },
                            label: 'Upgrade to Premium (₹100)',
                          ),
                          const SizedBox(height: 8),
                          AnimatedLottieButtonWidget(
                            animationAsset:
                                "assets/images/Animation - buttob blue.json",
                            onTap: () {
                              Navigator.pop(context);
                            },
                            label: 'Continue with free account',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToPremium(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenPayment(limit: limit, userId: limit.userId),
      ),
    ).then((success) {
      if (success == true) Navigator.pop(context, true);
    });
  }

  Widget _buildLimitInfo(BuildContext context) {
    return Column(
      children: [
        Text('Posts this month: ${limit.postCount}/4'),
        const SizedBox(height: 8),
        Text('Limit resets on: ${_formatDate(limit.resetDate)}'),
        if (limit.isPremium) ...[
          const SizedBox(height: 8),
          Text(
            'Premium active until: ${_formatDate(limit.premiumExpiryDate!)}',
            style: TextStyle(color: Colors.green),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
