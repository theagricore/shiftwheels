import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/domain/auth/repository/auth_repository.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class SiginupUsecase implements UseCase<Either,UserModel> {
  @override
  Future<Either> call({UserModel? param}) async{
    return await sl<AuthRepository>().signup(param!);
  }
  
}