import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/add_post/models/chat_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class GetUserChatsStreamUsecase 
    implements UseCase<Either<String, Stream<List<ChatModel>>>, String> {
  final PostRepository repository;

  GetUserChatsStreamUsecase(this.repository);

  @override
  Future<Either<String, Stream<List<ChatModel>>>> call({String? param}) async {
    if (param == null) {
      return Left('User ID cannot be null');
    }
    return await repository.getUserChatsStream(param);
  }
}