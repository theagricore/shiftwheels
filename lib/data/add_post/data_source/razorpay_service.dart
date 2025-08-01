import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/foundation.dart';

typedef PaymentSuccessCallback = void Function(String paymentId);
typedef PaymentFailureCallback = void Function(String error);

class RazorpayService {
  final Razorpay? _razorpay = kIsWeb ? null : Razorpay();
  PaymentSuccessCallback? onSuccess;
  PaymentFailureCallback? onFailure;

  RazorpayService() {
    if (!kIsWeb) {
      _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }
  }

  void openCheckOut({
    required double amount,
    required String description,
    required PaymentSuccessCallback onSuccess,
    required PaymentFailureCallback onFailure,
  }) {
    if (kIsWeb) {
      onFailure('Razorpay is not supported on web. Use openRazorpayWebCheckout instead.');
      return;
    }

    this.onSuccess = onSuccess;
    this.onFailure = onFailure;

    var options = {
      'key': 'rzp_test_43KakF16hnEI0o', 
      'amount': (amount * 100).toInt(), 
      'name': 'ShiftWheels',
      'description': description,
      'prefill': {
        'contact': '',
        'email': '',
      },
      'external': {
        'wallets': ['paytm', 'phonepe', 'gpay']
      }
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      onFailure('Failed to open payment gateway: ${e.toString()}');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    onSuccess?.call(response.paymentId ?? '');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    onFailure?.call(response.message ?? "Payment failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet selection if needed
  }

  void dispose() {
    if (!kIsWeb) {
      _razorpay!.clear();
    }
  }
}