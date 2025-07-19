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
          final arguments =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          debugRouteArguments(arguments);

          return TodoListScreen(
            todos: arguments?['todos'] ?? [],
            onAddedToDo:
                arguments?['onAddedToDo'] ??
                (todo) {
                  print("❌ [2단계] 기본 콜백 실행 - 데이터 전달 실패!");
                },
            mode: arguments?['mode'] ?? "edit",
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

// ⭐️ 디버깅용 함수: arguments Map을 받아 상세 정보 출력, 확장성 고려
void debugRouteArguments(Map<String, dynamic>? arguments) {
  print("🔧 [디버깅] arguments 전체: $arguments");
  print("🔧 [디버깅] arguments 타입: ${arguments.runtimeType}");
  print("🔧 [디버깅] arguments null 여부: ${arguments == null}");

  if (arguments != null) {
    print("🔧 [디버깅] arguments 키들: ${arguments.keys}");
    for (var key in arguments.keys) {
      print("🔧 [디버깅] $key 값: ${arguments[key]}");
      print("🔧 [디버깅] $key 타입: ${arguments[key]?.runtimeType}");
      if (arguments[key] is List) {
        print("🔧 [디버깅] $key 길이: ${(arguments[key] as List).length}");
      }
    }
  } else {
    print("❌ [디버깅] arguments가 null입니다!");
  }
}
