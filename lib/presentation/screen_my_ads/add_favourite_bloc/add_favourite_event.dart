part of 'add_favourite_bloc.dart';

abstract class AddFavouriteEvent extends Equatable {
  const AddFavouriteEvent();

  @override
  List<Object> get props => [];
}

class ToggleFavoriteEvent extends AddFavouriteEvent {
  final String adId;
  final String userId;

  const ToggleFavoriteEvent(this.adId, this.userId);

  @override
  List<Object> get props => [adId, userId];
}

class LoadFavoritesEvent extends AddFavouriteEvent {
  final String userId;

  const LoadFavoritesEvent(this.userId);

  @override
  List<Object> get props => [userId];
}