import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/domain/auth/repository/auth_repository.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class GetUserDataUsecase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic param}) async {
    return await sl<AuthRepository>().getUser();
  }
}