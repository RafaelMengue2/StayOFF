// ignore_for_file: unused_import

import 'dart:async';
import 'package:flutter/material.dart';
import 'chart_screen.dart';
import 'about_screen.dart';
import 'task_screen.dart';

void main() {
  runApp(ProcrastinationApp());
}

class ProcrastinationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StayOFF',
      theme: ThemeData(primarySwatch: Colors.red),
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StayOFF'),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Sobre',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: PomodoroTimer(),
    );
  }
}

class PomodoroTimer extends StatefulWidget {
  @override
  _PomodoroTimerState createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  int _minutes = 0;
  int _seconds = 0;
  bool _isActive = false;
  late Timer _timer;
  TextEditingController _minutesController = TextEditingController();
  TextEditingController _secondsController = TextEditingController();

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
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_minutes == 0 && _seconds == 0) {
          _timer.cancel();
          _isActive = false;
          _showEndDialog(context);
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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _showEndDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tempo Acabou!'),
          content: Text('Cronometro pomodoro foi finalizado'),
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
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 80,
              child: TextField(
                controller: _minutesController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Minutos',
                ),
              ),
            ),
            SizedBox(width: 20),
            SizedBox(
              width: 80,
              child: TextField(
                controller: _secondsController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Segundos',
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          '$_minutes:${_seconds.toString().padLeft(2, '0')}',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: _isActive ? null : () => _startTimerFromInput(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                primary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Começar', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(width: 20),
            TextButton(
              onPressed: _resetTimer,
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                primary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Resetar', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ],
    );
  }
}
