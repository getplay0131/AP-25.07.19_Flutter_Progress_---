import 'package:flutter/material.dart';

class Todo {
  final String id;
  final String title;
  final String category;
  String priority;
  bool isCompleted;
  final DateTime createdAt;

  Todo({
    Key? key,
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    required this.isCompleted,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Todo를 복사해서 일부 속성만 변경할 때 사용
  Todo copyWith({
    String? id,
    String? title,
    String? category,
    String? priority,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // 디버깅을 위한 문자열 표현
  @override
  String toString() {
    return 'Todo{id: $id, title: $title, category: $category, priority: $priority, isCompleted: $isCompleted, createdAt: $createdAt}';
  }

  // 객체 비교를 위한 메서드
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Todo의 우선순위를 숫자로 반환 (정렬용)
  int get priorityWeight {
    switch (priority) {
      case "높음":
        return 3;
      case "중간":
        return 2;
      case "낮음":
        return 1;
      default:
        return 0;
    }
  }

  // Todo가 오늘 생성되었는지 확인
  bool get isCreatedToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  // Todo의 카테고리에 따른 색상 반환
  Color get categoryColor {
    switch (category) {
      case "아침":
        return const Color(0xFFFFB84D);
      case "오후":
        return const Color(0xFF6C63FF);
      case "저녁":
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF636E72);
    }
  }

  // Todo의 우선순위에 따른 색상 반환
  Color get priorityColor {
    switch (priority) {
      case "높음":
        return const Color(0xFFFF5757);
      case "중간":
        return const Color(0xFFFFB84D);
      case "낮음":
        return const Color(0xFF4ECDC4);
      default:
        return const Color(0xFF636E72);
    }
  }

  // Todo의 카테고리에 따른 아이콘 반환
  IconData get categoryIcon {
    switch (category) {
      case "아침":
        return Icons.wb_sunny_rounded;
      case "오후":
        return Icons.wb_sunny_outlined;
      case "저녁":
        return Icons.nights_stay_rounded;
      default:
        return Icons.schedule_rounded;
    }
  }

  // Todo의 우선순위에 따른 아이콘 반환
  IconData get priorityIcon {
    switch (priority) {
      case "높음":
        return Icons.keyboard_double_arrow_up_rounded;
      case "중간":
        return Icons.remove_rounded;
      case "낮음":
        return Icons.keyboard_double_arrow_down_rounded;
      default:
        return Icons.remove_rounded;
    }
  }
}
