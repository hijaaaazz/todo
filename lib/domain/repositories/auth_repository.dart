import 'package:dartz/dartz.dart';
import 'package:tudu/domain/enities/user_entity.dart';

abstract class AuthRepository{
  Future<Either<String,UserEntity>> isLoggedIn();
  Future<Either<String,UserEntity>> signInwithGoogle();
  Future<Either<String,bool>> signOut();

}