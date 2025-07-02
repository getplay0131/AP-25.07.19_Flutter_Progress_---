import 'package:buttton_and_navigation/screens/todo_list_screen.dart';
import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  // 화면 변경이 필요하므로 스테이트 풀
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState(); // 스테이트 생성
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // 시스템 유아이 제외 영역 사용
      child: Scaffold(
        // 기본 레이아웃 제공
        appBar: AppBar(title: Text("플러터 앱!")), // 앱 바 레이아웃 사용으로 상단 텍스트 지정
        body: Center(
          // 중앙 정렬
          child: Column(
            // 세로 배치
            mainAxisAlignment: MainAxisAlignment.center, // 주축 가운데
            crossAxisAlignment: CrossAxisAlignment.center, // 교차축 가운데
            children: [
              Container(
                // 버튼을 담을 컨테이너 사용
                width: 300, // 너비
                child: ElevatedButton(
                  // 버튼 강조를 위해 사용하는 위젯
                  onPressed: () {
                    // 클릭시 익명 함수 호출
                    moveTodoScreen(); // 투두 스크린으로 이동할 함수 호출
                    print("할일 목록 버튼 클릭됨!"); // 디버깅용 메시지
                  },
                  child: Text(
                    // 버튼의 내용
                    "할일 목록 버튼!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ), // 버튼의 내용 꾸미기 설정
                  ),
                  style: ElevatedButton.styleFrom(
                    // 버튼의 스타일 설정
                    backgroundColor: Colors.blue, // 배경색 설정
                    foregroundColor: Colors
                        .white, // 내용색 설정 > 텍스트 색상도 제어 > 텍스트 스타일의 색상이 우선 적용 됨
                    elevation: 5, // 버튼 그림자 정도
                    padding: EdgeInsets.all(16), // 내부 여백
                  ),
                ),
              ),
              SizedBox(height: 30), // 위젯들간의 간격 조절
              Container(
                width: 300,
                child: ElevatedButton(
                  onPressed: null, // 우선 클릭시 실행 기능 없음
                  child: Text(
                    // 버튼의 내용
                    "통계 보기 버튼!",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ), // 텍스트 스타일 설정
                  ),
                  style: ElevatedButton.styleFrom(
                    // 버튼은 이렇게 스타일 설정을 하니까 기억해야 한다.
                    disabledBackgroundColor: Colors.black12, // 비 활성화시 배경색
                    disabledForegroundColor: Colors.amber, // 비 활성화시 내용의 색
                  ),
                ),
              ),
              SizedBox(height: 30), // 위젯 간격 조절용 위젯
              Container(
                width: 300,
                child: OutlinedButton(
                  // 테두리만 있는 버튼
                  onPressed: () {
                    print("설정 버튼 클릭됨!");
                  },
                  child: Text("설정"), // 버튼의 내용
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 300,
                child: TextButton(
                  // 일반 텍스트만 버튼
                  onPressed: () {
                    // 클릭시 호출할 함수
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

  void moveTodoScreen() {
    // 투두 스크린으로 이동하기 위한 함수
    Navigator.of(context).push(
      // 네비게이터는 이동 기능을 제공하는 클래스이다. 오브로 가장 가까운 위젯에 네비게이터를 찾고, 푸시로 현재 화면의 스택에 쌓는다.
      MaterialPageRoute(
        // 페이지 경로 설정
        builder: (BuildContext context) {
          //해당 페이지의 빌더 > 페이지를 생성하는 역할
          return TodoListScreen(); // 이동할 페이지
        },
      ),
    );
  }
}
