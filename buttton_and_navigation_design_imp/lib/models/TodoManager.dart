// lib/managers/todo_manager.dart
import 'package:buttton_and_navigation/models/todo.dart';

class TodoManager {
  // 싱글톤 패턴으로 전역에서 하나의 인스턴스만 사용
  static final TodoManager _instance = TodoManager._internal();
  factory TodoManager() => _instance;
  TodoManager._internal();

  // 전역 할일 리스트
  List<Todo> _todos = [];

  // 할일 목록 가져오기
  List<Todo> get todos => List.unmodifiable(_todos);

  // 할일 추가
  void addTodo(Todo todo) {
    _todos.add(todo);
  }

  // 할일 삭제
  void removeTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
  }

  // 할일 완료 상태 변경
  void toggleComplete(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    }
  }

  // 할일 우선순위 변경
  void updatePriority(String id, String priority) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].priority = priority;
    }
  }

  // 완료된 할일 개수
  int get completedCount => _todos.where((todo) => todo.isCompleted).length;

  // 전체 할일 개수
  int get totalCount => _todos.length;

  // 카테고리별 할일 개수
  int getCategoryCount(String category) {
    return _todos.where((todo) => todo.category == category).length;
  }
}
