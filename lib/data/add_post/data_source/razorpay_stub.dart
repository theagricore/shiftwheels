void openRazorpayWebCheckout({
  required String name,
  required String description,
  required String email,
  required double amount,
  required void Function(String paymentId) onSuccess,
  required void Function(String error) onFailure,
}) {
  throw UnsupportedError('Cannot open Razorpay on this platform');
}