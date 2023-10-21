import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController _noteController = TextEditingController();
  List<String> _notes = [];
  int? _selectedNoteIndex; // Use `int?` para permitir valores nulos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _noteController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Digite suas anotações aqui',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String noteText = _noteController.text;
                if (_selectedNoteIndex != null) {
                  _notes[_selectedNoteIndex!] = noteText;
                } else {
                  _notes.add(noteText);
                }
                _noteController.clear();
                _selectedNoteIndex = null;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Nota salva com sucesso!'),
                  ),
                );
                setState(() {});
              },
              child: Text('Salvar Nota'),
            ),
            SizedBox(height: 16),
            Text(
              'Notas:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_notes[index]),
                    onTap: () {
                      _noteController.text = _notes[index];
                      _selectedNoteIndex = index;
                    },
                    onLongPress: () {
                      _notes.removeAt(index);
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
