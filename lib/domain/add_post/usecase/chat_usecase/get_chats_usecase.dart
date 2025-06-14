import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/add_post/models/chat_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class GetChatsUseCase implements UseCase<Stream<List<ChatModel>>, String> {
  final PostRepository repository;

  GetChatsUseCase(this.repository);

  @override
  Stream<List<ChatModel>> call({String? param}) {
    return repository.getChatsForUser(param!);
  }
}