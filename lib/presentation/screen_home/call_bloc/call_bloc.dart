// call_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:url_launcher/url_launcher.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  CallBloc() : super(CallInitial()) {
    on<MakePhoneCall>(_onMakePhoneCall);
  }

  Future<void> _onMakePhoneCall(
    MakePhoneCall event,
    Emitter<CallState> emit,
  ) async {
    emit(CallLoading());
    try {
      final phoneNumber = event.phoneNumber;
      final url = Uri.parse('tel:$phoneNumber');
      
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
        emit(CallSuccess());
      } else {
        emit(CallFailure('Could not launch phone call'));
      }
    } catch (e) {
      emit(CallFailure('Failed to make call: ${e.toString()}'));
    }
  }
}