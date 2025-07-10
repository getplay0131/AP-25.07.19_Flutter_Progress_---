import 'package:flutter/material.dart';
import 'package:buttton_and_navigation/screens/dash_board_screen.dart';

// ⭐️ SettingScreen: 앱의 설정 화면, 다크모드 전환 및 데이터 초기화 등 제공
class SettingScreen extends StatefulWidget {
  bool isModeChange; // ⭐️ 부모로부터 다크모드 상태를 전달받음

  SettingScreen({Key? key, required this.isModeChange}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late bool isDarkMode; // ⭐️ 현재 다크모드 상태를 저장

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isModeChange; // ⭐️ 부모에서 전달받은 값으로 초기화
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // ⭐️ 뒤로가기 버튼 기본 동작 막기 (직접 제어)
      // ⭐️ 뒤로가기 시 AlertDialog로 사용자 확인 받기
      onPopInvokedWithResult: (didPop, result) async {
        bool? check = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("뒤로가기"),
              content: Text("뒤로가기를 누르면 설정이 초기화 됩니다. 계속하시겠습니까?"),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // 취소: false 반환
                  },
                  child: Text("취소"),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // 확인: true 반환
                  },
                  child: Text("확인"),
                ),
              ],
            );
          },
        );
        if (check != null && check) {
          Navigator.of(context).pop(); // ⭐️ 확인 시 실제로 뒤로가기
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("설정"),
          actions: [
            // ⭐️ 다크모드 토글 버튼 (아이콘+텍스트)
            ElevatedButton.icon(
              onPressed: () {
                // ⭐️ setState: 상태 변경 시 UI 갱신 필수
                setState(() {
                  isDarkMode = !isDarkMode; // 다크모드 상태 반전
                  widget.isModeChange = isDarkMode; // 부모에도 반영
                });
                // ⭐️ ScaffoldMessenger: 스낵바 등 메시지 표시 담당
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isDarkMode ? "다크모드로 변경!" : "라이트모드로 변경!",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: "취소",
                      onPressed: () {
                        setState(() {
                          isDarkMode = !isDarkMode;
                          widget.isModeChange = isDarkMode;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("모드 변경이 취소 되었습니다.!"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: isDarkMode
                        ? Colors.grey[800]
                        : Colors.grey[200],
                  ),
                );
              },
              label: Text("버튼"),
              icon: isDarkMode ? Icon(Icons.dark_mode) : Icon(Icons.light_mode),
            ),
            // ⭐️ 데이터 초기화 버튼 (AlertDialog로 확인)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.red : Colors.blue,
                    foregroundColor: Colors.grey,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("데이터 초기화"),
                          content: Text("데이터를 초기화 하시겠습니까?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                OutlinedButton(
                                  child: Text("취소"),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                  },
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                    // ⭐️ pushNamedAndRemoveUntil: 모든 화면 제거 후 대시보드로 이동
                                    Navigator.of(
                                      // 기존 데이터 삭제되는 문제 발생
                                      context,
                                    ).pushNamedAndRemoveUntil(
                                      "/dashBoardScreen",
                                      (route) => false,
                                    );
                                    // Navigator.of(context).pushAndRemoveUntil(
                                    //   MaterialPageRoute(
                                    //     builder: (context) => DashBoardScreen(),
                                    //   ),
                                    //   (route) => false,
                                    // );
                                    print("데이터 초기화 완료!"); // 디버깅용 출력
                                  },
                                  child: Text("확인"),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text("데이터 초기화!"),
                ),
              ],
            ),
            // ⭐️ 홈(대시보드)로 이동 버튼
            OutlinedButton(
              onPressed: () {
                // ⭐️ pushReplacement: 현재 화면을 대체하며 이동 (뒤로가기 불가)
                // Navigator.of(context).pushReplacement( // 데이터를 다 지우고 새로 인스턴스를 만드는 문제 발생
                //   MaterialPageRoute(
                //     builder: (BuildContext context) {
                //       return DashBoardScreen();
                //     },
                //   ),
                // );
                // Navigator.of(context).pop();
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil("/dashBoardScreen", (route) => false);
              },
              child: Icon(Icons.home),
            ),
          ],
        ),
        body: SafeArea(child: Center(child: Text("설정 화면"))),
      ),
    );
  }
}

// ⭐️ 앱 실행 진입점: SettingScreen을 홈으로 지정
main() {
  runApp(MaterialApp(home: SettingScreen(isModeChange: false)));
}

/*
[초급자를 위한 핵심 및 주의점]
- ⭐️ Navigator: 화면 이동(페이지 전환) 담당, push/pushReplacement/pushNamedAndRemoveUntil 등 다양한 방식 존재
- ⭐️ context: 위젯 트리의 위치 정보, Navigator, showDialog, Theme 등에서 필수로 사용
- ⭐️ showDialog: 다이얼로그(팝업) 표시, 비동기적으로 결과 반환 (await로 결과 처리)
- ⭐️ ScaffoldMessenger: 스낵바 등 메시지 표시, 여러 화면에서 안전하게 사용 가능
- ⭐️ setState: 상태 변경 시 반드시 호출해야 UI가 갱신됨
- ⭐️ 상태 변수는 initState에서 초기화, 부모에서 전달받은 값은 직접 변경 시 주의
- ⭐️ pushReplacement, pushNamedAndRemoveUntil 등은 기존 화면 스택을 제어하므로, 뒤로가기 동작에 영향
- ⭐️ AlertDialog, SnackBar 등은 context가 올바른 위치(빌드 메서드 내)에서 사용되어야 함
- ⭐️ Row, Column 등 레이아웃 위젯은 UI 배치와 정렬에 필수, 중첩이 많아지면 성능/가독성에 주의
*/
