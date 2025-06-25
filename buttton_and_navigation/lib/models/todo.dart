import 'package:flutter/material.dart';

class Todo {
  final String id;
  final String title;
  final String category;
  final String priority;
  bool isCompleted;

  Todo({
    Key? key,
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    required this.isCompleted,
  });
}
