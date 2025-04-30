import 'package:dartz/dartz.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shiftwheels/data/auth/models/user_sigin_model.dart';

abstract class FirebaseAuthService {
  Future<Either> signup(UserModel user);
  Future<Either> signin(UserSiginModel user);
  Future<bool> isLoggedin();
  Future<Either> logout();
  Future<Either> passwordResetEmail(String email);
}

class AuthFirebaseServiceImpl extends FirebaseAuthService {
  @override
  Future<Either> signup(UserModel user) async {
    try {
      var returnedData = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: user.email!,
            password: user.password!,
          );
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(returnedData.user!.uid)
          .set({
            'fullName': user.fullName,
            'email': user.email,
            'phoneNo': user.phoneNo,
            'password': user.password,
            'uid': returnedData.user!.uid,
            'createdAt': FieldValue.serverTimestamp(),
          });

      return const Right("Sign up was successful");
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = "The password provided is too weak";
      } else if (e.code == 'email-already-in-use') {
        message = "An account already exists with this email";
      } else {
        message = e.message ?? "An unknown error occurred";
      }
      return Left(message);
    } catch (e) {
      return Left("An unexpected error occurred: $e");
    }
  }

  @override
  Future<Either> signin(UserSiginModel user) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );
      return const Right("Sign in was successful");
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        message = "User not found for this email";
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        message = "Wrong password provided for the user";
      } else {
        message = e.message ?? "An unknown error occurred";
      }
      return Left(message);
    } catch (e) {
      return Left("An unexpected error occurred: $e");
    }
  }

  @override
  Future<bool> isLoggedin() async {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<Either> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return const Right("log out successful");
    } catch (e) {
      return Left("Failed to log out: $e");
    }
  }

  @override
  Future<Either> passwordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return Right("Password reset email sent successfully");
    } on FirebaseAuthException catch (e) {
      String message = 'Failed to send reset email';
      if (e.code == 'user-not-found') {
        message = 'No user found with this email';
      } else if (e.code == 'too-many-requests') {
        message = 'Too many requests. Please try again later';
      } else {
        message = e.message ?? 'An error occurred';
      }
      return Left(message);
    } catch (e) {
      return Left("An unexpected error occurred: $e");
    }
  }
}
