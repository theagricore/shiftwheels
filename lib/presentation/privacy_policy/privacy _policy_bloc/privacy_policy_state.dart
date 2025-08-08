part of 'privacy_policy_bloc.dart';

sealed class PrivacyPolicyState extends Equatable {
  const PrivacyPolicyState();
  
  @override
  List<Object> get props => [];
}

final class PrivacyPolicyInitial extends PrivacyPolicyState {}
class PrivacyPolicyLoading extends PrivacyPolicyState {}

class PrivacyPolicyLoaded extends PrivacyPolicyState {
  final String content;
  
  const PrivacyPolicyLoaded(this.content);

  @override
  List<Object> get props => [content];
}

class PrivacyPolicyError extends PrivacyPolicyState {
  final String message;
  
  const PrivacyPolicyError(this.message);

  @override
  List<Object> get props => [message];
}