import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  final Razorpay _razorpay = Razorpay();
  Function(String)? _onSuccess;
  Function(String)? _onError;

  void init({
    required Function(String) onSuccess,
    required Function(String) onError,
  }) {
    _onSuccess = onSuccess;
    _onError = onError;
    
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (_onSuccess != null) {
      _onSuccess!(response.paymentId!);
    }
  }   

  void _handlePaymentError(PaymentFailureResponse response) {
    if (_onError != null) {
      _onError!(response.message ?? 'Payment failed');
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (_onError != null) {
      _onError!('External wallet selected: ${response.walletName}');
    }
  }

  Future<void> openPaymentGateway({
    required double amount,
    required String description,
    required String userId,
    required String adId,
  }) async {
    try {
      final options = {
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

      _razorpay.open(options);
    } catch (e) {
      if (_onError != null) {
        _onError!('Failed to open payment gateway: ${e.toString()}');
      }
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}