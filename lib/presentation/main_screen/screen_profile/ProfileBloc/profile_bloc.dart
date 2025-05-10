import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shiftwheels/data/auth/models/get_user_data.dart';
import 'package:shiftwheels/domain/auth/entitys/user_entity.dart';
import 'package:shiftwheels/domain/auth/usecase/get_user_data_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserDataUsecase getUserDataUsecase;

  ProfileBloc({required this.getUserDataUsecase}) : super(Profileloading()) {
    on<FetchUserProfile>(_onFetchUserProfile);
  }

 Future<void> _onFetchUserProfile(
  FetchUserProfile event,
  Emitter<ProfileState> emit,
) async {
  try {
    emit(Profileloading());
    final result = await getUserDataUsecase.call();
    result.fold(
      (error) => emit(ProfileInfoFailure(message: error.toString())),
      (userData) {
        if (userData is Map<String, dynamic>) {
          try {
            final user = GetUserData.fromMap(userData).toEntity();
            emit(Profileloaded(user: user));
          } catch (e) {
            emit(ProfileInfoFailure(message: 'Failed to parse user data: $e'));
          }
        } else {
          emit(ProfileInfoFailure(message: 'Invalid user data format'));
        }
      },
    );
  } catch (e) {
    emit(ProfileInfoFailure(message: 'Unexpected error: ${e.toString()}'));
  }
}
}
