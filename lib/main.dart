import 'package:flutter/material.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/repositories/task_repository.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
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
  final List<Task> _tasks = [];
  final TaskRepository _repository = TaskRepository();
  final TextEditingController _taskController = TextEditingController();

  // É uma boa prática profissional descartar controladores para economizar memória
  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  // Adiciona tarefas à lista
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
      _saveTasks();
    });

    _taskController.clear(); // Limpa o campo para a próxima tarefa
    Navigator.pop(context); // Fecha o modal
  }

  // Remove tarefas
  void _removeTask(String id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
    _saveTasks();
  }

  // Função para carregar os dados ao iniciar o app
  Future<void> _loadTasks() async {
    final tasks = await _repository.loadTaskList();
    setState(() {
      _tasks.addAll(tasks);
    });
  }

  // Função para salvar a lista no disco
  Future<void> _saveTasks() async {
    await _repository.saveTasksList(_tasks);
  }

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Carrega os dados salvos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Tarefas'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_turned_in_outlined,
                    size: 80.0,
                    color: Colors.grey[400],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'Nenhuma tarefa encontrada!',
                    style: TextStyle(fontSize: 18.0, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Dismissible(
                  key: Key(task.id),
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _removeTask(task.id);
                    // Feedback visual (Snack-bar)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${task.title} removida')),
                    );
                  },
                  child: Card(
                    elevation: 2.0,
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isDone,
                        onChanged: (value) {
                          setState(() {
                            task.isDone = value!;
                            _saveTasks();
                          });
                        },
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
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
