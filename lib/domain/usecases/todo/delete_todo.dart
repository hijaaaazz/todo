import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tudu/core/usecase/usecase.dart';
import 'package:tudu/data/models/delete_todo_params.dart';
import 'package:tudu/data/models/toggle_todo_params.dart';
import 'package:tudu/domain/repositories/todo_repository.dart';
import 'package:tudu/service_locator.dart';

class DeleteTodoUsecase implements Usecase<Either<String,bool>, DeleteTodoParams> {
  @override
  Future<Either<String, bool>> call({required DeleteTodoParams params}) async {
    log("delete");
    return sl<TodoRepository>().deleteTodo(params);
  }
}