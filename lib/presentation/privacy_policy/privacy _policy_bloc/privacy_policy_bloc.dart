import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shiftwheels/data/add_post/data_source/privacy_policy_source.dart';

part 'privacy_policy_event.dart';
part 'privacy_policy_state.dart';

class PrivacyPolicyBloc extends Bloc<PrivacyPolicyEvent, PrivacyPolicyState> {
  final PrivacyPolicySource _privacyPolicySource;

  PrivacyPolicyBloc(this._privacyPolicySource) : super(PrivacyPolicyInitial()) {
    on<LoadPrivacyPolicyEvent>((event, emit) async {
      emit(PrivacyPolicyLoading());
      try {
        final policy = await _privacyPolicySource.getPrivacyPolicy();
        emit(PrivacyPolicyLoaded(policy));
      } catch (e) {
        emit(PrivacyPolicyError(e.toString()));
      }
    });
  }
}