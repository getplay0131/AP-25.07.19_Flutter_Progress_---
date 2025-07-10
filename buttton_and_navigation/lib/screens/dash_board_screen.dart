import 'package:flutter/material.dart';
import 'package:buttton_and_navigation/models/todo.dart';
import 'package:buttton_and_navigation/screens/setting_screen.dart';
import 'package:buttton_and_navigation/screens/todo_list_screen.dart';

// ⭐️ DashBoardScreen: 여러 화면(할일, 통계, 설정, 프로필)으로 이동하는 대시보드 역할
class DashBoardScreen extends StatefulWidget {
  // ⭐️ StatefulWidget: 화면의 상태(예: 버튼 클릭 등)가 바뀔 수 있을 때 사용
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState(); // 상태 객체 생성
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  void addTodo(Todo todo) {
    setState(() {
      todos.add(todo);
    });
  }

  List<Todo> todos = []; // ⭐️ 할일 목록을 저장하는 리스트

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // ⭐️ SafeArea: 노치, 상태바 등 시스템 UI 영역을 피해 안전하게 화면을 배치
      child: Scaffold(
        // ⭐️ Scaffold: 앱의 기본 레이아웃(앱바, 바디, 플로팅버튼 등) 제공
        appBar: AppBar(title: Text("플러터 앱!")), // 상단 앱바(타이틀 표시)
        body: Center(
          // ⭐️ Center: 자식 위젯을 화면 중앙에 배치
          child: Column(
            // ⭐️ Column: 위젯을 세로로 나열
            mainAxisAlignment: MainAxisAlignment.center, // 세로축 중앙 정렬
            crossAxisAlignment: CrossAxisAlignment.center, // 가로축 중앙 정렬
            children: [
              // ⭐️ 버튼 1: 할일 목록으로 이동
              Container(
                width: 300,
                child: ElevatedButton(
                  // ⭐️ ElevatedButton: 그림자와 배경색이 있는 버튼
                  onPressed: () {
                    // ⭐️ 버튼 클릭 시 실행되는 함수
                    moveTodoScreen(); // 할일 목록 화면으로 이동
                    print("할일 목록 버튼 클릭됨!"); // 디버깅용 출력
                  },
                  child: Text(
                    "할일 목록 버튼!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // 배경색
                    foregroundColor: Colors.white, // 텍스트 색
                    elevation: 5, // 그림자 깊이
                    padding: EdgeInsets.all(16), // 내부 여백
                  ),
                ),
              ),
              SizedBox(height: 30), // 위젯 간 간격 조절
              // ⭐️ 현재 Todo 개수 표시 (디버깅용)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "현재 할일 개수: ${todos.length}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30),
              // ⭐️ 버튼 2: 통계 보기 (비활성화)
              Container(
                width: 300,
                child: ElevatedButton(
                  onPressed: null, // ⭐️ null이면 버튼이 비활성화됨
                  child: Text(
                    "통계 보기 버튼!",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.black12, // 비활성화 배경색
                    disabledForegroundColor: Colors.amber, // 비활성화 텍스트색
                  ),
                ),
              ),
              SizedBox(height: 30),

              // ⭐️ 버튼 3: 설정 화면으로 이동
              Container(
                width: 300,
                child: OutlinedButton(
                  // ⭐️ OutlinedButton: 테두리만 있는 버튼
                  onPressed: () {
                    print("설정 버튼 클릭됨!");
                    // ⭐️ Navigator: 화면(페이지) 이동을 담당하는 플러터의 내장 객체
                    // - push: 새 화면을 스택에 쌓아 이동
                    // - MaterialPageRoute: 새 화면을 생성하는 방법 지정
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (BuildContext context) {
                    //       return SettingScreen(isModeChange: false); // 이동할 화면
                    //     },
                    //   ),
                    // );
                    Navigator.of(context).pushNamed("/settingScreen");
                    // ⭐️ pushNamed: 라우트 이름으로 화면 이동, routes에서 정의된 이름 사용
                    print("설정 화면으로 이동!"); // 디버깅용 출력
                  },
                  child: Text("설정"),
                ),
              ),
              SizedBox(height: 30),

              // ⭐️ 버튼 4: 프로필 (기능 없음, 예시용)
              Container(
                width: 300,
                child: TextButton(
                  // ⭐️ TextButton: 배경 없이 텍스트만 있는 버튼
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      "/profileScreen",
                      arguments: {
                        "mode": "view", // 프로필 보기 모드
                        "profileData": {
                          "profileId": "user123",
                          "profileName": "홍길동",
                          "profileImage":
                              "assets/images/9954DA505D25EA541A.jpg",
                          "profileBio": "안녕하세요! 저는 플러터 개발자입니다.",
                          "profileEmail": "example@naver.com",
                          "profilePhone": "010-1234-5678",
                        },
                      },
                    );
                    print("프로필 버튼 클릭됨!");
                  },
                  child: Text("프로필"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ⭐️ Navigator 사용법 자세히 설명
  // - Navigator.of(context): 현재 위젯 트리에서 가장 가까운 Navigator를 찾음
  // - push: 새 화면을 스택에 쌓아 이동 (뒤로가기 가능)
  // - MaterialPageRoute: 새 화면을 생성하는 방법(애니메이션, 트랜지션 등 포함)
  // - builder: 실제로 보여줄 위젯(화면)을 반환하는 함수
  void moveTodoScreen() {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) {
    //       return TodoListScreen(
    //         todos: todos,
    //         onAddedToDo: addTodo, // 할일 추가 콜백 함수 전달
    //       ); // 이동할 화면 반환
    //     },
    //   ),
    // );
    print("🚀 [1단계] DashBoardScreen - moveTodoScreen 시작");
    print("🚀 [1단계] 현재 todos 개수: ${todos.length}");
    print("🚀 [1단계] todos 내용: $todos");
    print("🚀 [1단계] addTodo 함수: $addTodo");

    // ⭐️ 테스트용 더미 데이터 추가해보기
    // print("🧪 [테스트] 더미 데이터 추가 테스트");
    // todos.add(Todo(
    //     id: "test_id",
    //     title: "테스트 할일",
    //     category: "테스트",
    //     priority: "높음",
    //     isCompleted: false
    // ));
    // print("🧪 [테스트] 더미 추가 후 todos 개수: ${todos.length}");

    Navigator.of(context).pushNamed(
      "/todoListScreen",
      arguments: {"todos": todos, "onAddedToDo": addTodo},
    );
    print("🚀 [1단계] pushNamed 완료"); // 디버깅용 출력
  }
}

/*
[초급자를 위한 핵심 및 주의점]
- ⭐️ Navigator는 화면 이동(페이지 전환)에 반드시 필요, push/pop 등으로 스택 구조로 관리됨
- ⭐️ context는 위젯 트리의 위치 정보를 담고 있어 Navigator, Theme 등에서 자주 사용
- ⭐️ 버튼의 onPressed에 null을 넣으면 비활성화됨 (UI/UX에 따라 적절히 사용)
- ⭐️ 레이아웃 위젯(Container, Column, SizedBox 등)은 UI 배치와 간격 조절에 필수
- ⭐️ 버튼 스타일은 ElevatedButton.styleFrom 등으로 커스터마이즈 가능
- ⭐️ MaterialPageRoute는 화면 전환 애니메이션 등 기본 제공, builder에서 새 화면 반환
- ⭐️ 화면 이동 시 반드시 context를 올바른 위치에서 사용해야 함 (빌드 메서드 내에서 주로 사용)
*/
