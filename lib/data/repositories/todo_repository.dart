import 'package:dartz/dartz.dart';
import 'package:tudu/data/models/add_todo_params.dart';
import 'package:tudu/data/models/delete_todo_params.dart';
import 'package:tudu/data/models/search_params.dart';
import 'package:tudu/data/models/todo_model.dart';
import 'package:tudu/data/models/toggle_todo_params.dart';
import 'package:tudu/data/models/update_todo_params.dart';
import 'package:tudu/data/services/todo_service.dart';
import 'package:tudu/domain/enities/todo_entity.dart';
import 'package:tudu/domain/repositories/todo_repository.dart';
import 'package:tudu/service_locator.dart';

class TodoRepoImp extends TodoRepository {
  final _service = sl<TodoFirebaseService>();

  @override
  Future<Either<String, List<TodoEntity>>> getTodos(String userId) async {
    final result = await _service.getTodos(userId);
    return result.fold(
      (l) => Left(l),
      (r) => Right(r.map((e) => e.toEntity()).toList()),
    );
  }

 @override
Future<Either<String, TodoEntity>> addTodo(AddTodoParams params) async {
  final result = await _service.addTodo(params);
  return result.fold(
    (l) => Left(l),
    (r) => Right(r.toEntity()),
  );
}


  @override
  Future<Either<String, TodoEntity>> updateTodo(UpdateTodoParams params) async {
final result = await _service.updateTodoTextOrDate(params);
  return result.fold(
    (l) => Left(l),
    (r) => Right(r.toEntity()),
  );
  }

  @override
  Future<Either<String, bool>> deleteTodo(DeleteTodoParams params) async {
final result = await _service.deleteTodo(params);
  return result.fold(
    (l) => Left(l),
    (r) => Right(r),
  );
}


  @override
  Future<Either<String, bool>> toggleTodo(ToggleTodoParams params)async{
    final result = await _service.toggleTodoCompletion(params);
  return result.fold(
    (l) => Left(l),
    (r) => Right(r),
  );
  }
}
