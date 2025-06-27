import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/domain/auth/repository/auth_repository.dart';

class UpdateProfileImageUsecase implements UseCase<Either<String, void>, String> {
  final AuthRepository repository;

  UpdateProfileImageUsecase(this.repository);

  @override
  Future<Either<String, void>> call({String? param}) async {
    return await repository.updateProfileImage(param!);
  }
}