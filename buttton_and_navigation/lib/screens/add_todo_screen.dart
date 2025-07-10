import 'package:buttton_and_navigation/models/todo.dart';
import 'package:buttton_and_navigation/screens/todo_list_screen.dart';
import 'package:flutter/material.dart';

/// ⭐️ AddTodoScreen 클래스: 할 일 추가/수정 화면을 담당하는 StatefulWidget
/// - category, priority: 부모로부터 전달받는 속성(아침/오후/저녁, 높음/중간/낮음)
class AddTodoScreen extends StatefulWidget {
  String category; // ⭐️ 선택된 카테고리(아침/오후/저녁)
  String priority; // ⭐️ 선택된 우선순위(높음/중간/낮음)

  AddTodoScreen({Key? key, required this.category, required this.priority})
    : super(key: key);

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

/// ⭐️ _AddTodoScreenState: AddTodoScreen의 상태와 UI를 관리
class _AddTodoScreenState extends State<AddTodoScreen> {
  // ⭐️ 할 일 제목 입력을 위한 컨트롤러
  final TextEditingController _titleController = TextEditingController();

  // ⭐️ static 변수: 고유 id 생성을 위해 사용 (모든 인스턴스에서 공유)
  static String todoId = "todoId";
  static int todoIndex = 0;

  static bool _isLoading = false; // ⭐️ 로딩 상태 변수 (예시로 사용)

  // ⭐️ 입력된 제목 반환
  String get title => _titleController.text;

  @override
  Widget build(BuildContext context) {
    // ⭐️ 폼 검증을 위한 키
    final _formKey = GlobalKey<FormState>();

    // ⭐️ 라우트로 전달된 arguments(모드, 프로필 등) 받기
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String mode = arguments?['mode'] ?? 'view'; // ⭐️ 모드(view/edit)
    final Map<String, dynamic> profileData =
        arguments?['profileData'] ??
        {"id": "defaultId", "name": "defaultName", "email": "defaultEmail"};

    // ⭐️ 디버깅 함수 호출: 현재 상태와 전달값을 출력
    debugAddTodoScreenState(
      mode: mode,
      profileData: profileData,
      category: widget.category,
      priority: widget.priority,
      title: title,
    ); // ⭐️ 디버깅 함수 호출

    return Scaffold(
      appBar: AppBar(
        title: Text(mode == "edit" ? "할일 수정" : "할일 추가"),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     _saveToDo(_formKey); // ⭐️ 저장 함수 호출
          //     print("할일 저장 버튼 클릭됨!"); // 디버깅용 출력
          //   },
          //   icon: Icon(Icons.save),
          // ),
          appBarLoadingOrSave(_isLoading, _saveToDo, _formKey),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // ⭐️ 할 일 제목 입력 필드
            TextFormField(
              controller: _titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text'; // ⭐️ 입력값 없을 때 에러
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "할일을 입력해주세요!",
                labelText: "제목",
                border: OutlineInputBorder(),
              ),
            ),
            // ⭐️ 카테고리 선택 위젯
            choiceCategory(
              category: widget.category,
              onPress: (changeCategory) {
                setState(() {
                  widget.category = changeCategory;
                });
              },
            ),
            // ⭐️ 우선순위 선택 위젯
            priorityBtns(
              priority: widget.priority,
              onPress: (changePriority) {
                setState(() {
                  widget.priority = changePriority;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ⭐️ 할 일 저장 함수: 폼 검증 후 Todo 객체 생성 및 이전 화면으로 전달
  void _saveToDo(GlobalKey<FormState> key) {
    // ⭐️ 디버깅 함수 호출: 저장 시점 상태 출력
    debugAddTodoScreenState(
      mode: "save",
      profileData: {},
      category: widget.category,
      priority: widget.priority,
      title: title,
    ); // ⭐️ 디버깅 함수 호출

    if (key.currentState?.validate() == true) {
      if (widget.category.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("카테고리를 선택해주세요!"),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      if (widget.priority.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("우선순위 선택해주세요!"),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      var todo = Todo(
        id: createToDoId(todoId, todoIndex),
        title: title,
        category: widget.category,
        priority: widget.priority,
        isCompleted: false,
      );

      Navigator.of(context).pop(todo); // ⭐️ 이전 화면으로 Todo 반환
    }
  }

  /// ⭐️ 고유 id 생성 함수
  String createToDoId(String id, int idx) {
    todoIndex++;
    return id + idx.toString();
  }

  /// ⭐️ 컨트롤러 해제 (메모리 누수 방지)
  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }
}

/// ⭐️ 카테고리 선택 위젯: 아침/오후/저녁 중 선택
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
            backgroundColor: Colors.yellow,
          ),
          onPressed: () {
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
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: CircleBorder(eccentricity: 0.8),
            backgroundColor: Colors.deepOrange,
          ),
          onPressed: () {
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
            backgroundColor: Colors.black26,
          ),
          onPressed: () {
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

/// ⭐️ 우선순위 선택 위젯: 높음/중간/낮음 중 선택
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () {
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
          ),
          onPressed: () {
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
          ),
          onPressed: () {
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



/// ⭐️ 전체 AddTodoScreen 상태를 디버깅하는 함수
/// - 각 주요 값과 타입, null 여부, 길이 등 출력
void debugAddTodoScreenState({
  required String mode,
  required Map<String, dynamic> profileData,
  required String category,
  required String priority,
  required String title,
}) {
  print("🔍 [디버깅] AddTodoScreen 상태 확인");
  print("  - mode: $mode");
  print("  - profileData: $profileData");
  print("  - category: $category");
  print("  - priority: $priority");
  print("  - title: $title");
  print("  - profileData 타입: ${profileData.runtimeType}");
  if (profileData.isNotEmpty) {
    profileData.forEach((k, v) {
      print("    - $k: $v (${v.runtimeType})");
    });
  }
}

/// ⭐️ 앱 실행 진입점: AddTodoScreen을 홈으로 지정
void main() {
  runApp(
    MaterialApp(
      home: AddTodoScreen(category: "", priority: "높음"),
      debugShowCheckedModeBanner: false,
    ),
  );
}
