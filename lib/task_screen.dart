import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  String name;

  Task(this.name);
}

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> tasks = [];
  late SharedPreferences prefs;
  TextEditingController taskNameController = TextEditingController();
  TextEditingController editTaskNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  int editingTaskIndex = -1;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    loadTasks();
  }

  void addTask(String taskName) {
    setState(() {
      tasks.add(Task(taskName));
      saveTasks();
      taskNameController.clear();
    });
  }

  void editTask(int index, String newTaskName) {
    setState(() {
      tasks[index].name = newTaskName;
      saveTasks();
      editingTaskIndex = -1;
    });
  }

  void removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
      saveTasks();
    });
  }

  void loadTasks() {
    List<String> savedTasks = prefs.getStringList('tasks') ?? [];
    setState(() {
      tasks = savedTasks.map((taskName) => Task(taskName)).toList();
    });
  }

  void saveTasks() {
    prefs.setStringList('tasks', tasks.map((task) => task.name).toList());
  }

  List<Task> filterTasks(String keyword) {
    return tasks
        .where(
            (task) => task.name.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks = filterTasks(searchController.text);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Número de Tarefas: ${filteredTasks.length}',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar Tarefas',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: editingTaskIndex == index
                      ? TextField(
                          controller: editTaskNameController,
                          decoration: InputDecoration(
                            labelText: 'Editar Tarefa',
                          ),
                        )
                      : Text(filteredTasks[index].name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit icon
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            editingTaskIndex = index;
                            editTaskNameController.text =
                                filteredTasks[index].name;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          removeTask(index);
                        },
                      ),
                      if (editingTaskIndex == index)
                        IconButton(
                          icon: Icon(Icons.save),
                          onPressed: () {
                            editTask(index, editTaskNameController.text);
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Adicionar Tarefa'),
                content: TextField(
                  controller: taskNameController,
                  decoration: InputDecoration(labelText: 'Nome da Tarefa:'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      String taskName = taskNameController.text;
                      if (taskName.isNotEmpty) {
                        addTask(taskName);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Adicionar'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TasksScreen(),
  ));
}
