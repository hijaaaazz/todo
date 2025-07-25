import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:tudu/data/models/add_todo_params.dart';
import 'package:tudu/data/models/todo_model.dart';

abstract class TodoFirebaseService {
  Future<Either<String, bool>> createUserCollection(String userId);
  Future<Either<String, List<TodoModel>>> getTodos(String userId);
  Future<Either<String, TodoModel>> addTodo(AddTodoParams todo);
  Future<Either<String, bool>> editTodo(String userId, TodoModel todo);
  Future<Either<String, bool>> deleteTodo(String userId, String todoId);
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
  Future<Either<String, bool>> editTodo(String userId, TodoModel todo) async {
    try {
      final todoRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('todos')
          .doc(todo.id);

      await todoRef.update(todo.toFirestore());

      return const Right(true);
    } catch (e) {
      log(e.toString());
      return Left('Failed to edit todo: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> deleteTodo(String userId, String todoId) async {
    try {
      final todoRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('todos')
          .doc(todoId);

      await todoRef.delete();

      return const Right(true);
    } catch (e) {
      log(e.toString());
      return Left('Failed to delete todo: ${e.toString()}');
    }
  }
}
