import 'package:flutter/material.dart';
import 'note.dart';

class NewNoteScreen extends StatefulWidget {
  final void Function(Note) onNoteAdded;
  final Color initialSelectedColor;

  NewNoteScreen({
    required this.onNoteAdded,
    required this.initialSelectedColor,
  });

  @override
  _NewNoteScreenState createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  TextEditingController _noteController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  Color _selectedColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialSelectedColor;
  }

  bool _isColorLight(Color color) {
    double brightness = color.computeLuminance();
    return brightness > 0.5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Nota'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _saveNewNote();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _noteController,
                maxLines: null,
                style: TextStyle(
                  color: _isColorLight(_selectedColor) ? Colors.black : Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Digite o Titulo',
                  fillColor: _selectedColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: null,
                style: TextStyle(
                  color: _isColorLight(_selectedColor) ? Colors.black : Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Digite a Descrição',
                  fillColor: _selectedColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colorList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = _colorList[index];
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _colorList[index],
                          border: _selectedColor == _colorList[index]
                              ? Border.all(color: Colors.white, width: 5)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _saveNewNote();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: Text('Criar nova Nota'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNewNote() {
    String noteTitle = _noteController.text;
    String noteDescription = _descriptionController.text;
    widget.onNoteAdded(Note(
      title: noteTitle,
      description: noteDescription,
      content: '',
      color: _selectedColor,
    ));
    _noteController.clear();
    _descriptionController.clear();
  }
}

final List<Color> _colorList = [
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.orange,
  Colors.purple,
  Colors.grey,
  Colors.brown,
];
