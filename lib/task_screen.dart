import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Task {
  String name;
  String category;
  DateTime dueDate; // Due date property for the task

  Task(this.name, this.category, this.dueDate);
}

class CompletedTask {
  String name;
  DateTime completionTime;

  CompletedTask(this.name, this.completionTime);
}

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> tasks = [];
  List<CompletedTask> completedTasks = [];
  late SharedPreferences prefs;
  TextEditingController taskNameController = TextEditingController();
  TextEditingController editTaskNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  int editingTaskIndex = -1;
  List<String> categories = ['Todos', 'Trabalho', 'Pessoal', 'Estudos'];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    loadTasks();
  }

  void addTask(String taskName, String category, DateTime dueDate) {
    setState(() {
      tasks.add(Task(taskName, category, dueDate));
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

  void markTaskAsCompleted(int index) {
    setState(() {
      var taskToMark = tasks[index];
      var completedTask = CompletedTask(taskToMark.name, DateTime.now());
      completedTasks.add(completedTask);
      tasks.removeAt(index);
      saveTasks();
    });
  }

  void loadTasks() {
    List<String> savedTasks = prefs.getStringList('tasks') ?? [];
    List<String> savedCompletedTasks =
        prefs.getStringList('completedTasks') ?? [];

    setState(() {
      tasks = savedTasks.map((taskName) {
        final parts = taskName.split(':');
        final dueDate = DateTime.parse(parts[2]);
        return Task(parts[1], parts[0], dueDate);
      }).toList();

      completedTasks = savedCompletedTasks.map((taskName) {
        final parts = taskName.split(':');
        return CompletedTask(parts[1], DateTime.parse(parts[0]));
      }).toList();
    });
  }

  void saveTasks() {
    final taskList = tasks
        .map((task) =>
            '${task.category}:${task.name}:${task.dueDate.toIso8601String()}')
        .toList();
    final completedTaskList = completedTasks
        .map((task) => '${task.completionTime.toIso8601String()}:${task.name}')
        .toList();

    prefs.setStringList('tasks', taskList);
    prefs.setStringList('completedTasks', completedTaskList);
  }

  List<Task> filterTasks(String keyword) {
    return tasks
        .where((task) =>
            task.name.toLowerCase().contains(keyword.toLowerCase()) &&
            (selectedCategory == 'Todos' || task.category == selectedCategory))
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
          DropdownButton<String>(
            value: selectedCategory,
            items: categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue;
              });
            },
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
                      : Text(
                          '${filteredTasks[index].category}: ${filteredTasks[index].name}',
                        ),
                  subtitle: Text(
                    'Data de Vencimento: ${DateFormat('dd/MM/yyyy').format(filteredTasks[index].dueDate.toLocal())}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                        icon: Icon(Icons.check),
                        onPressed: () {
                          markTaskAsCompleted(index);
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
              DateTime dueDate = DateTime.now();

              return AlertDialog(
                title: Text('Adicionar Tarefa'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: selectedCategory,
                      items: categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                    ),
                    TextField(
                      controller: taskNameController,
                      decoration: InputDecoration(labelText: 'Nome da Tarefa:'),
                    ),
                    TextButton(
                      onPressed: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            dueDate = selectedDate;
                          });
                        }
                      },
                      child: Text('Definir Data de Vencimento'),
                    ),
                  ],
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
                        addTask(taskName, selectedCategory ?? categories[0],
                            dueDate);
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
