class TodoEntity {
  final String id;
  final String text;
  final String? description;
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime createdAt;

  const TodoEntity({
    required this.id,
    required this.text,
    this.description,
    this.dueDate,
    required this.isCompleted,
    required this.createdAt,
  });

  TodoEntity copyWith({
    String? id,
    String? text,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
