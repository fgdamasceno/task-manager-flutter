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
  final List<Task> _tasks = [
    Task(id: '1', title: 'Aprender Git Flow'),
    Task(id: '2', title: 'Criar Modelos no Flutter'),
    Task(id: '3', title: 'Fazer commit profissional'),
  ];

  final TextEditingController _taskController = TextEditingController();

  // É uma boa prática profissional descartar controladores para economizar memória
  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addNewTask() {
    final String title = _taskController.text;

    if (title.isEmpty) return; // Validação básica: não aceita tarefa sem título

    setState(() {
      _tasks.add(
        Task(
          id: DateTime.now().toString(), // Gerando um ID único baseado no tempo
          title: title,
        ),
      );
    });

    _taskController.clear(); // Limpa o campo para a próxima tarefa
    Navigator.pop(context); // Fecha o modal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Tarefas'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskModal(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que o modal suba com o teclado
      builder: (context) {
        return Padding(
          padding: EdgeInsetsGeometry.only(
            bottom: MediaQuery.of(
              context,
            ).viewInsets.bottom, // Ajuste para o teclado
            left: 20.0,
            right: 20.0,
            top: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: InputDecoration(
                  labelText: 'Nova Tarefa',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
                onSubmitted: (_) =>
                    _addNewTask(), // Adiciona ao apertar 'Enter'
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: _addNewTask,
                child: Text('Adicionar'),
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        );
      },
    );
  }
}
