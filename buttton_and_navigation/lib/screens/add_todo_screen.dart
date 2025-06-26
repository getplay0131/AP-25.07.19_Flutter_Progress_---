import 'package:flutter/material.dart';

class AddTodoScreen extends StatefulWidget {
  String category;
  String priority;

  AddTodoScreen({Key? key, required this.category, required this.priority}) : super(key: key);

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String userInput = _titleController.text;

    return Scaffold(body: Form(child: TextFormField(controller: _titleController,)));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
