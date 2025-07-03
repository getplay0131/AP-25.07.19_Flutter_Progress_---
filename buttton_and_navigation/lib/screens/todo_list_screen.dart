import 'package:buttton_and_navigation/screens/dash_board_screen.dart';
import 'package:flutter/material.dart';
import 'package:buttton_and_navigation/models/todo.dart';
import 'dart:async';
import 'package:buttton_and_navigation/screens/add_todo_screen.dart';

class TodoListScreen extends StatefulWidget {
  // 화면 변경이 있으므로 스테이트풀 사용
  final List<Todo> todos; // 투두를 저장할 리스트 사용
  const TodoListScreen({Key? key, this.todos = const []})
    : super(key: key); // 생성자로 리스트 초기화

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

// 본격적인 작업을 할 스테이트
class _TodoListScreenState extends State<TodoListScreen> {
  late List<Todo> todos; // 나중에 초기화 설정

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todos = List.from(widget.todos); // 상위 클래스의 리스트 복사해서 투두에 저장
  }

  void addTodo(Todo todo) {
    // 투두 추가
    setState(() {
      // 빌드 변경이 필요하므로 셋 스테이트 사용
      todos.add(todo); // 로컬 리스트애 해당 파라미터의 값을 추가한다.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 기본 레이아웃 설정
      appBar: AppBar(
        //앱바 설정
        leading: IconButton(
          // 아이콘을 내용으로 하는 버튼 위젯 사용
          onPressed: () {
            // 클릭시 익명 함수 호출
            print("pop 전: 할일목록 화면"); // 네비게이터 이해를 위해 디버깅 사용
            Navigator.pop(context); // 이전 화면으로 돌아감
            print("pop 후: 대시보드로 돌아감");
          },
          icon: Icon(
            Icons.backspace_outlined,
          ), // 아이콘 설정. 아이콘의 값을 아이콘 위젯을 사용하며 값을 아이콘 값 설정
        ),
        title: Text(
          // 앱바의 타이틀 설정
          "todos!",
          style: TextStyle(
            color: Colors.black12,
            fontSize: 20,
          ), // 앱바 타이틀 텍스트 꾸미기 설정
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pushed = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return AddTodoScreen(category: "오후", priority: "중간");
              },
            ),
          );
          if (pushed != null) {
            setState(() {
              todos.add(pushed);
            });
          }
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          // 간단한 디버깅 - 이것만 추가!
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.red[100],
            child: Text(
              "할일 개수: ${todos.length}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          Expanded(
            child: ListView.builder(
              // 리스트뷰 사용을 위해 빌더 사용
              itemBuilder: (BuildContext context, int idx) {
                // 빌더의 아이템 빌드 시작
                Todo todo = todos[idx]; // 상위의 투두의 데이터를 해당 타입의 변수에 저장
                return Card(
                  // 카드를 리스트로 관리
                  child: Column(
                    // 세로 배치
                    children: [
                      Text("할일명 : ${todo.title}"), // 투두의 타이틀을 텍스트로 표시
                      SizedBox(height: 10), // 텍스트와 텍스트 사이의 간격
                      Text("카테고리 : ${todo.category}"), // 투두의 카테고리를 텍스트로 표시
                      SizedBox(height: 10),
                      Text("우선순위 : ${todo.priority}"), // 투두의 우선순위를 텍스트로 표시
                      SizedBox(height: 10),
                      CompletedToggle(
                        // 완료 상태 전환을 위한 클래스 호출
                        isCompleted: todo.isCompleted, // 파라미터를 투두의 완료 상태를 사용
                        onToggle: () {
                          // 콜백 함수의 값
                          setState(() {
                            // 빌드 재실행을 위해 셋스테이트 사용
                            todo.isCompleted = !todo.isCompleted; // 상태 반전
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      priorityBtn(
                        // 완료 상태 버튼 재사용성을 위해 클래스 호출
                        priority: todo.priority, // 완료 여부 전달
                        onPress: (changePriority) {
                          // 클릭시 함수의 파라미터 값 전달
                          setState(() {
                            // 상태 변경을 위해 세트 스테이트 사용
                            todo.priority = changePriority; // 우선순위 변경
                          });
                          print("${todo.priority}");
                        },
                      ),
                    ],
                  ),
                );
              },
              itemCount: todos.length, // 아이템 개수 속성 사용 필요
            ),
          ),
        ],
      ),
    );
  }
}

class CompletedToggle extends StatefulWidget {
  // 상태 변경이 필요하므로 스테이트 풀
  final bool isCompleted; // 완료 상태
  final VoidCallback onToggle; // 완료 상태 반전을 위해 콜백 함수 받기

  CompletedToggle({Key? key, required this.isCompleted, required this.onToggle})
    : super(key: key); // 생성자를 통해 값 받기 및 초기화

  @override
  State<CompletedToggle> createState() => _completedToggleState();
}

// 본격 작업 시작
class _completedToggleState extends State<CompletedToggle> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      // 버튼 반환
      onPressed: () {
        // 클릭시 익명함수 통하여 작업 진행
        widget.onToggle(); // 클릭시 전달받은 함수 호출
        print("완료 상태 변경! 현재 완료 상태 : ${widget.isCompleted}");
      },
      child: widget.isCompleted == true
          ? Icon(Icons.check)
          : // 삼항 연산자를 통해 상태에 따른 아이콘 설정
            Icon(Icons.close),
      style: OutlinedButton.styleFrom(
        // 버튼 스타일 설정
        elevation: 5, // 그림자 설정
        // elevation: MaterialStateProperty.all(5.0), // 현재는 권장하지 않는 값이다.
        padding: EdgeInsets.all(10), // 내부 여백 설정
        backgroundColor: widget.isCompleted == true
            ? Colors.blue
            : Colors.red, // 값에 따라 컬러 설정
        foregroundColor:
            widget.isCompleted ==
                true // 내부 요소 설정에 따른 컬러 설정
            ? Colors.black
            : Colors.green,
      ),
    );
  }
}

