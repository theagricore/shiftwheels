import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

part 'get_images_event.dart';
part 'get_images_state.dart';

class GetImagesBloc extends Bloc<GetImagesEvent, GetImagesState> {
  GetImagesBloc() : super(GetImagesInitial()) {
    on<PickImageEvent>(_onPickImage);
    on<RemoveImageEvent>(_onRemoveImage);
    on<SetInitialImages>((event, emit) {
      emit(ImagesSelectedState(imagePaths: event.initialImages));
    });
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _onPickImage(
    PickImageEvent event,
    Emitter<GetImagesState> emit,
  ) async {
    try {
      emit(GetImagesLoading());
      final imagePaths = await _pickImages();
      if (imagePaths.isNotEmpty) {
        final currentState = state;
        if (currentState is ImagesSelectedState) {
          emit(
            ImagesSelectedState(
              imagePaths: [...currentState.imagePaths, ...imagePaths],
            ),
          );
        } else {
          emit(ImagesSelectedState(imagePaths: imagePaths));
        }
      } else {
        emit(const GetImagesError('No images selected'));
      }
    } catch (e) {
      emit(GetImagesError(e.toString()));
    }
  }

  Future<List<String>> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      return images.map((e) => e.path).toList();
    } catch (e) {
      if (kIsWeb) {
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        return image != null ? [image.path] : [];
      }
      return [];
    }
  }

  void _onRemoveImage(RemoveImageEvent event, Emitter<GetImagesState> emit) {
    final currentState = state;
    if (currentState is ImagesSelectedState) {
      final newImages = List<String>.from(currentState.imagePaths)
        ..removeAt(event.index);
      emit(ImagesSelectedState(imagePaths: newImages));
    }
  }
}