import 'package:dartz/dartz.dart';
import 'package:tudu/core/usecase/usecase.dart';
import 'package:tudu/data/models/toggle_todo_params.dart';
import 'package:tudu/domain/repositories/todo_repository.dart';
import 'package:tudu/service_locator.dart';

class ToggleTodoUsecase implements Usecase<Either<String,bool>, ToggleTodoParams> {
  @override
  Future<Either<String, bool>> call({required ToggleTodoParams params}) async {
    return sl<TodoRepository>().toggleTodo(params);
  }
}