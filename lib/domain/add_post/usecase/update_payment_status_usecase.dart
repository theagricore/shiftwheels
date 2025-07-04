import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class UpdatePaymentStatusUsecase implements UseCase<Either<String, void>, UpdatePaymentParams> {
  final PostRepository repository;

  UpdatePaymentStatusUsecase(this.repository);

  @override
  Future<Either<String, void>> call({UpdatePaymentParams? param}) async {
    if (param == null) {
      return Left('Payment details cannot be empty');
    }
    return await repository.updatePaymentStatus(
      paymentId: param.paymentId,
      status: param.status,
      transactionId: param.transactionId,
    );
  }
}

class UpdatePaymentParams {
  final String paymentId;
  final String status;
  final String transactionId;

  UpdatePaymentParams({
    required this.paymentId,
    required this.status,
    required this.transactionId,
  });
}