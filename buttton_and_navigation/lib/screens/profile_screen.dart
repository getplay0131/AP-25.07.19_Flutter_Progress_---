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
    return Column(
      children: [
        CircleAvatar(
          // child: Image.asset(profileImage, fit: BoxFit.cover),
          backgroundImage: AssetImage(profileImage),
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
    );
  }
}
