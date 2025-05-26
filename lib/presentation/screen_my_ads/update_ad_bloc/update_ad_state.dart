part of 'update_ad_bloc.dart';

sealed class UpdateAdState extends Equatable {
  const UpdateAdState();
  
  @override
  List<Object> get props => [];
}

final class UpdateAdInitial extends UpdateAdState {}

final class UpdateAdLoading extends UpdateAdState {}

final class AdUpdated extends UpdateAdState {}

final class UpdateAdError extends UpdateAdState {
  final String message;
  
  const UpdateAdError(this.message);
  
  @override
  List<Object> get props => [message];
}