import 'dart:async' show Future;
import 'dart:core';

import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/data_source/razorpay_mobile.dart';
import 'package:shiftwheels/data/add_post/data_source/razorpay_service.dart';
import 'package:shiftwheels/data/add_post/models/payment_model.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/create_payment_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/update_payment_status_usecase.dart';
import 'package:shiftwheels/domain/auth/usecase/get_user_data_usecase.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';
import 'package:flutter/foundation.dart';

class PaymentController {
  UserModel? _userModel;
  bool isProcessingPayment = false;
  final double _premiumAmount = 100.0;

  UserModel? get userModel => _userModel;
  bool get isProcessing => isProcessingPayment;

  Future <void> fetchUserData(void Function() setStateCallback) async {
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

            setStateCallback();
            _userModel = userModel;
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

  Future<void> initiatePremiumPayment(
    String userId,
    void Function(bool) setProcessingState,
    void Function(bool) onSuccess,
  ) async {
    if (_userModel == null || _userModel!.email == null) {
      BasicSnackbar(
        message: 'User data or email not available',
        backgroundColor: AppColors.zred,
      );
      return;
    }

    setProcessingState(true);

    try {
      final paymentModel = PaymentModel(
        id: '',
        userId: userId,
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
          setProcessingState(false);
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
                    handlePaymentSuccess(firestorePaymentId, paymentId, setProcessingState, onSuccess),
                onFailure: (error) {
                  BasicSnackbar(
                    message: 'Web payment failed: $error',
                    backgroundColor: AppColors.zred,
                  );
                  setProcessingState(false);
                },
              );
            } catch (e) {
              BasicSnackbar(
                message: 'Web payment initialization failed: $e',
                backgroundColor: AppColors.zred,
              );
              setProcessingState(false);
            }
          } else {
            try {
              final razorpay = sl<RazorpayService>();
              razorpay.openCheckOut(
                amount: _premiumAmount,
                description: 'Premium upgrade for ${paymentModel.userName}',
                onSuccess: (razorpayPaymentId) =>
                    handlePaymentSuccess(firestorePaymentId, razorpayPaymentId, setProcessingState, onSuccess),
                onFailure: (error) {
                  BasicSnackbar(
                    message: 'Mobile payment failed: $error',
                    backgroundColor: AppColors.zred,
                  );
                  setProcessingState(false);
                },
              );
            } catch (e) {
              BasicSnackbar(
                message: 'Mobile payment initialization failed: $e',
                backgroundColor: AppColors.zred,
              );
              setProcessingState(false);
            }
          }
        },
      );
    } catch (e) {
      BasicSnackbar(
        message: 'Error initiating payment: $e',
        backgroundColor: AppColors.zred,
      );
      setProcessingState(false);
    }
  }

  Future<void> handlePaymentSuccess(
    String firestorePaymentId,
    String razorpayPaymentId,
    void Function(bool) setProcessingState,
    void Function(bool) onSuccess,
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
          setProcessingState(false);
        },
        (_) async {
          BasicSnackbar(
            message: 'Payment successful! You are now a premium user.',
            backgroundColor: AppColors.zGreen,
          );
          onSuccess(true);
        },
      );
    } catch (e) {
      BasicSnackbar(
        message: 'Error processing payment: $e',
        backgroundColor: AppColors.zred,
      );
      setProcessingState(false);
    }
  }
}