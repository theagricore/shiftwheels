import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/add_post/models/chat_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class GetUserChatsUsecase implements UseCase<Either<String, List<ChatModel>>, String> {
  final PostRepository repository;

  GetUserChatsUsecase(this.repository);

  @override
  Future<Either<String, List<ChatModel>>> call({String? param}) async {
    if (param == null) {
      return Left('User ID cannot be null');
    }
    return await repository.getUserChats(param);
  }
}