// ignore_for_file: unused_import

import 'dart:async';
import 'package:flutter/material.dart';
import 'chart_screen.dart';
import 'about_screen.dart';
import 'task_screen.dart';
import 'package:flutter/services.dart';

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

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StayOFF'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Tarefas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TasksScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Sobre'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: PomodoroTimer(),
      ),
    );
  }
}

class PomodoroTimer extends StatefulWidget {
  @override
  _PomodoroTimerState createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  int _minutes = 25;
  int _seconds = 0; // Para testes, altere para 1500 (25 minutos)
  bool _isActive = false;
  late Timer _timer;

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

  void _resetTimer() {
    _timer.cancel();
    _isActive = false;
    setState(() {
      _minutes = 25;
      _seconds = 0;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '$_minutes:${_seconds.toString().padLeft(2, '0')}',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _isActive ? null : _startTimer,
              child: Text('Começar'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: _resetTimer,
              child: Text('Resetar'),
            ),
          ],
        ),
      ],
    );
  }

  void _showEndDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tempo esgotado'),
          content: Text('O cronômetro Pomodoro terminou.'),
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
}

class BatteryInfoPlatform {
  static const MethodChannel _channel = MethodChannel('battery_info');

  Future<int> getBatteryLevel() async {
    final int batteryLevel = await _channel.invokeMethod('getBatteryLevel');
    return batteryLevel;
  }
}
