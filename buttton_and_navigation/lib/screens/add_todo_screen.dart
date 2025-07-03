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
  final TextEditingController _titleController =
      TextEditingController(); // 텍스트 입력을 관리하는 컨트롤러이다.

  static String todoId = "todoId"; // 공유를 위해 스태틱 사용

  static int todoIndex = 0;

  String get title => _titleController.text; // 텍스트 내용 반환하는 게터 함수
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>(); // 폼 검증을 위한 키

    return Scaffold(
      // 기본 레이아웃 제공 위젯
      appBar: AppBar(
        // 앱바 위젯
        title: Text("할일 추가"),
        actions: [
          IconButton(
            // 아이콘을 내용으로 사용하는 버튼
            onPressed: () {
              _saveToDo(_formKey); // 클릭시 투두 저장하며, 키는 폼 필드를 관리하는 키를 사용한다.
              print("savetodo 함수 호출하여 저장!");
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        // 폼 위젯은 입력 폼 관리
        key: _formKey, // 키는 반드시 기재해야한다.
        child: Column(
          // 세로 배치
          mainAxisAlignment: MainAxisAlignment.spaceAround, // 균등 배치
          children: [
            TextFormField(
              // 입력 창 위젯
              controller: _titleController, // 컨트롤러 명시 필요
              validator: (value) {
                // 값 검증 파라미터
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                // 인풋 데코레이션은 데코레이션 파라미터에 사용해야한다.
                hintText: "할일을 입력해주세요!", // 텍스트 위젯이 아닌 바로 문자열 사용
                labelText: "제목",
                border: OutlineInputBorder(), // 보더 위젯 사용
              ),
            ),
            choiceCategory(
              category: widget.category,
              onPress: (changeCategory) {
                // 사용하는 곳에 값을 반영하기 위해, 함수를 사용하여 셋 스테이트 사용
                setState(() {
                  widget.category = changeCategory; // 신규값 기존 값에 저장
                });
                print(widget.category); // 디버깅용 코드
              },
            ),
            priorityBtns(
              // 우선순위 변경 버튼
              priority: widget.priority, // 우선순위 전달
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
        id: createToDoId(todoId, todoIndex), // 생성한 아이디를 값으로 사용
        title: title, // 입력받은  값을 타이틀로 사용
        category: widget.category,
        priority: widget.priority,
        isCompleted: false, // 기본으로 미 완성으로 간주
      );

      print("생성된 Todo: ${todo.title}, ${todo.category}, ${todo.priority}");
      Navigator.of(context).pop(todo); // 이전 화면으로 돌아가기
    } else {
      print("❌ 폼 검증 실패!");
    }
  }

  // 아이디 생성 함수, 아이디와 인덱스를 받아서 아이디를 생성해서 반환한다.
  String createToDoId(String id, int idx) {
    todoIndex++; // 고유값을 위해 인덱스 증가
    return id + idx.toString();
  }

  // 메모리 관리를 위해 컨트롤러 종료
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
  }
}

// 상태 변화를 위해 스테이트 풀 위젯 사용
class choiceCategory extends StatefulWidget {
  String category;

  final Function(String) onPress; // 사용하는 곳에서 값 변경을 위해 함수 사용
  choiceCategory({Key? key, required this.category, required this.onPress})
    : super(key: key);

  @override
  State<choiceCategory> createState() => _choiceCategoryState();
}

class _choiceCategoryState extends State<choiceCategory> {
  @override
  Widget build(BuildContext context) {
    return Row(
      // 익스펜드는 무조건 공간을 다 사용하므로, 필요에 따라 익스펜드 사용하며 가로로 배치
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        OutlinedButton(
          // 테두리 있는 버튼
          style: OutlinedButton.styleFrom(
            // 버튼 스타일은 이와 같이 사용
            shape: CircleBorder(eccentricity: 0.8), // 테두리 관련 설정
            disabledBackgroundColor: Colors.grey,
            backgroundColor: Colors.yellow,
          ),
          onPressed: () {
            // 클릭시
            print("아침 버튼 클릭 됨");
            setState(() {
              widget.onPress("아침"); // 상위 클래스에 해당 함수에 해당 값을 전달
            });
          },
          child: Column(
            // 세로배치 => 아이콘과 텍스트 새로 배치
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

  final Function(String) onPress; // 사용하는 곳에서의 값 변경을 위해 함수 사용

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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.error, // 테마를 사용하는 플러터의 최신 디자인 문법
            foregroundColor: Theme.of(context).colorScheme.onError,
            disabledBackgroundColor: Colors.grey,
            disabledForegroundColor: Colors.black,
          ),
          onPressed: () {
            print("우선순위 높음 버튼 클릭 됨");
            setState(() {
              widget.onPress("높음");
            });
          },
          child: Text("우선순위 높음!"),
        ),
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
              widget.onPress("중간");
            });
          },
          child: Text("우선순위 중간!"),
        ),
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
              widget.onPress("낮음");
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
