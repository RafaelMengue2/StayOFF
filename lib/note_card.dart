import 'package:flutter/material.dart';
import 'note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final Function(String, String) onExpand;

  NoteCard({
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.color,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    note.title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: _isColorDark(note.color) ? Colors.black : Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: onDelete,
                    color: _isColorDark(note.color) ? Colors.black : Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                note.description,
                style: TextStyle(
                  fontSize: 16.0,
                  color: _isColorDark(note.color) ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isColorDark(Color color) {
    return (color.red * 0.299 + color.green * 0.587 + color.blue * 0.114) > 186;
  }
}
