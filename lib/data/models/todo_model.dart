import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tudu/domain/enities/todo_entity.dart';

class TodoModel {
  final String id;
  final String text;
  final String? description;
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime createdAt;

  const TodoModel({
    required this.id,
    required this.text,
    this.description,
    this.dueDate,
    required this.isCompleted,
    required this.createdAt,
  });

  TodoModel copyWith({
    String? text,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return TodoModel(
      id: id,
      text: text ?? this.text,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Firestore serialization
  Map<String, dynamic> toFirestore() {
    return {
      'id':id,
      'text': text,
      'description': description,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

 factory TodoModel.fromFirestore(Map<String, dynamic> data) {
  return TodoModel(
    id: data['id'],
    text: data['text'],
    description: data['description'],
    isCompleted: data['isCompleted'],
    createdAt: (data['createdAt'] as Timestamp).toDate(),
    dueDate: data['dueDate'] != null
        ? (data['dueDate'] as Timestamp).toDate()
        : null,
  );
}


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TodoModel &&
        other.id == id &&
        other.text == text &&
        other.description == description &&
        other.dueDate == dueDate &&
        other.isCompleted == isCompleted &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        description.hashCode ^
        dueDate.hashCode ^
        isCompleted.hashCode ^
        createdAt.hashCode;
  }

    // Converts model to entity
  TodoEntity toEntity() {
    return TodoEntity(
      id: id,
      text: text,
      description: description,
      dueDate: dueDate,
      isCompleted: isCompleted,
      createdAt: createdAt,
    );
  }

  // Creates model from entity
  factory TodoModel.fromEntity(TodoEntity entity) {
    return TodoModel(
      id: entity.id,
      text: entity.text,
      description: entity.description,
      dueDate: entity.dueDate,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
    );
  }

}