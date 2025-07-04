import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class ScreenPayment extends StatefulWidget {
  final UserPostLimit limit;
  final String userId;

  const ScreenPayment({super.key, required this.limit, required this.userId});

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
    setState(() => _isProcessing = true);

    final payment = PaymentModel(
      id: '',
      userId: widget.userId,
      adId: '',
      amount: 100,
      paymentDate: DateTime.now(),
      paymentStatus: 'Success',
      transactionId: paymentId,
    );

    final createResult = await context.read<CreatePaymentUsecase>().call(
      param: payment,
    );

    createResult.fold(
      (error) {
        BasicSnackbar(
          message: 'Payment record failed: $error',
          backgroundColor: Colors.red,
        ).show(context);
        setState(() => _isProcessing = false);
      },
      (paymentId) async {
        final updateResult = await context
            .read<UpdatePaymentStatusUsecase>()
            .call(
              param: UpdatePaymentParams(
                paymentId: paymentId,
                status: 'Success',
                transactionId: paymentId,
              ),
            );

        updateResult.fold(
          (error) {
            BasicSnackbar(
              message: 'Status update failed: $error',
              backgroundColor: Colors.red,
            ).show(context);
            setState(() => _isProcessing = false);
          },
          (_) {
            Navigator.of(context).pop(true); // Return success
          },
        );
      },
    );
  }

  void _handlePaymentError(String error) {
    BasicSnackbar(message: error, backgroundColor: Colors.red).show(context);
    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Lottie.asset(
            'assets/images/Animation - yellow.json',
            fit: BoxFit.cover,
            repeat: false,
          ),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: BasicAppbar(backgroundColor: AppColors.zTransprant),
          body: Padding(
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
                const SizedBox(height: 10),
                _buildPremiumBenefits(),
                const SizedBox(height: 10),

                const Spacer(),

                AnimatedLottieButtonWidget(
                  animationAsset: "assets/images/Animation -Premium.json",
                  onTap:
                      _isProcessing
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

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.zWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
