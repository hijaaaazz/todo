import 'package:get_it/get_it.dart';
import 'package:tudu/data/repositories/auth_repository.dart';
import 'package:tudu/data/repositories/todo_repository.dart';
import 'package:tudu/data/services/auth_service.dart';
import 'package:tudu/data/services/todo_service.dart';
import 'package:tudu/domain/repositories/auth_repository.dart';
import 'package:tudu/domain/repositories/todo_repository.dart';
import 'package:tudu/domain/usecases/authentication/current_user.dart';
import 'package:tudu/domain/usecases/authentication/logout.dart';
import 'package:tudu/domain/usecases/authentication/sign_in.dart';
import 'package:tudu/domain/usecases/todo/delete_todo.dart';
import 'package:tudu/domain/usecases/todo/get_todo.dart';
import 'package:tudu/domain/usecases/todo/toggle_todo.dart';
import 'package:tudu/presentation/bloc/bloc/todo_event.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies()async{

  //services
  sl.registerLazySingleton<AuthFirebaseService>(
    ()=> AuthFirebaseServiceImpl()
  );

  sl.registerLazySingleton<TodoFirebaseService>(
    ()=> TodoFirebaseServiceImp()
  );


  //repositories
  sl.registerLazySingleton<AuthRepository>(
    ()=> AuthRepoImp()
  );

  sl.registerLazySingleton<TodoRepository>(
    ()=> TodoRepoImp()
  );




//usecase

  sl.registerLazySingleton<GetTodosUsecase>(
    ()=> GetTodosUsecase()
  );
  sl.registerLazySingleton<GetCurrentUserUsecase>(
    ()=> GetCurrentUserUsecase()
  );
  sl.registerLazySingleton<LogoutUsecase>(
    ()=> LogoutUsecase()
  );

  sl.registerLazySingleton<SignInwithGoogleUsecase>(
    ()=> SignInwithGoogleUsecase()
  );

  sl.registerLazySingleton<ToggleTodoUsecase>(
    ()=> ToggleTodoUsecase()
  );

  sl.registerLazySingleton<DeleteTodoUsecase>(
    ()=> DeleteTodoUsecase()
  );


 
}