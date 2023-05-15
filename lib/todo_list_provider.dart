import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class TodoListProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _userTodoCollectionRef;
  late String _userId;

  TodoListProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _userId = user.uid;
        _userTodoCollectionRef = _firestore.collection('users').doc(_userId).collection('todos');
        notifyListeners();
      }
    });
  }

  List<Todo> _list = [];

  List<Todo> get list => _list;

  void changeCompleteness(Todo item) {
    item.complete = !item.complete;
    _userTodoCollectionRef.doc(item.id).update({'complete': item.complete});
    notifyListeners();
  }

  Future<void> addNewTask(String description) async {
    DocumentReference docRef = _userTodoCollectionRef.doc();
    Todo newTodo = Todo.fromMap({'id': docRef.id, 'title': description, 'complete': false});
    _list.add(newTodo);
    await docRef.set(newTodo.toMap());
    notifyListeners();
  }

  Future<void> removeTask(Todo todo) async {
    _list.remove(todo);
    await _userTodoCollectionRef.doc(todo.id).delete();
    notifyListeners();
  }

  Future<void> getTodos() async {
    _userTodoCollectionRef = _firestore.collection('users').doc(_userId).collection('todos');
    QuerySnapshot querySnapshot = await _userTodoCollectionRef.get();
    _list = querySnapshot.docs.map((doc) => Todo.fromMap(doc.data() as Map<String, dynamic>)).toList();

    notifyListeners();
  }

  String getTitle(int index) {
    return _list[index].title;
  }

  bool getCompleteness(int index) {
    return _list[index].complete;
  }

  Todo getElement(int index) {
    return _list[index];
  }

  int getSize() {
    return _list.length;
  }
}

class Todo {
  late String id;
  late String title;
  late bool complete;

  Todo({required this.title, required this.complete});

  Todo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    complete = map['complete'];
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'complete': complete};
  }
}

