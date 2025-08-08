import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shiftwheels/data/add_post/data_source/privacy_policy_source.dart';

part 'terms_conditions_event.dart';
part 'terms_conditions_state.dart';

class TermsBloc extends Bloc<TermsEvent, TermsState> {
  final PrivacyPolicySource _privacyPolicySource;

  TermsBloc(this._privacyPolicySource) : super(TermsInitial()) {
    on<LoadTermsEvent>((event, emit) async {
      emit(TermsLoading());
      try {
        final terms = await _privacyPolicySource.getTeramsAndConditions();
        emit(TermsLoaded(terms));
      } catch (e) {
        emit(TermsError(e.toString()));
      }
    });
  }
}