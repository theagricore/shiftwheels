import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shiftwheels/data/auth/models/user_sigin_model.dart';

abstract class FirebaseAuthService {
  Future<Either<String, String>> signup(UserModel user);
  Future<Either<String, String>> signin(UserSiginModel user);
  Future<bool> isLoggedin();
  Future<Either<String, String>> logout();
  Future<Either<String, String>> passwordResetEmail(String email);
  Future<Either<String, Map<String, dynamic>>> getUser();
  Future<Either<String, String>> signInWithGoogle();
  Future<Either<String, String>> updateProfileImage(String imageUrl);
}

class AuthFirebaseServiceImpl extends FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, String>> signup(UserModel user) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'fullName': user.fullName,
        'email': user.email,
        'phoneNo': user.phoneNo,
        'password': user.password,
        'uid': userCredential.user!.uid,
        'isBlocked': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return const Right("Sign-up successful");
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
  Future<Either<String, String>> signin(UserSiginModel user) async {
    try {
      final userQuery = await _firestore
          .collection('Users')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userData = userQuery.docs.first.data();
        if (userData['isBlocked'] == true) {
          return Left("Your account has been blocked by admin");
        }
      }

      await _auth.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );
      return const Right("Sign-in successful");
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
    return _auth.currentUser != null;
  }

  @override
  Future<Either<String, String>> logout() async {
    try {
      await _auth.signOut();
      return const Right("Logout successful");
    } catch (e) {
      return Left("Failed to log out: $e");
    }
  }

  @override
  Future<Either<String, String>> passwordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Right("Password reset email sent");
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

  @override
  Future<Either<String, Map<String, dynamic>>> getUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return Left("User not logged in");
      }

      final userDoc = await _firestore.collection('Users').doc(currentUser.uid).get();
      if (!userDoc.exists) {
        return Left("User data not found");
      }

      return Right(userDoc.data()!);
    } catch (e) {
      return Left("Failed to get user data: $e");
    }
  }

  @override
  Future<Either<String, String>> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return Left("Google sign-in was cancelled");
      }

      final userQuery = await _firestore
          .collection('Users')
          .where('email', isEqualTo: googleUser.email)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userData = userQuery.docs.first.data();
        if (userData['isBlocked'] == true) {
          return Left("Your account has been blocked by admin");
        }
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        await _firestore.collection('Users').doc(userCredential.user!.uid).set({
          'fullName': userCredential.user!.displayName ?? '',
          'email': userCredential.user!.email ?? '',
          'phoneNo': userCredential.user!.phoneNumber ?? '',
          'uid': userCredential.user!.uid,
          'isBlocked': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return const Right("Google sign-in successful");
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? "Google sign-in failed");
    } catch (e) {
      return Left("An unexpected error occurred: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, String>> updateProfileImage(String imageUrl) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return Left("User not logged in");
      }

      await _firestore.collection('Users').doc(currentUser.uid).update({
        'image': imageUrl,
      });

      return const Right("Profile image updated");
    } on FirebaseException catch (e) {
      return Left("Firebase error: ${e.message}");
    } catch (e) {
      return Left("Failed to update profile image: ${e.toString()}");
    }
  }
}