import 'package:buttton_and_navigation/screens/dash_board_screen.dart';
import 'package:flutter/material.dart';
import 'package:buttton_and_navigation/models/todo.dart';
import 'dart:async';
import 'package:buttton_and_navigation/screens/add_todo_screen.dart';

// ⭐️ TodoListScreen: 할일 목록을 보여주고 추가/수정하는 메인 화면
class TodoListScreen extends StatefulWidget {
  // ⭐️ StatefulWidget: 할일 추가/완료 등 상태 변화가 있으므로 사용
  final List<Todo> todos; // 할일 목록을 저장하는 리스트
  final Function(Todo) onAddedToDo; // 할일 추가 콜백

  const TodoListScreen({
    Key? key,
    required this.todos,
    required this.onAddedToDo,
  }) : super(key: key); // 생성자에서 리스트 초기화

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

// ⭐️ 실제 상태와 UI를 관리하는 State 클래스
class _TodoListScreenState extends State<TodoListScreen> {
  // late List<Todo> todos; // 할일 목록 (초기화는 initState에서)

  // ⭐️ 할일 추가 함수: setState로 UI 갱신 필수

  @override
  void initState() {
    super.initState();
    print("📋 [TodoListScreen] initState 호출");
    print("📋 [TodoListScreen] 초기 todos 개수: ${widget.todos.length}");
    print("📋 [TodoListScreen] 받은 onAddedToDo: ${widget.onAddedToDo}");
    print("📋 [TodoListScreen] onAddedToDo 타입: ${widget.onAddedToDo.runtimeType}");

    if (widget.todos.isNotEmpty) {
      print("📋 [TodoListScreen] 초기 todos 내용:");
      for (int i = 0; i < widget.todos.length; i++) {
        print("  - [$i]: ${widget.todos[i].title}");
      }
    } else {
      print("📋 [TodoListScreen] 초기 todos 리스트가 비어있음");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("📋 [TodoListScreen] build 호출 - todos 개수: ${widget.todos.length}");
    return Scaffold(
      // ⭐️ Scaffold: 앱의 기본 레이아웃 제공 (앱바, 바디, 플로팅버튼 등)
      appBar: AppBar(
        // ⭐️ AppBar: 상단 바, 뒤로가기 버튼과 타이틀 포함
        leading: IconButton(
          onPressed: () {
            // ⭐️ Navigator.pop: 현재 화면을 스택에서 제거(이전 화면으로 이동)
            // - context: 현재 위젯의 위치 정보, Navigator에서 필수
            print("📋 [TodoListScreen] 뒤로가기 버튼 클릭");
            print("pop 전: 할일 목록 화면");
            Navigator.pop(context);
            print("pop 후: 대시보드로 돌아감");
          },
          icon: Icon(Icons.backspace_outlined),
        ),
        title: Text(
          "todos!",
          style: TextStyle(color: Colors.black12, fontSize: 20),
        ),
      ),
      // ⭐️ FloatingActionButton: 화면 우측 하단의 + 버튼, 할일 추가에 사용
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // ⭐️ Navigator.of(context).push: 새 화면(할일 추가)으로 이동, 결과를 await로 받음
          // - MaterialPageRoute: 화면 전환 애니메이션 및 위젯 생성
          // final pushed = await Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (BuildContext context) {
          //       return AddTodoScreen(category: "오후", priority: "중간");
          //     },
          //   ),
          // );
          print("➕ [TodoListScreen] + 버튼 클릭");
          print("➕ [TodoListScreen] AddTodoScreen으로 이동");

          final pushedName = await Navigator.of(context).pushNamed(
            "/addTodoScreen",
            arguments: {"category": "오후", "priority": "중간"},
          );
          // ⭐️ pop으로 반환된 값이 null이 아니면 할일 추가
          // if (pushed != null) {
          //   setState(() {
          //     widget.onAddedToDo(pushed);
          //   });
          // }
          if (pushedName != null) {
            setState(() {
              widget.onAddedToDo(pushedName as Todo);
            });
            print("할일 추가됨!");
          }
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          // ⭐️ 할일 개수 표시 (디버깅 및 정보 제공)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.red[100],
            child: Text(
              "할일 개수: ${widget.todos.length}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          // ⭐️ Expanded: 남은 공간을 모두 차지, ListView 등 스크롤 위젯에 필수
          Expanded(
            child: ListView.builder(
              // ⭐️ ListView.builder: 리스트를 효율적으로 생성, 스크롤 지원
              itemBuilder: (BuildContext context, int idx) {
                Todo todo = widget.todos[idx];
                return Card(
                  // ⭐️ Card: 각 할일을 카드 형태로 표시
                  child: Column(
                    children: [
                      Text("할일명 : ${todo.title}"),
                      SizedBox(height: 10),
                      Text("카테고리 : ${todo.category}"),
                      SizedBox(height: 10),
                      Text("우선순위 : ${todo.priority}"),
                      SizedBox(height: 10),
                      // ⭐️ 완료 상태 토글 버튼 (재사용성 위해 별도 위젯)
                      CompletedToggle(
                        isCompleted: todo.isCompleted,
                        onToggle: () {
                          setState(() {
                            todo.isCompleted = !todo.isCompleted;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      // ⭐️ 우선순위 변경 버튼 (재사용성 위해 별도 위젯)
                      priorityBtn(
                        priority: todo.priority,
                        onPress: (changePriority) {
                          setState(() {
                            todo.priority = changePriority;
                          });
                          print("${todo.priority}");
                        },
                      ),
                    ],
                  ),
                );
              },
              itemCount: widget.todos.length, // ⭐️ 반드시 개수 지정
            ),
          ),
        ],
      ),
    );
  }
}

// ⭐️ 할일 완료 상태 토글 버튼 (상태 변경 필요하므로 StatefulWidget)
class CompletedToggle extends StatefulWidget {
  final bool isCompleted;
  final VoidCallback onToggle;

  CompletedToggle({Key? key, required this.isCompleted, required this.onToggle})
    : super(key: key);

  @override
  State<CompletedToggle> createState() => _completedToggleState();
}

class _completedToggleState extends State<CompletedToggle> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        widget.onToggle();
        print("완료 상태 변경! 현재 완료 상태 : ${widget.isCompleted}");
      },
      child: widget.isCompleted ? Icon(Icons.check) : Icon(Icons.close),
      style: OutlinedButton.styleFrom(
        elevation: 5,
        padding: EdgeInsets.all(10),
        backgroundColor: widget.isCompleted ? Colors.blue : Colors.red,
        foregroundColor: widget.isCompleted ? Colors.black : Colors.green,
      ),
    );
  }
}

// ⭐️ 우선순위 변경 버튼 (여러 버튼을 한 줄에 배치)
class priorityBtn extends StatefulWidget {
  String priority;
  final Function(String) onPress;

