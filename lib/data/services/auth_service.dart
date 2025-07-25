import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tudu/data/models/user_model.dart';

abstract class AuthFirebaseService {
  Future<Either<String, UserModel>> signInWithGoogle();
  Future<Either<String, UserModel>> isLoggedIn();
  Future<Either<String, bool>> logout();
}

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<Either<String, UserModel>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return Left('Sign in aborted by you');

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;

      if (user == null) return Left('Google sign-in failed');
      final resultUser = UserModel(
        id: user.uid,
        name: user.displayName ?? '',
      );

      return Right(resultUser);
    } catch (e) {
      log(e.toString());
      return Left('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, UserModel>> isLoggedIn() async {
    final user = _auth.currentUser;

    if (user == null) return Left('No user logged in');

    final userModel = UserModel(
      id: user.uid,
      name: user.displayName ?? '',
    );

    return Right(userModel);
  }

  @override
  Future<Either<String, bool>> logout() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();

      return Right(true);
    } catch (e) {
      return Left('Logout failed: ${e.toString()}');
    }
  }
}
