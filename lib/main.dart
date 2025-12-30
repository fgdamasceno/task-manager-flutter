import 'package:flutter/material.dart';
import 'package:task_manager/models/task_model.dart';

void main() {
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Simulando uma lista de tarefas que viria de um banco de dados
  final List<Task> _task = [
    Task(id: '1', title: 'Aprender Git Flow'),
    Task(id: '2', title: 'Criar Modelos no Flutter'),
    Task(id: '3', title: 'Fazer commit profissional'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Tarefas'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: _task.length,
        itemBuilder: (context, index) {
          final task = _task[index];
          return ListTile(
            leading: Checkbox(
              value: task.isDone,
              onChanged: (value) {
                setState(() {
                  task.isDone = value!;
                });
              },
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
