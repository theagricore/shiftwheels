import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/add_post/models/message_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class GetChatMessagesUsecase implements UseCase<Either<String, Stream<List<MessageModel>>>, String> {
  final PostRepository repository;

  GetChatMessagesUsecase(this.repository);

  @override
  Future<Either<String, Stream<List<MessageModel>>>> call({String? param}) async {
    if (param == null) {
      return Left('Chat ID cannot be null');
    }
    return await repository.getChatMessages(param);
  }
}