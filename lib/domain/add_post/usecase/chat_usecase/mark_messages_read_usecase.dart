import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class MarkMessagesReadUsecase implements UseCase<Either<String, void>, MarkMessagesReadParams> {
  final PostRepository repository;

  MarkMessagesReadUsecase(this.repository);

  @override
  Future<Either<String, void>> call({MarkMessagesReadParams? param}) async {
    if (param == null) {
      return Left('MarkMessagesReadParams cannot be null');
    }
    return await repository.markMessagesAsRead(param.chatId, param.userId);
  }
}

class MarkMessagesReadParams {
  final String chatId;
  final String userId;

  MarkMessagesReadParams({
    required this.chatId,
    required this.userId,
  });
}