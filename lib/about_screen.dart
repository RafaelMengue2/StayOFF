import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool isTextVisible = false;
  bool isDarkTheme = false;

  void _toggleTextVisibility() {
    setState(() {
      isTextVisible = !isTextVisible;
    });
  }

  void _toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkTheme = !isDarkTheme;
      prefs.setBool('darkTheme', isDarkTheme);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _toggleTextVisibility,
                child: Text(
                  'StayOFF: O que é?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              AnimatedCrossFade(
                crossFadeState: isTextVisible
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'StayOFF é um aplicativo de combate à procrastinação tem como objetivo ajudar os usuários a tomar medidas concretas para superar a procrastinação, gerenciar melhor seu tempo e aumentar sua produtividade. Ele combina recursos de rastreamento, gerenciamento de tempo e motivação para ajudar os usuários a se manterem no caminho certo e atingir seus objetivos.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Desenvolvido por: Rafael dos Santos Mengue',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Versão: 0.6',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                secondChild:
                    SizedBox(), // Um espaço em branco quando o texto estiver oculto.
                duration: Duration(
                    milliseconds:
                        300), // Duração da transição em milissegundos.
              ),
            ],
          ),
        ),
      ),
    );
  }
}
