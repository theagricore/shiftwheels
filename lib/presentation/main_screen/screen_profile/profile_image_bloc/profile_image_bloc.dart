import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shiftwheels/data/add_post/data_source/cloudinary_service.dart';
import 'package:shiftwheels/domain/auth/usecase/update_profile_image_usecase.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';
import 'dart:io';

part 'profile_image_event.dart';
part 'profile_image_state.dart';

class ProfileImageBloc extends Bloc<ProfileImageEvent, ProfileImageState> {
  final CloudinaryService _cloudinaryService = sl<CloudinaryService>();
  final UpdateProfileImageUsecase _updateProfileImageUsecase = sl<UpdateProfileImageUsecase>();

  ProfileImageBloc() : super(ProfileImageInitial()) {
    on<PickProfileImageEvent>(_onPickProfileImage);
    on<ConfirmProfileImageEvent>(_onConfirmProfileImage);
  }

  Future<void> _onPickProfileImage(
    PickProfileImageEvent event,
    Emitter<ProfileImageState> emit,
  ) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: event.source,
        imageQuality: 85,
        maxWidth: 800,
      );
      
      if (image != null) {
        emit(ProfileImagePicked(File(image.path)));
      } else {
        emit(const ProfileImageError('No image selected'));
      }
    } catch (e) {
      emit(ProfileImageError('Failed to pick image: ${e.toString()}'));
    }
  }

  Future<void> _onConfirmProfileImage(
    ConfirmProfileImageEvent event,
    Emitter<ProfileImageState> emit,
  ) async {
    emit(ProfileImageLoading());
    
    try {
      // Upload image to Cloudinary
      final uploadResult = await _cloudinaryService.uploadProfileImage(event.image);
      
      // Handle upload result
      return await uploadResult.fold(
        (error) => emit(ProfileImageError(error)),
        (imageUrl) async {
          // Update profile with image URL
          final updateResult = await _updateProfileImageUsecase.call(param: imageUrl);
          
          updateResult.fold(
            (error) => emit(ProfileImageError(error)),
            (_) => emit(ProfileImageConfirmed(imageUrl: imageUrl)),
          );
        },
      );
    } catch (e) {
      emit(ProfileImageError('Unexpected error: ${e.toString()}'));
    }
  }
}