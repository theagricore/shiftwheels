import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/widget/animated_lottie_button_widget.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/data_source/razorpay_service.dart';
import 'package:shiftwheels/data/add_post/models/payment_model.dart';
import 'package:shiftwheels/data/add_post/models/user_post_limit.dart';
import 'package:shiftwheels/domain/add_post/usecase/create_payment_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/update_payment_status_usecase.dart';
import 'package:shiftwheels/service_locater/service_locater.dart' as di;

class ScreenPayment extends StatefulWidget {
  final UserPostLimit limit;
  final String userId;

  const ScreenPayment({
    Key? key,
    required this.limit,
    required this.userId,
  }) : super(key: key);

  @override
  State<ScreenPayment> createState() => _ScreenPaymentState();
}

class _ScreenPaymentState extends State<ScreenPayment> {
  final RazorpayService _razorpayService = RazorpayService();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _razorpayService.init(
      onSuccess: _handlePaymentSuccess,
      onError: _handlePaymentError,
    );
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
        adId: '',
        amount: 100,
        paymentDate: DateTime.now(),
        paymentStatus: 'Success',
        transactionId: paymentId,
      );

      // Get instances from service locator
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
              Navigator.of(context).pop(true); // Return success
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
    BasicSnackbar(
      message: message,
      backgroundColor: Colors.red,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: BasicAppbar(backgroundColor: AppColors.zTransprant),
      body: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset(
              'assets/images/Animation - yellow.json',
              fit: BoxFit.cover,
              repeat: false,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
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
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  "Get unlimited posts for 30 days by upgrading to premium for just ₹100",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                _buildPremiumBenefits(),
                const SizedBox(height: 30),
                AnimatedLottieButtonWidget(
                  animationAsset: "assets/images/Animation -Premium.json",
                  onTap: _isProcessing
                      ? () {}
                      : () {
                          setState(() => _isProcessing = true);
                          _razorpayService.openPaymentGateway(
                            amount: 100,
                            description: 'Premium subscription',
                            userId: widget.userId,
                            adId: '',
                          );
                        },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColors.zWhite),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBenefits() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Premium Benefits",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            _buildBenefitItem("✓ Unlimited posts for 30 days"),
            _buildBenefitItem("✓ Priority listing in search results"),
            _buildBenefitItem("✓ Premium badge on your profile"),
            _buildBenefitItem("✓ No ads in the app"),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}