import 'package:flutter/material.dart';
import 'package:buttton_and_navigation/models/todo.dart';
import 'package:buttton_and_navigation/screens/setting_screen.dart';
import 'package:buttton_and_navigation/screens/todo_list_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  void addTodo(Todo todo) {
    setState(() {
      todos.add(todo);
    });
  }

  List<Todo> todos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ⭐️ 모던한 그라데이션 배경
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0eafc), Color(0xFFcfdef3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 상단 AppBar 대체: 투명 배경, 그림자, 라운드
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "대시보드",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900],
                        letterSpacing: 1.2,
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.dashboard_customize,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    // 할일 목록 카드
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.checklist, color: Colors.white),
                        ),
                        title: Text(
                          "할일 목록",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text("오늘의 할일을 확인하고 추가하세요."),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.blueAccent,
                        ),
                        onTap: () {
                          moveTodoScreen();
                          print("할일 목록 버튼 클릭됨!"); // 디버깅용 출력
                        },
                      ),
                    ),
                    // 할일 개수 표시 카드
                    Card(
                      color: Colors.blue[50],
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ListTile(
                        leading: Icon(
                          Icons.format_list_numbered,
                          color: Colors.blue,
                        ),
                        title: Text(
                          "현재 할일 개수",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          "${todos.length}",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // 통계 보기 카드 (비활성화)
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ListTile(
                        leading: Icon(Icons.bar_chart, color: Colors.grey),
                        title: Text(
                          "통계 보기",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        subtitle: Text(
                          "준비 중입니다.",
                          style: TextStyle(color: Colors.grey),
                        ),
                        enabled: false,
                      ),
                    ),
                    // 설정 카드
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ListTile(
                        leading: Icon(Icons.settings, color: Colors.deepPurple),
                        title: Text(
                          "설정",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.deepPurple,
                        ),
                        onTap: () {
                          print("설정 버튼 클릭됨!");
                          Navigator.of(context).pushNamed("/settingScreen");
                          print("설정 화면으로 이동!"); // 디버깅용 출력
                        },
                      ),
                    ),
                    // 프로필 카드
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ListTile(
                        leading: Icon(Icons.person, color: Colors.teal),
                        title: Text(
                          "프로필",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.teal,
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            "/profileScreen",
                            arguments: {
                              "mode": "view",
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
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveTodoScreen() {
    print("🚀 [1단계] DashBoardScreen - moveTodoScreen 시작");
    print("🚀 [1단계] 현재 todos 개수: ${todos.length}");
    print("🚀 [1단계] todos 내용: $todos");
    print("🚀 [1단계] addTodo 함수: $addTodo");

    Navigator.of(context).pushNamed(
      "/todoListScreen",
      arguments: {"todos": todos, "onAddedToDo": addTodo},
    );
    print("🚀 [1단계] pushNamed 완료");
  }
}
