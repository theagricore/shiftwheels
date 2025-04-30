import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/auth/models/user_sigin_model.dart';
import 'package:shiftwheels/domain/auth/repository/auth_repository.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class SiginUsecase implements UseCase<Either,UserSiginModel> {
  @override
  Future<Either> call({UserSiginModel? param})async {
    return sl<AuthRepository>().signIn(param!);
  }

  
}