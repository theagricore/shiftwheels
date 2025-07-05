import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shiftwheels/data/add_post/data_source/cloudinary_service.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';
import 'package:shiftwheels/data/add_post/models/user_post_limit.dart';
import 'package:shiftwheels/domain/add_post/usecase/check_post_limit_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/create_payment_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/post_ad_usecase.dart';

part 'post_ad_event.dart';
part 'post_ad_state.dart';

class PostAdBloc extends Bloc<PostAdEvent, PostAdState> {
  final PostAdUsecase postAdUsecase;
  final CloudinaryService cloudinaryService;
  final CheckPostLimitUsecase checkPostLimitUsecase;
  final CreatePaymentUsecase createPaymentUsecase;

  PostAdBloc({
    required this.postAdUsecase,
    required this.cloudinaryService,
    required this.checkPostLimitUsecase,
    required this.createPaymentUsecase,
  }) : super(PostAdInitial()) {
    on<SubmitAdEvent>(_onSubmitAd);
    on<CheckPostLimitEvent>(_onCheckPostLimit);
  }

  Future<void> _onCheckPostLimit(
    CheckPostLimitEvent event,
    Emitter<PostAdState> emit,
  ) async {
    emit(PostAdLoading());
    final result = await checkPostLimitUsecase.call(param: event.userId);

    if (isClosed) return;

    result.fold(
      (error) => emit(PostAdError(error)),
      (limit) => emit(PostLimitChecked(limit)),
    );
  }

  Future<void> _onSubmitAd(
    SubmitAdEvent event,
    Emitter<PostAdState> emit,
  ) async {
    emit(PostAdLoading());

    try {
      // First check post limit
      final limitResult = await checkPostLimitUsecase.call(param: event.userId);

      if (isClosed) return;

      await limitResult.fold(
        (error) async {
          emit(PostAdError(error));
        },
        (limit) async {
          if (limit.hasReachedLimit && !limit.isPremiumActive) {
            emit(PostLimitReached(limit));
            return;
          }

          // Continue with ad posting if limit not reached or user is premium
          final uploadResult = await cloudinaryService.uploadImages(
            event.imageFiles.map((path) => File(path)).toList(),
          );

          if (isClosed) return;

          await uploadResult.fold(
            (error) async {
              emit(PostAdError('Image upload failed: $error'));
            },
            (imageUrls) async {
              if (imageUrls.isEmpty) {
                emit(PostAdError('No images were uploaded successfully'));
                return;
              }

              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser == null || currentUser.uid != event.userId) {
                emit(PostAdError('User not authenticated or ID mismatch'));
                return;
              }

              final ad = AdsModel(
                userId: event.userId,
                brand: event.brand,
                model: event.model,
                fuelType: event.fuelType,
                transmissionType: event.transmissionType,
                year: event.year,
                kmDriven: event.kmDriven,
                noOfOwners: event.noOfOwners,
                description: event.description,
                location: event.location,
                imageUrls: imageUrls,
                price: event.price,
                postedDate: DateTime.now(),
              );

              final result = await postAdUsecase.call(param: ad);

              if (isClosed) return;

              await result.fold(
                (error) async {
                  emit(PostAdError(error));
                },
                (adId) async {
                  // Increment post count only for free users
                  if (!limit.isPremiumActive) {
                    await postAdUsecase.incrementPostCount(event.userId);
                  }
                  if (!isClosed) {
                    emit(PostAdSuccess(adId));
                  }
                },
              );
            },
          );
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(PostAdError('Failed to post ad: ${e.toString()}'));
      }
    }
  }
}