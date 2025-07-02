import 'package:buttton_and_navigation/models/todo.dart';
import 'package:buttton_and_navigation/screens/todo_list_screen.dart';
import 'package:flutter/material.dart';

class AddTodoScreen extends StatefulWidget {
  String category;
  String priority;

  AddTodoScreen({Key? key, required this.category, required this.priority})
    : super(key: key);

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController _titleController = TextEditingController();

  static String todoId = "todoId";

  static int todoIndex = 0;

  String get title => _titleController.text;
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text("할일 추가"),
        actions: [
          IconButton(
            onPressed: () {
              _saveToDo(_formKey);
              print("savetodo 함수 호출하여 저장!");
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFormField(
              controller: _titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "할일을 입력해주세요!",
                labelText: "제목",
                border: OutlineInputBorder(),
              ),
            ),
            choiceCategory(
              category: widget.category,
              onPress: (changeCategory) {
                setState(() {
                  widget.category = changeCategory;
                });
                print(widget.category);
              },
            ),
            priorityBtns(
              priority: widget.priority,
              onPress: (changePriority) {
                setState(() {
                  widget.priority = changePriority;
                });
                print(widget.priority);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ✅ add_todo_screen.dart의 _saveToDo에 추가
  void _saveToDo(GlobalKey<FormState> key) {
    print("=== 저장 시작 ===");
    print("제목: '$title'");
    print("카테고리: '${widget.category}'");
    print("우선순위: '${widget.priority}'");

    if (key.currentState?.validate() == true) {
      print("✅ 폼 검증 통과!");

      var todo = Todo(
        id: createToDoId(todoId, todoIndex),
        title: title,
        category: widget.category,
        priority: widget.priority,
        isCompleted: false,
      );

      print("생성된 Todo: ${todo.title}, ${todo.category}, ${todo.priority}");
      Navigator.of(context).pop(todo);
    } else {
      print("❌ 폼 검증 실패!");
    }
  }

  String createToDoId(String id, int idx) {
    todoIndex++;
    return id + idx.toString();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
  }
}

class choiceCategory extends StatefulWidget {
  String category;

  final Function(String) onPress;
  choiceCategory({Key? key, required this.category, required this.onPress})
    : super(key: key);

  @override
  State<choiceCategory> createState() => _choiceCategoryState();
}

class _choiceCategoryState extends State<choiceCategory> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: CircleBorder(eccentricity: 0.8),
            disabledBackgroundColor: Colors.grey,
            backgroundColor: Colors.yellow,
          ),
          onPressed: () {
            print("아침 버튼 클릭 됨");
            setState(() {
              widget.onPress("아침");
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.bed),
              ),
              Text("아침"),
            ],
          ),
        ),
        SizedBox(width: 10),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: CircleBorder(eccentricity: 0.8),
            disabledBackgroundColor: Colors.grey,
            backgroundColor: Colors.deepOrange,
          ),
          onPressed: () {
            print("오후 버튼 클릭 됨");
            setState(() {
              widget.onPress("오후");
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.sunny),
              ),
              Text("오후"),
            ],
          ),
        ),
        SizedBox(width: 10),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: CircleBorder(eccentricity: 0.8),
            disabledBackgroundColor: Colors.grey,
            backgroundColor: Colors.black26,
          ),
          onPressed: () {
            print("저녁");
            setState(() {
              widget.onPress("저녁");
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.nightlight),
              ),
              Text("저녁"),
            ],
          ),
        ),
      ],
    );
  }
}

class priorityBtns extends StatefulWidget {
  String priority;

  final Function(String) onPress;

  priorityBtns({super.key, required this.priority, required this.onPress});

  @override
  State<priorityBtns> createState() => _priorityBtnsState();
}

class _priorityBtnsState extends State<priorityBtns> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
            disabledBackgroundColor: Colors.grey,
            disabledForegroundColor: Colors.black,
          ),
          onPressed: () {
            print("우선순위 높음 버튼 클릭 됨");
            setState(() {
              widget.onPress("high");
            });
          },
          child: Text("우선순위 높음!"),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            foregroundColor: Theme.of(context).colorScheme.onTertiary,
            disabledBackgroundColor: Colors.grey,
            disabledForegroundColor: Colors.black,
          ),
          onPressed: () {
            print("우선순위 중간 버튼 클릭 됨");
            setState(() {
              widget.onPress("medium");
            });
          },
          child: Text("우선순위 중간!"),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            disabledBackgroundColor: Colors.grey,
            disabledForegroundColor: Colors.black,
          ),
          onPressed: () {
            print("우선순위 낮음 버튼 클릭 됨");
            setState(() {
              widget.onPress("low");
            });
          },
          child: Text("우선순위 낮음!"),
        ),
      ],
    );
  }
}

main() {
  runApp(
    MaterialApp(
      home: AddTodoScreen(category: "", priority: "높음"),
      debugShowCheckedModeBanner: false,
    ),
  );
}
