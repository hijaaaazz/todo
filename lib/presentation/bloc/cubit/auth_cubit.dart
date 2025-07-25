


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/presentation/bloc/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

 Future<void> checkAuthStatus() async {
  emit(AuthLoading());
 
}


Future<void> signInWithGoogle() async {
  try {
    emit(AuthLoading());
   
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}

 Future<void> logOut() async {
  try {
    emit(AuthLoading());
  
    
  } catch (e) {
    emit(AuthError(e.toString()));
    emit(Unauthenticated());
  }
}


}
