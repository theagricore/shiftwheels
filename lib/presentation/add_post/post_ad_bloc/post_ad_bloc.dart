import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shiftwheels/data/add_post/data_source/cloudinary_service.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/post_ad_usecase.dart';

part 'post_ad_event.dart';
part 'post_ad_state.dart';

class PostAdBloc extends Bloc<PostAdEvent, PostAdState> {
  final PostAdUsecase postAdUsecase;
  final CloudinaryService cloudinaryService;

  PostAdBloc({
    required this.postAdUsecase,
    required this.cloudinaryService,
  }) : super(PostAdInitial()) {
    on<SubmitAdEvent>(_onSubmitAd);
  }

  Future<void> _onSubmitAd(
    SubmitAdEvent event,
    Emitter<PostAdState> emit,
  ) async {
    emit(PostAdLoading());
    
    try {
      final Either<String, List<String>> uploadResult = 
          await cloudinaryService.uploadImages(
        event.imageFiles.map((path) => File(path)).toList(),
      );

      return uploadResult.fold(
        (error) => emit(PostAdError('Image upload failed: $error')),
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

          final result = await postAdUsecase(param: ad);
          
          result.fold(
            (error) => emit(PostAdError(error)),
            (adId) => emit(PostAdSuccess(adId)),
          );
        },
      );
    } catch (e) {
      emit(PostAdError('Failed to post ad: ${e.toString()}'));
    }
  }
}