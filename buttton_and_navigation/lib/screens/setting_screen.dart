import 'package:flutter/material.dart';
import 'package:buttton_and_navigation/screens/dash_board_screen.dart';

class SettingScreen extends StatefulWidget {
  bool isModeChange;

  SettingScreen({Key? key, required this.isModeChange}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late bool isDarkMode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isDarkMode = widget.isModeChange;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        bool? check = await showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            title: Text("뒤로가기"),
            content: Text("뒤로가기를 누르면 설정이 초기화 됩니다. 계속하시겠습니까?"),
            actions: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // 취소시 false 반환
                },
                child: Text("취소"),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // 확인시 true 반환
                },
                child: Text("확인"),
              ),
            ],
          );
        });
        if (check != null && check) {
          Navigator.of(context).pop();
        }
      } ,
      child: Scaffold(
        appBar: AppBar(
          title: Text("설정"),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                // 클릭시
                print("클릭!");
                setState(() {
                  isDarkMode = !isDarkMode; // 다크모드 반전
                  widget.isModeChange = isDarkMode; // 부모 위젯의 값에 값 반영
                });
                if (isDarkMode == true) {
                  print("다크모드"); // 디버깅용 프린트문
                } else {
                  print("라이트모드"); // 디버깅용 프린트문
                }
                // 스캐폴드메신저 : 스낵바나 배너등의 메시지를 관리하는 위젯
                // 스캐폴드가 제거되어도 스낵바가 안전하게 표시되며, 여러 페이지에서 동일한 스낵바 관리 가능하다. 또한 스낵바를 더 세밀하게 제어 가능하다.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isDarkMode ? "다크모드로 변경!" : "라이트모드로 변경!",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ), // 스낵바에 표시할 메인 내용
                    duration: Duration(seconds: 2), // 스낵바가 화면에 머무는 시간
                    action: SnackBarAction(
                      label: "취소",
                      onPressed: () {
                        setState(() {
                          isDarkMode = !isDarkMode;
                          widget.isModeChange = isDarkMode;
                          print("취소 버튼 클릭!");
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("모드 변경이 취소 되었습니다.!"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ), // 스낵바에 표시할 버튼
                    behavior: SnackBarBehavior.floating, // 스낵바 표시 방식 결정
                    backgroundColor: isDarkMode
                        ? Colors.grey[800]
                        : Colors.grey[200],
                  ),
                );
              },
              label: Text("버튼"),
              icon: isDarkMode
                  ? Icon(Icons.dark_mode)
                  : Icon(
                      Icons.light_mode,
                    ), // 다크모드가 트루면. 다크모드 아이콘 표시, 아니면 라이프 모드 아이콘 표시
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.red : Colors.blue,
                    foregroundColor: Colors.grey,
                  ),
                  // 1. ElevatedButton의 onPressed에서 showDialog를 호출한다.
                  // 2. showDialog의 builder에서 AlertDialog 위젯을 반환한다.
                  // 3. AlertDialog에 제목, 내용, 확인/취소 버튼을 추가한다.
                  // 4. 확인 버튼을 누르면 원하는 동작(예: 데이터 초기화)을 수행한다.
                  // 5. 취소 버튼을 누르면 다이얼로그를 닫는다.
                  onPressed: () {
                    print("버튼 클릭!");
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
                                    Navigator.of(context).pop();
                                    print("취소 버튼 클릭");
                                  },
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                    // 2. 모든 화면 제거하고 대시보드로 이동
                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                      "/DashBoardScreen", // 이동할 화면 이름
                                      (route) => false, // 모든 화면 제거
                                    );
                                    print("화면 초기화 완료");
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
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return DashBoardScreen();
                    },
                  ),
                );
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

main() {
  runApp(MaterialApp(home: SettingScreen(isModeChange: false)));
}
