import 'package:dartz/dartz.dart';
import 'package:tudu/data/models/add_todo_params.dart';
import 'package:tudu/data/models/delete_todo_params.dart';
import 'package:tudu/data/models/toggle_todo_params.dart';
import 'package:tudu/data/models/update_todo_params.dart';
import 'package:tudu/domain/enities/todo_entity.dart';

abstract class TodoRepository {
  Future<Either<String, List<TodoEntity>>> getTodos(String userId);
  Future<Either<String, TodoEntity>> addTodo(AddTodoParams params);
  Future<Either<String, TodoEntity>> updateTodo(UpdateTodoParams params);
  Future<Either<String, bool>> toggleTodo(ToggleTodoParams params);
  Future<Either<String, bool>> deleteTodo(DeleteTodoParams params);
}
