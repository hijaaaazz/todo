import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tudu/core/usecase/usecase.dart';
import 'package:tudu/data/models/update_todo_params.dart';
import 'package:tudu/domain/enities/todo_entity.dart';
import 'package:tudu/domain/repositories/todo_repository.dart';
import 'package:tudu/service_locator.dart';

class UpdateTodoUsecase implements Usecase<Either<String, TodoEntity>, UpdateTodoParams> {
  @override
  Future<Either<String, TodoEntity>> call({required UpdateTodoParams params}) async {
    log('UpdateTodoUsecase: params.duedate=${params.duedate}');
    return sl<TodoRepository>().updateTodo(params);
  }
}
