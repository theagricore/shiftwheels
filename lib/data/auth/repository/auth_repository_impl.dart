import 'package:dartz/dartz.dart';
import 'package:shiftwheels/data/auth/dataSource/firebase_auth_service.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/data/auth/models/user_sigin_model.dart';
import 'package:shiftwheels/domain/auth/repository/auth_repository.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signup(UserModel user) async {
    return await sl<FirebaseAuthService>().signup(user);
  }

  @override
  Future<Either> signIn(UserSiginModel user) async {
    return await sl<FirebaseAuthService>().signin(user);
  }

  @override
  Future<bool> isLoggedin() async {
    return await sl<FirebaseAuthService>().isLoggedin();
  }

  @override
  Future<Either> logout() async {
    return await sl<FirebaseAuthService>().logout();
  }

  @override
  Future<Either> passwordResetEmail(String email) async {
    return await sl<FirebaseAuthService>().passwordResetEmail(email);
  }
}
