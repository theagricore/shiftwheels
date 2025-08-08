import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/widget/animated_lottie_button_widget.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/data_source/razorpay_service.dart';
import 'package:shiftwheels/data/add_post/data_source/razorpay_interface.dart';
import 'package:shiftwheels/data/add_post/models/payment_model.dart';
import 'package:shiftwheels/data/add_post/models/user_post_limit.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/create_payment_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/update_payment_status_usecase.dart';
import 'package:shiftwheels/domain/auth/usecase/get_user_data_usecase.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class ScreenPayment extends StatefulWidget {
  final UserPostLimit limit;
  final String userId;

  const ScreenPayment({Key? key, required this.limit, required this.userId})
      : super(key: key);

  @override
  State<ScreenPayment> createState() => _ScreenPaymentState();
}

class _ScreenPaymentState extends State<ScreenPayment>
    with TickerProviderStateMixin {
  bool _isProcessingPayment = false;
  final double _premiumAmount = 100.0;
  UserModel? _userModel;

  late final AnimationController _bgAnimationController;
  late final AnimationController _iconAnimationController;

  @override
  void initState() {
    super.initState();
    _fetchUserData();

    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6), 
    )..repeat();

    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), 
    )..repeat();
  }

  @override
  void dispose() {
    _bgAnimationController.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      final result = await sl<GetUserDataUsecase>().call();

      result.fold(
        (error) {
          BasicSnackbar(
            message: 'Failed to fetch user data: $error',
            backgroundColor: AppColors.zred,
          );
        },
        (userData) {
          try {
            final userModel = UserModel(
              fullName: userData['fullName'] as String?,
              email: userData['email'] as String?,
              phoneNo: userData['phoneNo'] as String?,
              uid: userData['uid'] as String?,
              image: userData['image'] as String?,
              isBlocked: userData['isBlocked'] as bool? ?? false,
            );

            setState(() {
              _userModel = userModel;
            });
          } catch (e) {
            BasicSnackbar(
              message: 'Error parsing user data: $e',
              backgroundColor: AppColors.zred,
            );
          }
        },
      );
    } catch (e) {
      BasicSnackbar(
        message: 'Unexpected error: $e',
        backgroundColor: AppColors.zred,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BasicAppbar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset(
              'assets/images/Animation - yellow.json',
              fit: BoxFit.cover,
              repeat: false,
              controller: _bgAnimationController,
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              bool isWeb = kIsWeb;
              double titleFont = isWeb ? 24 : 30;
              double bodyFont = isWeb ? 13 : 14;
              double benefitFont = isWeb ? 14 : 16;

              return SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWeb ? 600 : double.infinity,
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: kToolbarHeight + 20),
                        Container(
                          height: 200,
                          width: 200,
                          alignment: Alignment.center,
                          child: Lottie.asset(
                            'assets/images/Animation - Premium-icon.json',
                            fit: BoxFit.contain,
                            repeat: true,
                            controller: _iconAnimationController,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Upgrade to Premium",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: titleFont,
                            color: AppColors.zWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Get unlimited posts for 30 days by upgrading to premium for just ₹100",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: bodyFont,
                              color: AppColors.zWhite,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildPremiumBenefits(benefitFont),
                        const SizedBox(height: 30),
                        if (_isProcessingPayment)
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: AnimatedLottieButtonWidget(
                              animationAsset:
                                  "assets/images/Animation -Premium.json",
                              onTap: _initiatePremiumPayment,
                            ),
                          ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _initiatePremiumPayment() async {
    if (_userModel == null || _userModel!.email == null) {
      BasicSnackbar(
        message: 'User data or email not available',
        backgroundColor: AppColors.zred,
      );
      return;
    }

    setState(() => _isProcessingPayment = true);

    try {
      final paymentModel = PaymentModel(
        id: '',
        userId: widget.userId,
        userName: _userModel!.fullName ?? 'Unknown',
        userEmail: _userModel!.email!,
        userPhone: _userModel!.phoneNo,
        adId: 'premium_upgrade',
        amount: _premiumAmount,
        paymentDate: DateTime.now(),
        paymentType: 'premium_upgrade',
        userImageUrl: _userModel!.image,
      );

      final paymentResult = await sl<CreatePaymentUsecase>().call(
        param: paymentModel,
      );

      await paymentResult.fold(
        (error) async {
          BasicSnackbar(
            message: 'Payment initiation failed: $error',
            backgroundColor: AppColors.zred,
          );
          setState(() => _isProcessingPayment = false);
        },
        (firestorePaymentId) async {
          if (kIsWeb) {
            try {
              openRazorpayWebCheckout(
                name: paymentModel.userName,
                description: 'Premium upgrade for ${paymentModel.userName}',
                email: paymentModel.userEmail,
                amount: _premiumAmount,
                onSuccess: (paymentId) =>
                    _handlePaymentSuccess(firestorePaymentId, paymentId),
                onFailure: (error) {
                  BasicSnackbar(
                    message: 'Web payment failed: $error',
                    backgroundColor: AppColors.zred,
                  );
                  setState(() => _isProcessingPayment = false);
                },
              );
            } catch (e) {
              BasicSnackbar(
                message: 'Web payment initialization failed: $e',
                backgroundColor: AppColors.zred,
              );
              setState(() => _isProcessingPayment = false);
            }
          } else {
            try {
              final razorpay = sl<RazorpayService>();
              razorpay.openCheckOut(
                amount: _premiumAmount,
                description: 'Premium upgrade for ${paymentModel.userName}',
                onSuccess: (razorpayPaymentId) => _handlePaymentSuccess(
                  firestorePaymentId,
                  razorpayPaymentId,
                ),
                onFailure: (error) {
                  BasicSnackbar(
                    message: 'Mobile payment failed: $error',
                    backgroundColor: AppColors.zred,
                  );
                  setState(() => _isProcessingPayment = false);
                },
              );
            } catch (e) {
              BasicSnackbar(
                message: 'Mobile payment initialization failed: $e',
                backgroundColor: AppColors.zred,
              );
              setState(() => _isProcessingPayment = false);
            }
          }
        },
      );
    } catch (e) {
      BasicSnackbar(
        message: 'Error initiating payment: $e',
        backgroundColor: AppColors.zred,
      );
      setState(() => _isProcessingPayment = false);
    }
  }

  Future<void> _handlePaymentSuccess(
    String firestorePaymentId,
    String razorpayPaymentId,
  ) async {
    try {
      final updateResult = await sl<UpdatePaymentStatusUsecase>().call(
        param: UpdatePaymentParams(
          paymentId: firestorePaymentId,
          status: 'Success',
          transactionId: razorpayPaymentId,
        ),
      );

      await updateResult.fold(
        (error) async {
          BasicSnackbar(
            message: 'Payment verification failed: $error',
            backgroundColor: AppColors.zred,
          );
          setState(() => _isProcessingPayment = false);
        },
        (_) async {
          BasicSnackbar(
            message: 'Payment successful! You are now a premium user.',
            backgroundColor: AppColors.zGreen,
          );
          Navigator.pop(context, true);
        },
      );
    } catch (e) {
      BasicSnackbar(
        message: 'Error processing payment: $e',
        backgroundColor: AppColors.zred,
      );
      setState(() => _isProcessingPayment = false);
    }
  }

  Widget _buildPremiumBenefits(double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: Colors.white.withOpacity(0.2),
        margin: EdgeInsets.zero,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Premium Benefits",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              _buildBenefitItem("✓ Unlimited posts for 30 days", fontSize),
              _buildBenefitItem("✓ No monthly posting limits", fontSize),
              _buildBenefitItem(
                  "✓ Priority listing in search results", fontSize),
              _buildBenefitItem("✓ Premium badge on your profile", fontSize),
              _buildBenefitItem("✓ No ads in the app", fontSize),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.zGreen, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                shadows: [
                  Shadow(blurRadius: 3, color: Colors.black.withOpacity(0.3)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