// 상태 변화 없으므로 스테이트 리스 사용
class priorityBtn extends StatefulWidget {
  String priority;

  final Function(String) onPress; // 함수와 파라미터를 지정한 해당 타입의 파라미터 받기

  // 생성자 통해 값 초기화
  priorityBtn({super.key, required this.priority, required this.onPress});

  @override
  State<priorityBtn> createState() => _priorityBtnState();
}

class _priorityBtnState extends State<priorityBtn> {
  String returnPriority() {
    // 완료 상태 반환
    return widget.priority;
  }

  @override
  Widget build(BuildContext context) {
    const String high = "높음"; // 범용적 사용을 위해 스태틱 사용 및 콘스트로 값 변경 방지

    const String medium = "중간";

    const String low = "낮음";

    print("우선순위: ${widget.priority}");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, // 버튼 사이 간격 조정
      // 가로 배치
      children: [
        TextButton(
          // 일반 텍스트 버튼 사용
          // style: ButtonStyle(
          //   // 버튼 스타일 설정인데 값이 다 권장하지 않는 값이다.
          //   backgroundColor: MaterialStateProperty.all(Colors.green),
          //   foregroundColor: MaterialStateProperty.all(Colors.white),
          // ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            // 클릭시 익명 함수 활용
            setState(() {
              widget.onPress(high); // 클릭시 파라미터 값 전달
              returnPriority();
            });
          },
          child: Text("높음"), // 버튼 텍스트 설정
        ),
        // SizedBox(width: 8),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            setState(() {
              widget.onPress(medium);
              returnPriority();
            });
          },
          child: Text("중간"),
        ),
        // SizedBox(width: 8),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            setState(() {
              widget.onPress(low);
              returnPriority();
            });
          },
          child: Text("낮음"),
        ),
        // SizedBox(width: 8),
      ],
    );
  }
}
