import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

part 'add_favourite_event.dart';
part 'add_favourite_state.dart';

class AddFavouriteBloc extends Bloc<AddFavouriteEvent, AddFavouriteState> {
  final PostRepository postRepository;

  AddFavouriteBloc(this.postRepository) : super(AddFavouriteInitial()) {
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<LoadFavoritesEvent>(_onLoadFavorites);
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<AddFavouriteState> emit,
  ) async {
    emit(AddFavouriteLoading());

    final toggleResult = await postRepository.toggleFavorite(
      event.adId,
      event.userId,
    );

    if (toggleResult.isLeft()) {
      emit(AddFavouriteError(toggleResult.fold((l) => l, (_) => '')));
      return;
    }

    final updatedFavoritesResult = await postRepository.getUserFavorites(
      event.userId,
    );

    updatedFavoritesResult.fold(
      (error) => emit(AddFavouriteError(error)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<AddFavouriteState> emit,
  ) async {
    emit(AddFavouriteLoading());
    final result = await postRepository.getUserFavorites(event.userId);

    result.fold(
      (error) => emit(AddFavouriteError(error)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }
}
