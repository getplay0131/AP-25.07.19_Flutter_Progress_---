import 'package:buttton_and_navigation/screens/todo_list_screen.dart';
import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("플러터 앱!")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    moveTodoScreen();
                    print("할일 목록 버튼 클릭됨!");
                  },
                  child: Text(
                    "할일 목록 버튼!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 300,
                child: ElevatedButton(
                  onPressed: null,
                  child: Text(
                    "통계 보기 버튼!",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.black12,
                    disabledForegroundColor: Colors.amber,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 300,
                child: OutlinedButton(
                  onPressed: () {
                    print("설정 버튼 클릭됨!");
                  },
                  child: Text("설정"),
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 300,
                child: TextButton(
                  onPressed: () {
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

  void moveTodoScreen()  {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return TodoListScreen();
        },
      ),
    );

  }
}
