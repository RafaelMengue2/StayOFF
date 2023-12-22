import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'note_screen.dart';
import 'about_screen.dart';
import 'task_screen.dart';

class Task {
  String title;
  bool isCompleted;
  Task(this.title, this.isCompleted);
}

void main() {
  runApp(ProcrastinationApp());
}

class ProcrastinationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeContent(),
    TasksScreen(),
    AboutScreen(),
    NoteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_list),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add),
            label: 'Mais',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            label: 'Notas',
          ),
        ],
        activeColor: Colors.red,
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return CupertinoPageScaffold(
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: _screens[index],
              ),
            );
          },
        );
      },
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PomodoroTimer(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showTaskDialog(context);
              },
              child: Text('Selecionar Tarefas'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTaskDialog(BuildContext context) {
    List<Task> tasks = [
      Task('Tarefa 1', false),
      Task('Tarefa 2', false),
      Task('Tarefa 3', false),
      // Adicione mais tarefas conforme necessário
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tarefas Disponíveis'),
          content: Column(
            children: tasks.map((task) {
              return ListTile(
                title: Text(task.title),
                trailing: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    // Atualizar o estado da tarefa conforme necessário
                  },
                ),
              );
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}

class PomodoroTimer extends StatefulWidget {
  @override
  _PomodoroTimerState createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer>
    with SingleTickerProviderStateMixin {
  int _workMinutes = 25;
  int _breakMinutes = 5;
  int _minutes = 25;
  int _seconds = 0;
  bool _isActive = false;
  late Timer _timer;
  TextEditingController _minutesController = TextEditingController();
  TextEditingController _secondsController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isBreak = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(minutes: _minutes),
    );
    _animation = Tween<double>(begin: 1, end: 0).animate(_animationController);
  }

 void _startTimerFromInput() {
    int minutes = int.tryParse(_minutesController.text) ?? 0;
    int seconds = int.tryParse(_secondsController.text) ?? 0;

    setState(() {
      _minutes = minutes;
      _seconds = seconds;
    });

    _startTimer();
  }

  void _resetTimer() {
    _timer.cancel();
    _isActive = false;
    _minutesController.clear();
    _secondsController.clear();

    setState(() {
      _minutes = 0;
      _seconds = 0;
    });
  }

  void _startTimer() {
    if (!_isActive) {
      _isActive = true;
      _animationController.reset();
      _animationController.duration = Duration(seconds: _seconds + _minutes * 60);
      _animationController.forward();

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_minutes == 0 && _seconds == 0) {
          _timer.cancel();
          _isActive = false;
          Future.delayed(Duration.zero, () {
            _showEndDialog(context);
            if (!_isBreak) {
              _isBreak = true;
              _minutes = _breakMinutes;
            } else {
              _isBreak = false;
              _minutes = _workMinutes;
            }
            _startTimer();
          });
        } else if (_seconds == 0) {
          setState(() {
            _minutes--;
            _seconds = 59;
          });
        } else {
          setState(() {
            _seconds--;
          });
        }
      });
    }
  }

  void _showEndDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tempo Acabou!'),
          content: Text('Cronômetro Pomodoro foi finalizado'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: CircularProgressIndicator(
                    value: _animation.value,
                    color: Colors.white,
                    strokeWidth: 15,
                  ),
                ),
                Center(
                  child: Text(
                    '$_minutes:${_seconds.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoButton(
              child: Icon(Icons.play_arrow, color: Colors.white),
              onPressed: _isActive ? null : () => _startTimerFromInput(),
            ),
            SizedBox(width: 20),
            CupertinoButton(
              child: Icon(Icons.stop, color: Colors.white),
              onPressed: _isActive ? () => _resetTimer() : null,
            ),
          ],
        ),
      ],
    );
  }
}