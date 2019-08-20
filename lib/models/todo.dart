import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoField {
  static const key = "key";
  static const subject = "subject";
  static const completed = "completed";
  static const userId = "userId";
}

class Todo {
  String key;
  String subject;
  bool completed;
  String userId;

  Todo(this.subject, this.userId, this.completed);

  Todo.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    userId = snapshot.value["userId"],
    subject = snapshot.value["subject"],
    completed = snapshot.value["completed"];

  Todo.fromMap(Map<String, dynamic> data, String key) {
    this.key = key;
    this.userId = data[ToDoField.userId];
    this.subject = data[ToDoField.subject];
    this.completed = data[ToDoField.completed];
  }

  toJson() {
    return {
      ToDoField.userId: userId,
      ToDoField.subject: subject,
      ToDoField.completed: completed,
    };
  }
}