import 'package:dartz/dartz.dart';
import 'package:tudu/core/usecase/usecase.dart';
import 'package:tudu/domain/enities/todo_entity.dart';
import 'package:tudu/domain/repositories/todo_repository.dart';
import 'package:tudu/service_locator.dart';

class GetTodosUsecase implements Usecase<Either<String,List<TodoEntity>>, String> {
  @override
  Future<Either<String, List<TodoEntity>>> call({required String params}) async {
    return sl<TodoRepository>().getTodos(params);
  }
}