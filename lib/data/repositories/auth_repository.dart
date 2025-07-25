import 'package:dartz/dartz.dart';
import 'package:tudu/data/services/auth_service.dart';
import 'package:tudu/domain/enities/user_entity.dart';
import 'package:tudu/domain/repositories/auth_repository.dart';
import 'package:tudu/service_locator.dart';

class AuthRepoImp implements AuthRepository {
  final _authService = sl<AuthFirebaseService>();

  @override
  Future<Either<String, UserEntity>> isLoggedIn() async {
    final result = await _authService.isLoggedIn();
    return result.fold(
      (failure) => Left(failure),
      (userModel) => Right(userModel.toEntity()),
    );
  }

  @override
  Future<Either<String, UserEntity>> signInwithGoogle() async {
    final result = await _authService.signInWithGoogle();
    return result.fold(
      (failure) => Left(failure),
      (userModel) => Right(userModel.toEntity()),
    );
  }

  @override
  Future<Either<String, bool>> signOut() async {
    return await _authService.logout();
  }
}
