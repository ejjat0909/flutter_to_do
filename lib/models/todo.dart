class Todo {
  final int? id;
  final String? title;
  final String? description;
  final bool? isChecked;

  const Todo({this.id, this.title, this.description, this.isChecked});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'title': String? title,
        'description': String? description,
        'is_checked': bool? isChecked,
      } =>
        Todo(
          id: id,
          title: title,
          description: description,
          isChecked: isChecked,
        ),
      _ => throw const FormatException('Failed to convert to Todo'),
    };
  }
}
