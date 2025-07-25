import 'package:dartz/dartz.dart';
import 'package:tudu/core/usecase/usecase.dart';
import 'package:tudu/domain/repositories/auth_repository.dart';
import 'package:tudu/service_locator.dart';

class LogoutUsecase implements Usecase<Either<String,bool>, NoParams> {
  @override
  Future<Either<String, bool>> call({required NoParams params}) async {
    return sl<AuthRepository>().signOut();
  }
}