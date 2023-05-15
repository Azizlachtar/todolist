import 'package:flutter/material.dart';
import 'todo_add.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sign_in.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference? _todos;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _todos = _db.collection('users').doc(_user.uid).collection('todos');
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const mySignIn()),
            (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red, // Change the background color
        title: const Text(
          'To Do App',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 30.0, // 2. Change the font size
            color: Colors.black, // Change the text color,
          ),

        ),
        centerTitle: true,
        leading:  const Icon(Icons.menu,
          color: Colors.white,), // Add an app icon
        actions: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            margin: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.redAccent,
              ),
              onPressed: _signOut,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _todos!.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          final List<QueryDocumentSnapshot<Object?>> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              final DocumentSnapshot<Object?> document = documents[index];
              final String title = document['title'];
              final bool complete = document['complete'];

              return CheckboxListTile(
                title: Text(
                  title,
                  style: TextStyle(
                    fontSize: 17, // Change the font size
                    fontWeight: FontWeight.bold, // Change the font weight
                    color: complete ? Colors.grey : Colors.blue, // Change the text color
                    decoration: complete
                        ? TextDecoration.lineThrough // Add a line-through for completed todos
                        : null,
                  ),
                ),
                value: complete,
                onChanged: (bool? newValue) {
                  _todos!
                      .doc(document.id)
                      .update({'complete': newValue})
                      .then((value) => const Text('Todo updated'))
                      .catchError((error) => print('Failed to update todo: $error'));
                },
                secondary: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _todos!
                        .doc(document.id)
                        .delete()
                        .then((value) => const Text('Todo deleted'))
                        .catchError((error) => print('Failed to delete todo: $error'));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final String? description = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) =>  NewItemView()));

          if (description != null) {
            _todos!.add({'title': description, 'complete': false}).then((value) {
            }).catchError((error) {
            });
          }
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(
          Icons.add_circle_outline, // 6. Add a custom icon
          size: 36.0,
          color: Colors.white,
        ),
      ),

    );
  }
}
