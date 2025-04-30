import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/domain/auth/repository/auth_repository.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';


class IsLoggedinusecase implements UseCase<bool,dynamic> {
  @override
  Future<bool> call({param})async {
   return await sl<AuthRepository>().isLoggedin();
  }
}