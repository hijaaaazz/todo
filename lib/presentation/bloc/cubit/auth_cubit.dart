import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/core/usecase/usecase.dart';
import 'package:tudu/domain/usecases/authentication/current_user.dart';
import 'package:tudu/domain/usecases/authentication/logout.dart';
import 'package:tudu/domain/usecases/authentication/sign_in.dart';
import 'package:tudu/presentation/bloc/cubit/auth_state.dart';
import 'package:tudu/service_locator.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

 Future<void> checkAuthStatus() async {
  emit(AuthLoading());
  final result = await sl<GetCurrentUserUsecase>().call(params: NoParams());

  result.fold(
    (failure) {
      emit(AuthError(failure));
      emit(Unauthenticated());
    },
    (user) {
      emit(Authenticated(user:  user));
    },
  );
}


Future<void> signInWithGoogle() async {

  log("bloc started");
  try {
    emit(AuthLoading());
    final result = await sl<SignInwithGoogleUsecase>().call(params: NoParams());

    result.fold(
      (failure) async {
        emit(AuthError(failure));

      },
      (user) {
        emit(Authenticated(user: user));
      },
    );
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}

 Future<void> logOut() async {
  try {
    emit(AuthLoading());
    log("hydcuyd");

    final result = await sl<LogoutUsecase>().call(params: NoParams());
    log(result.toString());

    result.fold(
      
      (failure) async {
        emit(AuthError(failure));
        await Future.delayed(Duration(milliseconds: 300));
        emit(Unauthenticated());
      },
      (_) {
        emit(Unauthenticated()); 
      },
    );
  } catch (e) {
    emit(AuthError(e.toString()));
    emit(Unauthenticated());
  }
}


}
