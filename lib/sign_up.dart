import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sign_in.dart';
import 'todo_list_provider.dart';

class MySignUp extends StatefulWidget {
  const MySignUp({Key? key}) : super(key: key);

  @override
  _MySignUpState createState() => _MySignUpState();
}

class _MySignUpState extends State<MySignUp> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _todoListProvider = TodoListProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoApp'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            myTextField("Enter UserName", Icons.person_outline, false, _userNameTextController),
            const SizedBox(
              height: 20,
            ),
            myTextField("Enter Email id", Icons.person_outline, false, _emailTextController),
            const SizedBox(
              height: 30,
            ),
            myTextField("Enter Password", Icons.lock_outline, true, _passwordTextController),
            const SizedBox(
              height: 30,
            ),
            mySignInButton(context, false, () async {
              try {
                final newUser = await _auth.createUserWithEmailAndPassword(
                    email: _emailTextController.text, password: _passwordTextController.text);
                if (newUser != null) {
                  await _firestore.collection('users').doc(newUser.user!.uid).set({
                    'userName': _userNameTextController.text,
                    'email': _emailTextController.text,
                    'todoList': _todoListProvider.list.map((e) => e.title).toList(),
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const mySignIn()));
                }
              } catch (e) {
                print(e);
              }
            }),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
