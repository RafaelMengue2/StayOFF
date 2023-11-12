import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAppLogo(),
                    SizedBox(height: 20),
                    _buildParagraph(
                      'StayOFF é um aplicativo de combate à procrastinação que tem como objetivo ajudar os usuários a tomar medidas concretas para superar a procrastinação, gerenciar melhor seu tempo e aumentar sua produtividade. Ele combina recursos de rastreamento, gerenciamento de tempo e motivação para ajudar os usuários a se manterem no caminho certo e atingir seus objetivos.',
                    ),
                    _buildParagraph(
                      'A procrastinação é o ato de adiar tarefas importantes, muitas vezes optando por atividades menos urgentes. Isso pode resultar em prazos perdidos, estresse e queda na produtividade. É importante reconhecer esse comportamento para melhorar sua eficiência e bem-estar.',
                    ),
                    _buildParagraph(
                      'A procrastinação pode ter efeitos negativos, como aumento da ansiedade, baixa autoestima e atraso no progresso em direção a metas pessoais e profissionais. Superar a procrastinação é fundamental para alcançar o sucesso.',
                    ),
                    _buildParagraph(
                      'Embora a procrastinação seja geralmente vista de maneira negativa, é importante notar que o descanso e o relaxamento são cruciais para o bem-estar. Às vezes, procrastinamos porque nosso corpo e mente precisam de uma pausa. No entanto, é fundamental encontrar equilíbrio entre o descanso e a procrastinação improdutiva. Definir limites de tempo para o descanso e garantir que o trabalho seja retomado é essencial.',
                    ),
                    SizedBox(height: 25),
                    _buildSectionTitle('Desenvolvido por:'),
                    _buildSectionContent('Rafael dos Santos Mengue'),
                    SizedBox(height: 5),
                    _buildSectionTitle('Versão:'),
                    _buildSectionContent('0.6'),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Center(
      child: Image.asset('assets/images/logo-appbar.jpeg'),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(fontSize: 16, color: Colors.black),
    );
  }

  Widget _buildParagraph(String content) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Text(
        content,
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AboutScreen(),
    theme: ThemeData(
      primaryColor: Colors.red,
      scaffoldBackgroundColor: Colors.white,
    ),
  ));
}
