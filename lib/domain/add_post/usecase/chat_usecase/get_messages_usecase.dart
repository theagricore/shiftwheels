import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/add_post/models/message_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class GetMessagesUseCase implements UseCase<Stream<List<MessageModel>>, String> {
  final PostRepository repository;

  GetMessagesUseCase(this.repository);

  @override
  Stream<List<MessageModel>> call({String? param}) {
    return repository.getMessagesForChat(param!);
  }
}