  priorityBtn({super.key, required this.priority, required this.onPress});

  @override
  State<priorityBtn> createState() => _priorityBtnState();
}

class _priorityBtnState extends State<priorityBtn> {
  String returnPriority() {
    return widget.priority;
  }

  @override
  Widget build(BuildContext context) {
    const String high = "높음";
    const String medium = "중간";
    const String low = "낮음";

    print("우선순위: ${widget.priority}");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            setState(() {
              widget.onPress(high);
              returnPriority();
            });
          },
          child: Text("높음"),
        ),
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
      ],
    );
  }
}

/*
[초급자를 위한 핵심 및 주의점]
- ⭐️ Navigator: 화면 이동(페이지 전환) 담당, push/pop 등으로 스택 구조로 관리됨
- ⭐️ context: 위젯 트리의 위치 정보, Navigator, Theme 등에서 자주 사용
- ⭐️ setState: 상태 변경 시 반드시 호출해야 UI가 갱신됨
- ⭐️ ListView.builder: 많은 데이터도 효율적으로 스크롤 처리, itemCount 필수
- ⭐️ FloatingActionButton: 할일 추가 등 주요 액션에 사용, onPressed에서 Navigator로 새 화면 이동
- ⭐️ Card, Column, Row 등 레이아웃 위젯은 UI 배치와 정렬에 필수, 중첩이 많아지면 성능/가독성에 주의
- ⭐️ 파라미터로 전달된 값이 변경될 때 setState로 갱신해야 UI에 반영됨
- ⭐️ 위젯의 상태(할일, 우선순위 등)는 부모에서 관리, 콜백으로 자식에서 변경
*/
