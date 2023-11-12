// note_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'note_card.dart';
import 'new_note_screen.dart';
import 'note.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController _noteController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  List<Note> _notes = [];
  Color _selectedColor = Colors.red; // Default color

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notes = prefs.getStringList('notes') ?? [];

    setState(() {
      _notes = notes.map((noteString) {
        final parts = noteString.split(':');
        return Note(
          title: parts[0],
          description: parts[1],
          content: parts[2],
          color: Color(int.parse(parts[3])),
        );
      }).toList();
    });
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesToSave = _notes
        .map((note) =>
            '${note.title}:${note.description}:${note.content}:${note.color.value.toString()}')
        .toList();
    await prefs.setStringList('notes', notesToSave);
  }

  void _addNote(Note newNote) {
    setState(() {
      _notes.add(newNote);
      _selectedColor = newNote.color; 
    });
    _saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          margin: EdgeInsets.only(top: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewNoteScreen(
                        onNoteAdded: _addNote,
                        initialSelectedColor: _selectedColor,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: _selectedColor, // Use the selected color
                ),
                child: Text('Criar nova Nota'),
              ),
              SizedBox(height: 16),
              Expanded(
                child: _notes.isEmpty
                    ? Center(
                        child: Text('Nenhuma Nota salva até o momento'),
                      )
                    : ListView.builder(
                        itemCount: _notes.length,
                        itemBuilder: (context, index) {
                          return NoteCard(
                            note: _notes[index],
                            onTap: () {
                              _noteController.text = _notes[index].title;
                              _descriptionController.text = _notes[index].description;
                            },
                            onDelete: () {
                              _notes.removeAt(index);
                              _saveNotes();
                              setState(() {});
                            },
                            onExpand: (newContent, newDescription) {
                              _notes[index].content = newContent;
                              _notes[index].description = newDescription;
                              _saveNotes();
                              setState(() {});
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
