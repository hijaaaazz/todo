import 'package:dartz/dartz.dart';
import 'package:tudu/core/usecase/usecase.dart';
import 'package:tudu/data/models/add_todo_params.dart';
import 'package:tudu/domain/enities/todo_entity.dart';
import 'package:tudu/domain/repositories/todo_repository.dart';
import 'package:tudu/service_locator.dart';

class AddTodoUsecase implements Usecase<Either<String,TodoEntity>, AddTodoParams> {
  @override
  Future<Either<String, TodoEntity>> call({required AddTodoParams params}) async {
    return sl<TodoRepository>().addTodo(params);
  }
}