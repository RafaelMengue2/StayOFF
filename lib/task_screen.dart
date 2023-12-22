import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Task {
  String name;
  String category;
  DateTime dueDate;

  Task(this.name, this.category, this.dueDate);
}

class CompletedTask {
  String name;
  DateTime completionTime;

  CompletedTask(this.name, this.completionTime);
}

typedef TaskCallback = void Function(List<Task>);

class TasksScreen extends StatefulWidget {
  TasksScreen();

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
  List<String> categories = ['Tudo', 'Trabalho', 'Pessoal', 'Estudar'];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    initPrefs();
    selectedCategory = 'Tudo';
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
      removeTask(index);
    });
  }

  void clearCompletedTasks() {
    setState(() {
      completedTasks.clear();
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
            (selectedCategory == 'Tudo' || task.category == selectedCategory))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks = filterTasks(searchController.text);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 8.0),
                    Text(
                      'Minhas Tarefas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: selectedCategory,
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: TextStyle(color: Colors.black87),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: filteredTasks.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma tarefa criada ainda.',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            title: editingTaskIndex == index
                                ? TextField(
                                    controller: editTaskNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Editar Tarefa',
                                    ),
                                  )
                                : Text(
                                    filteredTasks[index].name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            subtitle: Text(
                              'Escolher Data: ${DateFormat('dd/MM/yyyy').format(filteredTasks[index].dueDate.toLocal())}',
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
                                  icon: Icon(FontAwesomeIcons.check),
                                  onPressed: () {
                                    markTaskAsCompleted(index);
                                  },
                                ),
                                if (editingTaskIndex == index)
                                  IconButton(
                                    icon: Icon(FontAwesomeIcons.save),
                                    onPressed: () {
                                      editTask(
                                          index, editTaskNameController.text);
                                    },
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
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
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: taskNameController,
                        decoration: InputDecoration(
                          labelText: 'Nome da Tarefa:',
                        ),
                      ),
                      SizedBox(height: 8.0),
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
                        child: Text('Escolher uma data'),
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
                    ElevatedButton(
                      onPressed: () {
                        String taskName = taskNameController.text;
                        if (taskName.isNotEmpty) {
                          addTask(
                            taskName,
                            selectedCategory ?? categories[0],
                            dueDate,
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        onPrimary: Colors.white,
                      ),
                      child: Text('Adicionar'),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }
}
