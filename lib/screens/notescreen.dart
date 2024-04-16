import 'package:flutter/material.dart';
import '../models/languages.dart';
import '../models/notes.dart';

class NotesScreen extends StatefulWidget {
  final Function(Locale) changeLocale; // Add this line

  NotesScreen({required this.changeLocale}); // Add this constructor
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> notes = [];
  
  Color? selectedColor; // Track selected color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).myNotes),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _addNote();
            },
          ),
           IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              _showLanguageSelectionDialog(context);
            },
          ),
          IconButton(onPressed: (){
            setState(() {
              notes;
            });
          }, icon: Icon(Icons.refresh))
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(
                  notes[index].locked ? 'Locked Note' : notes[index].text,
                  style: TextStyle(
                    color: notes[index].locked ? Colors.grey : Colors.black,
                    fontStyle: notes[index].locked ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
                onTap: () {
                  if (!notes[index].locked) {
                    _showNoteOptions(notes[index]);
                  } else {
                    _unlockNoteDialog(notes[index]);
                  }
                },
                tileColor: notes[index].color,
              ),
              SizedBox(height: 12), // Gap between notes
            ],
          );
        },
      ),
    );
  }

  void _addNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String noteText = '';
        selectedColor = Colors.blue; // Reset selected color
        return AlertDialog(
          title: Text('Add Note'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(labelText: 'Enter your note'),
                    onChanged: (value) {
                      noteText = value;
                    },
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _colorOption(Colors.green, () {
                        setState(() {
                          selectedColor = Colors.green;
                        });
                      }),
                      _colorOption(Colors.blue, () {
                        setState(() {
                          selectedColor = Colors.blue;
                        });
                      }),
                      _colorOption(Colors.red, () {
                        setState(() {
                          selectedColor = Colors.red;
                        });
                      }),
                      _colorOption(Colors.yellow, () {
                        setState(() {
                          selectedColor = Colors.yellow;
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        notes.add(Note(
                          text: noteText,
                          color: selectedColor ?? Colors.blue, // Use selectedColor
                          locked: false,
                          pin: '',
                        ));
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Add note with selected color'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

Widget _colorOption(Color color, Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        border: selectedColor == color
            ? Border.all(
                color: Colors.black,
                width: 2,
              )
            : null,
      ),
      margin: EdgeInsets.all(5),
    ),
  );
}


  void _showNoteOptions(Note note) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
              onTap: () {
                 Navigator.pop(context);
                _editNote(note);
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Lock'),
              onTap: () {
                _lockNoteDialog(note);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                setState(() {
                  notes.remove(note);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

void _editNote(Note note) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String editedText = note.text;
      selectedColor = note.color; // Initialize selected color
      TextEditingController controller = TextEditingController(text: note.text); // Initialize controller with note text
      return AlertDialog(
        title: Text('Edit Note'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Enter your updated note'),
                  controller: controller, // Use the controller initialized with note text
                  onChanged: (value) {
                    editedText = value;
                  },
                ),
                SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _colorOption(Colors.green, () {
                        setState(() {
                          selectedColor = Colors.green;
                        });
                      }),
                      _colorOption(Colors.blue, () {
                        setState(() {
                          selectedColor = Colors.blue;
                        });
                      }),
                      _colorOption(Colors.red, () {
                        setState(() {
                          selectedColor = Colors.red;
                        });
                      }),
                      _colorOption(Colors.yellow, () {
                        setState(() {
                          selectedColor = Colors.yellow;
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        note.text = editedText;
                        note.color = selectedColor ?? Colors.blue; // Use selectedColor
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Update Note'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _unlockNoteDialog(Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? enteredPin;
        return AlertDialog(
          title: Text('Unlock Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Enter PIN'),
                onChanged: (value) {
                  enteredPin = value;
                },
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (enteredPin == note.pin) {
                    setState(() {
                      note.locked = false;
                    });
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Incorrect PIN'),
                    ));
                  }
                },
                child: Text('Unlock'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _lockNoteDialog(Note note) {
    // Set PIN as '123'
    note.pin = '123';
    setState(() {
      note.locked = true;
    });
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  _changeLanguage(context, 'en');
                },
                child: Text('English'),
              ),
              ElevatedButton(
                onPressed: () {
                  _changeLanguage(context, 'es');
                },
                child: Text('Spanish'),
              ),
              ElevatedButton(
                onPressed: () {
                  _changeLanguage(context, 'fr');
                },
                child: Text('French'),
              ),
            ],
          ),
        );
      },
    );
  }
  void _changeLanguage(BuildContext context, String languageCode) {
  Locale newLocale = Locale(languageCode, '');
  AppLocalizations.delegate.load(newLocale).then((_) {
    widget.changeLocale(newLocale); // Call the method passed from MyApp
  });
}
  // void _changeLanguage(BuildContext context, String languageCode) {
  //   Locale newLocale = Locale(languageCode, '');
  //   AppLocalizations.delegate.load(newLocale).then((_) {
  //     setState(() {});
  //     Navigator.pop(context);
  //     // runApp(MyApp());
  //   });
  // }
}
