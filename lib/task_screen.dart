// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<String> tasks = [];
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    loadTasks();
  }

  void addTask(String task) {
    setState(() {
      tasks.add(task);
      saveTasks();
    });
  }

  void editTask(int index, String newTask) {
    setState(() {
      tasks[index] = newTask;
      saveTasks();
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
      tasks = savedTasks;
    });
  }

  void saveTasks() {
    prefs.setStringList('tasks', tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Quantidade de Tarefas: ${tasks.length}',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          String editedTask = await showDialog(
                            context: context,
                            builder: (context) {
                              String editedTaskName = tasks[index];
                              return AlertDialog(
                                title: Text('Editar Tarefa'),
                                content: TextField(
                                  onChanged: (value) {
                                    editedTaskName = value;
                                  },
                                  controller:
                                      TextEditingController(text: tasks[index]),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, editedTaskName);
                                    },
                                    child: Text('Salvar'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (editedTask != null && editedTask.isNotEmpty) {
                            editTask(index, editedTask);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          removeTask(index);
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
          String newTask = await showDialog(
            context: context,
            builder: (context) {
              String taskName = '';
              return AlertDialog(
                title: Text('Adicionar Tarefa'),
                content: TextField(
                  onChanged: (value) {
                    taskName = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, taskName);
                    },
                    child: Text('Adicionar'),
                  ),
                ],
              );
            },
          );

          if (newTask != null && newTask.isNotEmpty) {
            addTask(newTask);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
