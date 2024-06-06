import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: PhotoAlbumPage(),
  ));
}

class PhotoAlbumPage extends StatefulWidget {
  @override
  _PhotoAlbumPageState createState() => _PhotoAlbumPageState();
}

class _PhotoAlbumPageState extends State<PhotoAlbumPage> {
  List<Person> persons = [];
  List<Person> filteredPersons = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final snapshot = await _firestore
            .collection('persons')
            .where('userId', isEqualTo: user.uid)
            .get();
        setState(() {
          persons = snapshot.docs
              .map((doc) => Person.fromJson(doc.data(), doc.id))
              .toList();
          filteredPersons = persons;
        });
      } catch (e) {
        print('Error loading data: $e');
      }
    }
  }

  Future<void> _addPhoto() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final photoRef = _storage
              .ref()
              .child('photos')
              .child(user.uid)
              .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
          await photoRef.putFile(File(pickedFile.path));
          final photoURL = await photoRef.getDownloadURL();
          final newPerson = Person(
            name: '',
            details: '',
            photoPath: photoURL,
            userId: user.uid,
          );
          final docRef =
              await _firestore.collection('persons').add(newPerson.toJson());
          newPerson.id = docRef.id;
          setState(() {
            persons.add(newPerson);
            filteredPersons = persons;
          });
        }
      } catch (e) {
        print('Error adding photo: $e');
      }
    }
  }

  void _updateFilteredPersons() {
    setState(() {
      filteredPersons = persons
          .where((person) => person.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  Widget _buildImageWidget(String photoPath) {
    return Container(
      width: double.infinity,
      height: 150,
      child: Image.network(
        photoPath,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Album'),
        backgroundColor: Color.fromARGB(255, 145, 149, 246),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _updateFilteredPersons(),
              decoration: InputDecoration(
                hintText: 'Search by Name',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 145, 149,
                          246)), // Change line color when focused
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 145, 149, 246),
                ),
              ),
              cursorColor: Color.fromARGB(255, 145, 149, 246),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: kIsWeb ? 4 : 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: filteredPersons.length,
              itemBuilder: (context, index) {
                return _buildPersonItem(filteredPersons[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPhoto,
        backgroundColor: Color.fromARGB(255, 145, 149, 246),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget _buildPersonItem(Person person) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonDetailsPage(
              person: person,
              onDelete: (deletedPerson) {
                setState(() {
                  persons
                      .removeWhere((person) => person.id == deletedPerson.id);
                  filteredPersons
                      .removeWhere((person) => person.id == deletedPerson.id);
                });
              },
            ),
          ),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImageWidget(person.photoPath),
            SizedBox(height: 8.0),
            Text(person.name),
          ],
        ),
      ),
    );
  }
}

class Person {
  String id;
  String name;
  String details;
  String photoPath;
  String userId;

  Person({
    this.id = '',
    required this.name,
    required this.details,
    required this.photoPath,
    required this.userId,
  });

  factory Person.fromJson(Map<String, dynamic> json, String id) {
    return Person(
      id: id,
      name: json['name'] ?? '',
      details: json['details'] ?? '',
      photoPath: json['photoPath'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'details': details,
      'photoPath': photoPath,
      'userId': userId,
    };
  }
}

class PersonDetailsPage extends StatefulWidget {
  final Person person;
  final Function(Person) onDelete;

  const PersonDetailsPage(
      {Key? key, required this.person, required this.onDelete})
      : super(key: key);

  @override
  _PersonDetailsPageState createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.person.name;
    _detailsController.text = widget.person.details;
  }

  Future<void> _deletePhoto() async {
    try {
      await FirebaseStorage.instance
          .refFromURL(widget.person.photoPath)
          .delete();
      await FirebaseFirestore.instance
          .collection('persons')
          .doc(widget.person.id)
          .delete();
      widget
          .onDelete(widget.person); // Notify PhotoAlbumPage about the deletion
      Navigator.pop(context);
    } catch (e) {
      print('Error deleting photo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        backgroundColor: Color.fromARGB(255, 145, 149, 246),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.network(widget.person.photoPath)),
              SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                onChanged: (value) {
                  setState(() {
                    widget.person.name = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 145, 149,
                        246), // Change label color based on focus
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(
                          255, 145, 149, 246), // Change border color
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(
                          255, 145, 149, 246), // Change focused border color
                    ),
                  ),
                ),
                cursorColor: Color.fromARGB(255, 145, 149, 246),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _detailsController,
                onChanged: (value) {
                  setState(() {
                    widget.person.details = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Details',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 145, 149,
                        246), // Change label color based on focus
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(
                          255, 145, 149, 246), // Change border color
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(
                          255, 145, 149, 246), // Change focused border color
                    ),
                  ),
                ),
                cursorColor: Color.fromARGB(255, 145, 149, 246),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _deletePhoto,
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Change the background color here
                ),
                child: Text('Delete Photo'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  widget.person.name = _nameController.text;
                  try {
                    await FirebaseFirestore.instance
                        .collection('persons')
                        .doc(widget.person.id)
                        .update(widget.person.toJson());
                    Navigator.pop(context);
                  } catch (e) {
                    print('Error updating person: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 145, 149,
                      246), // Change this to whatever color you want
                ),
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
