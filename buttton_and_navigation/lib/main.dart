import 'package:buttton_and_navigation/screens/dash_board_screen.dart';
import 'package:buttton_and_navigation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:buttton_and_navigation/screens/add_todo_screen.dart';
import 'package:buttton_and_navigation/screens/todo_list_screen.dart';
import 'package:buttton_and_navigation/screens/setting_screen.dart';

void main() {
  runApp(
    MaterialApp(
      home: DashBoardScreen(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        "/addTodoScreen": (context) =>
            AddTodoScreen(category: "", priority: ""),
        "/todoListScreen": (context) {
          print("🔧 [2단계] routes - TodoListScreen 생성 시작");

          final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          print("🔧 [2단계] arguments 전체: $arguments");
          print("🔧 [2단계] arguments 타입: ${arguments.runtimeType}");
          print("🔧 [2단계] arguments null 여부: ${arguments == null}");

          if (arguments != null) {
            print("🔧 [2단계] arguments 키들: ${arguments.keys}");
            print("🔧 [2단계] todos 키 존재: ${arguments.containsKey('todos')}");
            print("🔧 [2단계] todos 값: ${arguments['todos']}");
            print("🔧 [2단계] todos 타입: ${arguments['todos'].runtimeType}");
            print("🔧 [2단계] todos 길이: ${arguments['todos']?.length}");
          } else {
            print("❌ [2단계] arguments가 null입니다!");
          }

          return TodoListScreen(
            todos: arguments?['todos'] ?? [],
            onAddedToDo: arguments?['onAddedToDo'] ?? (todo) {
              print("❌ [2단계] 기본 콜백 실행 - 데이터 전달 실패!");
            },
          );
        },
        "/dashBoardScreen": (context) => DashBoardScreen(),
        // 대시보드 화면으로 이동
        "/settingScreen": (context) => SettingScreen(isModeChange: false),
        "/profileScreen": (context) => ProfileScreen(
          profileId: "testId1",
          profileName: "tester",
          profileImage: "assets/imgs/m_20200316013238_tuvglfxp.jpg",
          profileBio: "This is a test profile bio.",
          profileEmail: "this is a test email",
          profilePhone: "010-1234-5678",
          profileAge: 33,
        ),
      },
    ),
  );
}
