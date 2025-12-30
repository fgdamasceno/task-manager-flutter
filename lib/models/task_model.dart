class Task {
  final String id;
  final String title;
  bool isDone;

  Task({required this.id, required this.title, this.isDone = false});

  // Converte um objeto Task para um Mapa (JSON)
  // Para trabalhar com 'shared_preferences'
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
    };
  }

  // Cria um objeto Task a partir de um Mapa (JSON)
  // Para trabalhar com 'shared_preferences'
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isDone: json['isDone'],
    );
  }
}
