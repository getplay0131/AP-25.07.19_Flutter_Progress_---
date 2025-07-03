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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          // 오버플로우 방지
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 헤더 섹션
              const Text(
                "안녕하세요! 👋",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF636E72),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "오늘도 화이팅!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),

              const SizedBox(height: 40),

              // 메인 버튼들
              _buildSimpleButton(
                title: "할일 목록",
                subtitle: "오늘의 할일을 확인해보세요",
                icon: Icons.checklist_rounded,
                color: const Color(0xFF6C63FF),
                onTap: () => moveTodoScreen(),
              ),

              const SizedBox(height: 16),

              _buildSimpleButton(
                title: "통계 보기",
                subtitle: "곧 출시될 예정입니다",
                icon: Icons.analytics_rounded,
                color: Colors.grey,
                onTap: null,
              ),

              const SizedBox(height: 16),

              _buildSimpleButton(
                title: "설정",
                subtitle: "앱 설정을 변경하세요",
                icon: Icons.settings_rounded,
                color: const Color(0xFF4ECDC4),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("설정 화면 준비 중입니다!"),
                      backgroundColor: Color(0xFF4ECDC4),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              _buildSimpleButton(
                title: "프로필",
                subtitle: "내 정보를 확인하세요",
                icon: Icons.person_rounded,
                color: const Color(0xFFFF6B9D),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("프로필 화면 준비 중입니다!"),
                      backgroundColor: Color(0xFFFF6B9D),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40), // 하단 여백
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // 아이콘
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 26),
              ),

              const SizedBox(width: 15),

              // 텍스트
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: onTap != null
                            ? const Color(0xFF2D3436)
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: onTap != null
                            ? const Color(0xFF636E72)
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // 화살표
              Icon(
                Icons.arrow_forward_ios,
                color: onTap != null ? const Color(0xFF636E72) : Colors.grey,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveTodoScreen() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const TodoListScreen()));
  }
}
