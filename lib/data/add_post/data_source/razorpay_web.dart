import 'dart:js' as js;
import 'package:flutter/foundation.dart';

void openRazorpayWebCheckout({
  required String name,
  required String description,
  required String email,
  required double amount,
  required void Function(String paymentId) onSuccess,
  required void Function(String error) onFailure,
}) {
  try {
    if (js.context['Razorpay'] == null || js.context['_razorpayLoaded'] != true) {
      throw Exception('Razorpay SDK not loaded');
    }

    final options = js.JsObject.jsify({
      'key': 'rzp_test_43KakF16hnEI0o', 
      'amount': (amount * 100).toInt(),
      'currency': 'INR',
      'name': name,
      'description': description,
      'prefill': {
        'email': email,
      },
      'handler': js.allowInterop((response) {
        final paymentId = response['razorpay_payment_id'] as String?;
        if (paymentId != null) {
          onSuccess(paymentId);
        } else {
          onFailure('Payment ID not received');
        }
      }),
      'modal': {
        'ondismiss': js.allowInterop(() {
          onFailure('Payment window closed by user');
        }),
      },
    });

    final razorpay = js.JsObject(js.context['Razorpay'], [options]);

    razorpay.callMethod('open', []);
  } catch (e) {
    if (kDebugMode) {
      print('Razorpay initialization error: $e');
    }
    onFailure('Failed to initialize Razorpay: $e');
  }
}