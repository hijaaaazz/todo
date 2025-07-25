import 'package:dartz/dartz.dart';
import 'package:tudu/core/usecase/usecase.dart';
import 'package:tudu/domain/enities/user_entity.dart';
import 'package:tudu/domain/repositories/auth_repository.dart';
import 'package:tudu/service_locator.dart';

class SignInwithGoogleUsecase implements Usecase<Either<String,UserEntity>, NoParams> {
  @override
  Future<Either<String,UserEntity>> call({required NoParams params}) async {
    return sl<AuthRepository>().signInwithGoogle();
  }
}