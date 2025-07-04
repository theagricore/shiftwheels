import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/add_post/models/payment_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class CreatePaymentUsecase implements UseCase<Either<String, String>, PaymentModel> {
  final PostRepository repository;

  CreatePaymentUsecase(this.repository);

  @override
  Future<Either<String, String>> call({PaymentModel? param}) async {
    if (param == null) {
      return Left('Payment details cannot be empty');
    }
    return await repository.createPaymentRecord(param);
  }
}