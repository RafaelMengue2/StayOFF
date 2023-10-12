// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'StayOFF',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Um aplicativo de combate à procrastinação tem como objetivo ajudar os usuários a tomar medidas concretas para superar a procrastinação, gerenciar melhor seu tempo e aumentar sua produtividade. Ele combina recursos de rastreamento, gerenciamento de tempo e motivação para ajudar os usuários a se manterem no caminho certo e atingir seus objetivos.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Desenvolvido por: Rafael dos Santos Mengue',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Versão: 0.4',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
