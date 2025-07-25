class UpdateTodoParams {
  final String id;
  final String title;
  final String description;
  final DateTime? duedate;
  final String userId;

  UpdateTodoParams({
    required this.id,
    required this.title,
    required this.description,
    required this.duedate,
    required this.userId
  });

}