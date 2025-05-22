import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'get_images_event.dart';
part 'get_images_state.dart';

class GetImagesBloc extends Bloc<GetImagesEvent, GetImagesState> {
  GetImagesBloc() : super(GetImagesInitial()) {
    on<PickImageEvent>(_onPickImage);
    on<RemoveImageEvent>(_onRemoveImage);
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _onPickImage(
  PickImageEvent event,
  Emitter<GetImagesState> emit,
) async {
  try {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      final currentState = state;
      if (currentState is ImagesSelectedState) {
        emit(ImagesSelectedState(
          imagePaths: [...currentState.imagePaths, ...images.map((e) => e.path)],
        ));
      } else {
        emit(ImagesSelectedState(
          imagePaths: images.map((e) => e.path).toList(),
        ));
      }
    }
  } catch (e) {
    emit(GetImagesError(e.toString()));
  }
}

  void _onRemoveImage(
    RemoveImageEvent event,
    Emitter<GetImagesState> emit,
  ) {
    final currentState = state;
    if (currentState is ImagesSelectedState) {
      final newImages = List<String>.from(currentState.imagePaths)
        ..removeAt(event.index);
      emit(ImagesSelectedState(imagePaths: newImages));
    }
  }
}