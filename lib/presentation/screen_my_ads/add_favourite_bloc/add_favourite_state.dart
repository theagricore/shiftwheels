part of 'add_favourite_bloc.dart';

abstract class AddFavouriteState extends Equatable {
  const AddFavouriteState();

  @override
  List<Object> get props => [];
}

class AddFavouriteInitial extends AddFavouriteState {}

class AddFavouriteLoading extends AddFavouriteState {}

class AddFavouriteError extends AddFavouriteState {
  final String message;

  const AddFavouriteError(this.message);

  @override
  List<Object> get props => [message];
}

class FavoritesLoaded extends AddFavouriteState {
  final List<AdWithUserModel> favorites;

  const FavoritesLoaded(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class FavoriteToggled extends AddFavouriteState {
  final String adId;
  final bool isNowFavorite;

  const FavoriteToggled(this.adId, this.isNowFavorite);

  @override
  List<Object> get props => [adId, isNowFavorite];
}
