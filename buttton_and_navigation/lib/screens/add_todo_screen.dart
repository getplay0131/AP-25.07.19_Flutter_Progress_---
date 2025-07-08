import 'package:buttton_and_navigation/models/todo.dart';
import 'package:buttton_and_navigation/screens/todo_list_screen.dart';
import 'package:flutter/material.dart';

// ⭐️ AddTodoScreen: 할 일 추가 화면, category와 priority를 생성자로 받음
// - StatefulWidget: 화면 내 상태(입력값, 선택값 등)가 바뀔 수 있으므로 사용
class AddTodoScreen extends StatefulWidget {
  String category; // ⭐️ 부모에서 전달받은 카테고리(아침/오후/저녁)
  String priority; // ⭐️ 부모에서 전달받은 우선순위(높음/중간/낮음)

  AddTodoScreen({Key? key, required this.category, required this.priority})
    : super(key: key);

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  // ⭐️ TextEditingController: TextFormField의 입력값을 실시간으로 읽고, 초기화/해제 관리
  final TextEditingController _titleController = TextEditingController();

  // ⭐️ static 변수: 여러 인스턴스에서 공유, 고유 id 생성을 위해 사용 (동시성 이슈 주의)
  static String todoId = "todoId";
  static int todoIndex = 0;

  // ⭐️ 입력된 텍스트 반환 (getter)
  String get title => _titleController.text;

  @override
  Widget build(BuildContext context) {
    // ⭐️ GlobalKey<FormState>: 폼 검증을 위한 키, Form 위젯과 연결
    final _formKey = GlobalKey<FormState>();
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String mode = arguments?['mode'] ?? 'view'; // ⭐️ 모드 설정 (기본값: 'view')
    final Map<String, dynamic> profileData =
        arguments?['profileData'] ??
        {"id": "defaultId", "name": "defaultName", "email": "defaultEmail"};

    return Scaffold(
      appBar: AppBar(
        title: Text(mode == "edit" ? "할일 수정" : "할일 추가"),
        actions: [
          IconButton(
            onPressed: () {
              _saveToDo(_formKey); // ⭐️ 저장 함수 호출
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
            // ⭐️ TextFormField: 사용자 입력을 받는 위젯
            // - controller로 입력값을 실시간 관리
            // - validator로 입력값 검증 (폼 제출 시 유효성 체크)
            // - decoration으로 힌트, 라벨, 테두리 등 UI 설정
            // [주의] Column 등 레이아웃에 중첩될 때 스크롤이 필요하면 SingleChildScrollView로 감싸야 함
            TextFormField(
              controller:
                  _titleController, // ⭐️ 입력값을 관리하는 TextEditingController
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text'; // ⭐️ 입력값이 없으면 에러 메시지 반환
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "할일을 입력해주세요!",
                labelText: "제목",
                border: OutlineInputBorder(),
              ),
            ),
            // ⭐️ 카테고리 선택 위젯: 파라미터로 전달된 category 값이 변경될 때 setState로 반드시 갱신해야 UI에 반영됨
            choiceCategory(
              category: widget.category,
              onPress: (changeCategory) {
                setState(() {
                  widget.category = changeCategory;
                });
                print(widget.category);
              },
            ),
            // ⭐️ 우선순위 선택 버튼: 파라미터 값이 자식 위젯에서 변경될 때, 부모의 상태도 반드시 갱신해야 함
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

  // ⭐️ 할 일 저장 함수: 폼 검증 후 Todo 객체 생성 및 이전 화면으로 전달
  // - Navigator.of(context).pop(todo): 이전 화면으로 객체 전달 (push로 이동한 화면에서만 사용)
  void _saveToDo(GlobalKey<FormState> key) {
    print("=== 저장 시작 ===");
    print("제목: '$title'");
    print("카테고리: '${widget.category}'");
    print("우선순위: '${widget.priority}'");

    if (key.currentState?.validate() == true) {
      print("✅ 폼 검증 통과!");

      if(widget.category.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("카테고리를 선택해주세요!"), backgroundColor: Colors.orange,),);
      print("카테고리 선택 안됨!");
        return;
      }

      if(widget.priority.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("우선순위 선택해주세요!"), backgroundColor: Colors.orange,),);
        print("우선순위 선택 안됨!");
        return;
      }

      print("✅ 모든 검증 통과!");

      var todo = Todo(
        id: createToDoId(todoId, todoIndex),
        title: title,
        category: widget.category,
        priority: widget.priority,
        isCompleted: false,
      );

      print("📝 Todo 생성 완료:");
      print("- ID: ${todo.id}");
      print("- 제목: ${todo.title}");
      print("- 카테고리: ${todo.category}");
      print("- 우선순위: ${todo.priority}");

      // ⭐️ pop으로 Todo 객체 전달 (이전 화면에서 받을 수 있음)

        Navigator.of(context).pop(todo);
      print("🚀 할일 데이터 반환 완료!");
    } else {
      print("❌ 폼 검증 실패!");
    }
  }

  // ⭐️ 고유 id 생성 함수: static 변수 활용, 반드시 인덱스 증가 필요
  String createToDoId(String id, int idx) {
    todoIndex++;
    return id + idx.toString();
  }

  // ⭐️ 컨트롤러 해제 (메모리 누수 방지)
  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }
}

// ⭐️ 카테고리 선택 위젯: 아침/오후/저녁 선택, 선택 시 onPress 콜백 호출
// - 상태 변경 시 setState로 UI 갱신
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

// ⭐️ 우선순위 선택 버튼 위젯: 높음/중간/낮음 선택, 선택 시 onPress 콜백 호출
// - 상태 변경 시 setState로 UI 갱신
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

// ⭐️ 디버깅용
main() {
  runApp(
    MaterialApp(
      home: AddTodoScreen(category: "", priority: "높음"),
      debugShowCheckedModeBanner: false,
    ),
  );
}

/*
[초급자를 위한 핵심 및 주의점]
- ⭐️ static 변수는 인스턴스 간 값 공유, id 생성에 적합하지만 동시성 이슈에 주의
- ⭐️ Form과 GlobalKey는 폼 검증에 필수, 키를 반드시 연결해야 함
- ⭐️ Navigator.pop으로 객체 전달 시, 이전 화면에서 받을 수 있음 (push로 이동한 경우만)
- ⭐️ 컨트롤러는 dispose에서 해제 (메모리 누수 방지)
- ⭐️ setState는 UI 갱신에 필수, 값 변경 시 반드시 호출
- ⭐️ 위젯의 상태(카테고리, 우선순위)는 부모에서 관리, 콜백으로 자식에서 변경
- ⭐️ TextFormField는 controller로 입력값을 관리하고, validator로 유효성 검증
- ⭐️ Column, Row 등 레이아웃 중첩이 많아지면 성능 저하 및 UI 깨짐에 주의 (특히 스크롤 필요시 SingleChildScrollView 등 사용)
- ⭐️ 파라미터로 전달된 값이 null이거나 예상치 못한 값일 때 예외 처리 필요
*/
