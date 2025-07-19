import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  // ⭐️ ProfileScreen: 프로필 화면, 현재는 빈 화면
  // - StatelessWidget: 상태 변화가 없으므로 사용
  // - Key: 위젯의 고유 식별자, 위젯 트리에서 상태를 유지하는 데 사용
  // - 생성자에서 Key를 받음 (필요시 위젯 트리에서 식별 가능)

  final String profileId; // 프로필 ID (예시로 사용)
  final String profileName; // 프로필 이름 (예시로 사용)
  final String profileImage; // 프로필 이미지 URL (예시로 사용)
  final String profileBio; // 프로필 소개 (예시로 사용)
  final String profileEmail; // 프로필 이메일 (예시로 사용)
  final String profilePhone; // 프로필 전화번호 (예시로 사용)
  final int profileAge; // 프로필 나이 (예시로 사용)

  const ProfileScreen({
    Key? key,
    required this.profileId,
    required this.profileName,
    required this.profileImage,
    required this.profileBio,
    required this.profileEmail,
    required this.profilePhone,
    required this.profileAge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ⭐️ AppBar: 상단 바, 뒤로가기 버튼과 타이틀 포함
        leading: IconButton(
          onPressed: () {
            // ⭐️ Navigator.pop: 현재 화면을 스택에서 제거(이전 화면으로 이동)
            // - context: 현재 위젯의 위치 정보, Navigator에서 필수
            print("📋 뒤로가기 버튼 클릭");
            print("pop 전: 프로필 화면");
            Navigator.pop(context);
            print("pop 후: 대시보드로 돌아감");
          },
          icon: Icon(Icons.backspace_outlined),
        ),
        title: Text(
          "뒤로가기!!",
          style: TextStyle(color: Colors.black12, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Expanded(
          child: Column(
            children: [
              Container(
                // ⭐️ Container: 위젯을 감싸는 박스, 배경색, 크기 등 설정 가능
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.max, // 자식 위젯의 크기에 맞춤
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      // ⭐️ CircleAvatar: 원형 프로필 이미지 위젯
                      // child: Image.asset(profileImage, fit: BoxFit.cover),
                      backgroundImage: AssetImage(
                        profileImage,
                      ), // 사진이 자연스레 서클을 채운다.
                      backgroundColor: Colors.grey[300],
                      radius: 50,
                    ), // 프로필 이미지
                    SizedBox(height: 20),
                    Card(
                      child: Column(
                        children: [
                          Text("ID: $profileId"),
                          Text("이름: $profileName"),
                          Text("소개: $profileBio"),
                          Text("이메일: $profileEmail"),
                          Text("전화번호: $profilePhone"),
                          Text("나이: $profileAge"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.canPop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("프로필 수정 기능은 아직 구현되지 않았습니다.")),
                  );
                },
                child: Icon(Icons.edit),
                autofocus: true,
                onHover: (value) => print("프로필 수정 버튼에 마우스 오버: $value"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 5,
                  padding: EdgeInsets.all(16),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).maybePop();
                  print("프로필 화면에서 maybePop 호출");
                },
                child: Text("maybePop"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
