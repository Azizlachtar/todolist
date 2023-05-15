import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class NewItemView extends StatelessWidget {
  final TextEditingController textFieldController = TextEditingController();

  NewItemView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('new task'),
          backgroundColor: Colors.red,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: textFieldController,
                decoration: const InputDecoration(
                  labelText: 'Enter task name',

                  border: OutlineInputBorder(),
                ),
                autofocus: true,
                onEditingComplete: () => save(context),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                 style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
                onPressed: () => save(context),
                child: const Text('Save'),

              ),

            ],
          ),
        ));
  }

  void save(BuildContext context) async {
    if (textFieldController.text.isNotEmpty) {
      final user = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      final newItem = textFieldController.text;
      await user.collection('todos').add({
        'title': newItem,
        'complete': false,
      });
      Navigator.of(context).pop();
    }
  }
}
