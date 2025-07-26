import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:tudu/data/models/add_todo_params.dart';
import 'package:tudu/data/models/delete_todo_params.dart';
import 'package:tudu/data/models/todo_model.dart';
import 'package:tudu/data/models/toggle_todo_params.dart';
import 'package:tudu/data/models/update_todo_params.dart';

abstract class TodoFirebaseService {
  Future<Either<String, bool>> createUserCollection(String userId);
  Future<Either<String, List<TodoModel>>> getTodos(String userId);
  Future<Either<String, TodoModel>> addTodo(AddTodoParams params);
  Future<Either<String, TodoModel>> updateTodoTextOrDate(UpdateTodoParams params);
  Future<Either<String, bool>> toggleTodoCompletion(ToggleTodoParams params);

  Future<Either<String, bool>> deleteTodo(DeleteTodoParams params);
}


class TodoFirebaseServiceImp implements TodoFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    @override
  Future<Either<String, bool>> createUserCollection(String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);

      // Only create if it doesn't exist
      final doc = await userRef.get();
      if (!doc.exists) {
        await userRef.set({
          'createdAt': Timestamp.now(),
        });
      }

      return const Right(true);
    } catch (e) {
      log('createUserCollection error: $e');
      return Left('Failed to create user collection: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<TodoModel>>> getTodos(String userId) async {
    try {
      final todosSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('todos')
          .orderBy('dueDate')
          .get();

      final todos = todosSnapshot.docs
          .map((doc) => TodoModel.fromFirestore(doc.data()))
          .toList();

      return Right(todos);
    } catch (e) {
      log(e.toString());
      return Left('Failed to fetch todos: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, TodoModel>> addTodo(AddTodoParams params) async {
    try {
      final newTodo = {
        'id': params.id,
        'text': params.title,
        'description': params.description,
        'dueDate': params.duedate != null ? Timestamp.fromDate(params.duedate!) : null,
        'isCompleted': false,
        'createdAt': Timestamp.now(),
      };

      final todoRef = _firestore
          .collection('users')
          .doc(params.userId)
          .collection('todos')
          .doc(params.id);

      await todoRef.set(newTodo);

      return Right(TodoModel.fromFirestore(newTodo));
    } catch (e) {
      log(e.toString());
      return Left('Failed to add todo: ${e.toString()}');
    }
  }

@override
Future<Either<String, TodoModel>> updateTodoTextOrDate(UpdateTodoParams params) async {
  try {
    final todoRef = _firestore
        .collection('users')
        .doc(params.userId)
        .collection('todos')
        .doc(params.id);

    await todoRef.update({
      'text': params.title,
      'description': params.description,
      'dueDate': params.duedate != null ? Timestamp.fromDate(params.duedate!) : null,
    });

    // Get updated document
    final updatedDoc = await todoRef.get();

    if (updatedDoc.exists) {
      final data = updatedDoc.data()!;
      // Add the ID manually if needed
      data['id'] = updatedDoc.id;

      final updatedTodo = TodoModel.fromFirestore(data);
      return Right(updatedTodo);
    } else {
      return Left('Todo not found after update');
    }
  } catch (e) {
    log('updateTodoTextOrDate error: $e');
    return Left('Failed to update todo: ${e.toString()}');
  }
}


@override
Future<Either<String, bool>> toggleTodoCompletion(ToggleTodoParams params) async {
  try {

    log("hijij");
    final todoRef = _firestore
        .collection('users')
        .doc(params.userId)
        .collection('todos')
        .doc(params.todoId);

    // Update the isCompleted field
    await todoRef.update({'isCompleted': params.status});

    // Fetch the updated document
    final updatedDoc = await todoRef.get();

    if (updatedDoc.exists) {
      final updatedData = updatedDoc.data();
      final updatedStatus = updatedData?['isCompleted'] as bool? ?? false;
      return Right(updatedStatus);
    } else {
      return Left('Todo not found after update.');
    }
  } catch (e) {
    log('toggleTodoCompletion error: $e');
    return Left('Failed to toggle completion: ${e.toString()}');
  }
}



  @override
  Future<Either<String, bool>> deleteTodo(DeleteTodoParams params) async {
    try {
      log("started deleteing");
      final todoRef = _firestore
          .collection('users')
          .doc(params.userId)
          .collection('todos')
          .doc(params.id);

      await todoRef.delete();

      return const Right(true);
    } catch (e) {
      log(e.toString());
      return Left('Failed to delete todo: ${e.toString()}');
    }
  }
}
