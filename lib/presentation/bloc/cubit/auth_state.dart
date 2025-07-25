
import 'package:tudu/domain/enities/user_entity.dart';


abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  Authenticated({required this.user});
}


class AuthLoading extends AuthState {}




class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}


