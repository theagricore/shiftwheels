import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/widget/animated_lottie_button_widget.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/data_source/razorpay_service.dart';
import 'package:shiftwheels/data/add_post/models/payment_model.dart';
import 'package:shiftwheels/data/add_post/models/user_post_limit.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/create_payment_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/update_payment_status_usecase.dart';
import 'package:shiftwheels/service_locater/service_locater.dart' as di;

class ScreenPayment extends StatefulWidget {
  final UserPostLimit limit;
  final String userId;

  const ScreenPayment({Key? key, required this.limit, required this.userId})
    : super(key: key);

  @override
  State<ScreenPayment> createState() => _ScreenPaymentState();
}

class _ScreenPaymentState extends State<ScreenPayment> {
  final RazorpayService _razorpayService = RazorpayService();
  bool _isProcessing = false;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _razorpayService.init(
      onSuccess: _handlePaymentSuccess,
      onError: _handlePaymentError,
    );
  }

  Future<void> _loadUserData() async {
    try {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.userId)
              .get();

      if (userDoc.exists) {
        setState(() {
          _user = UserModel.fromMap(userDoc.data()!);
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(String paymentId) async {
    if (!mounted) return;

    setState(() => _isProcessing = true);

    try {
      final payment = PaymentModel(
        id: '',
        userId: widget.userId,
        userName: _user?.fullName ?? 'Unknown User',
        userEmail: _user?.email ?? '',
        userPhone: _user?.phoneNo,
        userImageUrl: _user?.image,
        adId: 'premium_upgrade',
        amount: 100,
        paymentDate: DateTime.now(),
        paymentStatus: 'Success',
        transactionId: paymentId,
        paymentType: 'premium_upgrade',
      );

      final createPaymentUsecase = di.sl<CreatePaymentUsecase>();
      final updatePaymentUsecase = di.sl<UpdatePaymentStatusUsecase>();

      final createResult = await createPaymentUsecase.call(param: payment);

      if (!mounted) return;

      await createResult.fold(
        (error) async {
          _showErrorSnackbar('Payment record failed: $error');
        },
        (paymentId) async {
          final updateResult = await updatePaymentUsecase.call(
            param: UpdatePaymentParams(
              paymentId: paymentId,
              status: 'Success',
              transactionId: paymentId,
            ),
          );

          if (!mounted) return;

          updateResult.fold(
            (error) {
              _showErrorSnackbar('Status update failed: $error');
            },
            (_) {
              Navigator.of(context).pop(true); 
            },
          );
        },
      );
    } catch (e) {
      _showErrorSnackbar('An unexpected error occurred: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _handlePaymentError(String error) {
    if (!mounted) return;
    _showErrorSnackbar(error);
    setState(() => _isProcessing = false);
  }

  void _showErrorSnackbar(String message) {
    BasicSnackbar(message: message, backgroundColor: Colors.red).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BasicAppbar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade800.withOpacity(0.9), 
              Colors.orange.shade400.withOpacity(0.9),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Lottie.asset(
                  'assets/images/Animation - yellow.json',
                  fit: BoxFit.cover,
                  repeat: false,
                ),
              ),
            ),

            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: kToolbarHeight + 20,
                    ), 
                    Container(
                      height: 200,
                      width: 200,
                      alignment: Alignment.center,
                      child: Lottie.asset(
                        'assets/images/Animation - Premium-icon.json',
                        fit: BoxFit.contain,
                        repeat: false,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Upgrade to Premium",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 30,
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
                          fontSize: 14,
                          color: AppColors.zWhite,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildPremiumBenefits(),
                    const SizedBox(height: 30),
                    if (_isProcessing)
                      const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: AnimatedLottieButtonWidget(
                          animationAsset:
                              "assets/images/Animation -Premium.json",
                          onTap: () {
                            if (_isProcessing) return;
                            setState(() => _isProcessing = true);
                            _razorpayService.openPaymentGateway(
                              amount: 100,
                              description: 'Premium subscription upgrade',
                              userId: widget.userId,
                              adId: 'premium_upgrade',
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 5,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumBenefits() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: Colors.white.withOpacity(0.2),
        margin: EdgeInsets.zero,
        elevation: 8, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.white.withOpacity(0.5),
            width: 1.5,
          ), // Stronger border
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
              _buildBenefitItem("✓ Unlimited posts for 30 days"),
              _buildBenefitItem("✓ No monthly posting limits"),
              _buildBenefitItem("✓ Priority listing in search results"),
              _buildBenefitItem("✓ Premium badge on your profile"),
              _buildBenefitItem("✓ No ads in the app"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6.0,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.zGreen,
            size: 22,
          ), 
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16, 
              ),
            ),
          ),
        ],
      ),
    );
  }
}
