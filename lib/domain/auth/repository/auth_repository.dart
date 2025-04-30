import 'package:dartz/dartz.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/data/auth/models/user_sigin_model.dart';

abstract class AuthRepository {
  Future<Either> signup(UserModel user);
  Future<Either> signIn(UserSiginModel user);
  Future<bool> isLoggedin();
  Future<Either> logout();
  Future<Either> passwordResetEmail(String email);
}
