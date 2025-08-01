import 'package:razorpay_flutter/razorpay_flutter.dart';

void openRazorpayWebCheckout({
  required String name,
  required String description,
  required String email,
  required double amount,
  required void Function(String paymentId) onSuccess,
  required void Function(String error) onFailure,
}) {
  throw UnsupportedError('Use RazorpayService for mobile payments');
}