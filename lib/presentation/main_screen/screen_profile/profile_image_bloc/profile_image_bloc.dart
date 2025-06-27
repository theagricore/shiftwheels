import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

part 'profile_image_event.dart';
part 'profile_image_state.dart';

class ProfileImageBloc extends Bloc<ProfileImageEvent, ProfileImageState> {
  ProfileImageBloc() : super(ProfileImageInitial()) {
    on<PickProfileImageEvent>((event, emit) async {
      try {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: event.source);
        if (image != null) {
          emit(ProfileImagePicked(File(image.path)));
        } else {
          emit(const ProfileImageError('No image selected'));
        }
      } catch (e) {
        emit(ProfileImageError('Failed to pick image: $e'));
      }
    });

    on<ConfirmProfileImageEvent>((event, emit) {
      emit(ProfileImageConfirmed(event.image));
    });
  }
}