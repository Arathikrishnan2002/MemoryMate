import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNotePage extends StatefulWidget {
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _noteController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _notesCollection;
  late User _user; // User object

  @override
  void initState() {
    super.initState();
    _notesCollection = _firestore.collection('notes');
    _user = FirebaseAuth.instance.currentUser!; // Get the current user
  }

  void _addNote() {
    String note = _noteController.text;
    if (note.isNotEmpty) {
      _notesCollection.add({
        'note': note,
        'userId': _user.uid, // Store the user ID with the note
      });
      _noteController.clear();
    }
  }

  void _deleteNote(String noteId) {
    _notesCollection.doc(noteId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 145, 149, 246),
        title: Text('Add Note'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Enter your note',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 145, 149,
                          246)), // Change line color when focused
                ),
              ),
              cursorColor: Color.fromARGB(255, 145, 149, 246),
            ),
          ),
          ElevatedButton(
            onPressed: _addNote,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromARGB(255, 145, 149, 246),
              ), // Change the color here
            ),
            child: Text('Add Note'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _notesCollection
                  .where('userId', isEqualTo: _user.uid)
                  .snapshots(), // Filter notes by userId
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  List<DocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      var note = documents[index];
                      return GestureDetector(
                        onLongPress: () {
                          _showDeleteDialog(note.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(note['note']),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String noteId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Note?'),
          content: Text('Are you sure you want to delete this note?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Color.fromARGB(255, 145, 149, 246), // Change the color of the text
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteNote(noteId);
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
