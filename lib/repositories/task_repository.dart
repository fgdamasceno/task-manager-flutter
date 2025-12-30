import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/task_model.dart';

class TaskRepository {
  static const String _tasksKey = 'tasks_key';

  Future<void> saveTasksList(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(
      tasks.map((t) => t.toJson()).toList(),
    );
    await prefs.setString(_tasksKey, encodedList);
  }

  Future<List<Task>> loadTaskList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString(_tasksKey);

    if (tasksString != null) {
      final List<dynamic> decodedList = jsonDecode(tasksString);
      return decodedList.map((item) => Task.fromJson(item)).toList();
    }
    return [];
  }
}
