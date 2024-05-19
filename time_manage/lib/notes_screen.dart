import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<String> notes = [];
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() {
    final storedNotes = LocalStorage().getItem('notes');
    if (storedNotes != null) {
      setState(() {
        notes = List<String>.from(storedNotes);
      });
    }
  }

  void _saveNotes() {
    LocalStorage().setItem('notes', notes);
  }

  void _editNoteDialog(int index) {
    _textEditingController.text = notes[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Редагувати нотатку'),
          content: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(labelText: 'Введіть вашу нотатку'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Відміна'),
            ),
            TextButton(
              onPressed: () {
                _editNote(index);
                Navigator.of(context).pop();
              },
              child: Text('Зберегти'),
            ),
          ],
        );
      },
    );
  }

  void _editNote(int index) {
    String editedNote = _textEditingController.text.trim();
    if (editedNote.isNotEmpty) {
      setState(() {
        notes[index] = editedNote;
        _saveNotes();
        _textEditingController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Нотатки'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Введіть вашу нотатку',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addNote,
              child: Text('Додати нотатку'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        notes[index],
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        _editNoteDialog(index);
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteNote(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addNote() {
    String newNote = _textEditingController.text.trim();
    if (newNote.isNotEmpty) {
      setState(() {
        notes.add(newNote);
        _textEditingController.clear();
        _saveNotes();
      });
    }
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
      _saveNotes();
    });
  }
}

class LocalStorage {
  static Map<String, dynamic> _storage = {};

  dynamic getItem(String key) {
    return _storage[key];
  }

  void setItem(String key, dynamic value) {
    _storage[key] = value;
  }

  void removeItem(String key) {
    _storage.remove(key);
  }
}
