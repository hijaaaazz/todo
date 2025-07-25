import 'package:get_it/get_it.dart';
import 'package:tudu/data/repositories/auth_repository.dart';
import 'package:tudu/data/services/auth_service.dart';
import 'package:tudu/domain/repositories/auth_repository.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies()async{

  //services
  sl.registerLazySingleton<AuthFirebaseService>(
    ()=> AuthFirebaseServiceImpl()
  );


  
  //repositories
  sl.registerLazySingleton<AuthRepository>(
    ()=> AuthRepoImp()
  );

 
}