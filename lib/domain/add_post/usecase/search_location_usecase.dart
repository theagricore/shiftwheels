import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class SearchLocationUsecase implements UseCase<Either<String, List<LocationModel>>, String> {
  @override
  Future<Either<String, List<LocationModel>>> call({String? param}) async {
    if (param == null || param.isEmpty) {
      return Left('Search query cannot be empty');
    }
    return await sl<PostRepository>().searchLocation(param);
  }
}