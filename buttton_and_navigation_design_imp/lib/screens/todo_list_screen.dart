import 'package:buttton_and_navigation/screens/dash_board_screen.dart';
import 'package:flutter/material.dart';
import 'package:buttton_and_navigation/models/todo.dart';
import 'dart:async';
import 'package:buttton_and_navigation/screens/add_todo_screen.dart';
import 'package:buttton_and_navigation/models/TodoManager.dart'; // 이 줄 추가하세요

// 임시로 여기에 TodoManager 정의 (나중에 별도 파일로 분리)

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen>
    with TickerProviderStateMixin {
  final TodoManager _todoManager = TodoManager();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF2D3436),
            ),
          ),
        ),
        title: Text(
          "나의 할일",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () async {
            final pushed = await Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    AddTodoScreen(category: "오후", priority: "중간"),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: const Offset(0, 1),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOutCubic,
                              ),
                            ),
                        child: child,
                      );
                    },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
            if (pushed != null) {
              setState(() {
                _todoManager.addTodo(pushed);
              });
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          label: const Text(
            "할일 추가",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          icon: const Icon(Icons.add_rounded, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // 상태 표시 카드
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6C63FF).withOpacity(0.1),
                  const Color(0xFFFF6B9D).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF6C63FF).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.task_alt_rounded,
                    color: Color(0xFF6C63FF),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "전체 할일",
                        style: TextStyle(
                          color: const Color(0xFF636E72),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${_todoManager.totalCount}개",
                        style: const TextStyle(
                          color: Color(0xFF2D3436),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECDC4).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "완료: ${_todoManager.completedCount}개",
                    style: const TextStyle(
                      color: Color(0xFF4ECDC4),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 할일 리스트
          Expanded(
            child: _todoManager.todos.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _todoManager.todos.length,
                    itemBuilder: (BuildContext context, int index) {
                      Todo todo = _todoManager.todos[index];
                      return TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 400 + (index * 100)),
                        tween: Tween(begin: 0.0, end: 1.0),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 50 * (1 - value)),
                            child: Opacity(opacity: value, child: child),
                          );
                        },
                        child: _buildTodoCard(todo, index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.assignment_turned_in_rounded,
              size: 64,
              color: Color(0xFF6C63FF),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "아직 할일이 없어요!",
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "새로운 할일을 추가해보세요",
            style: TextStyle(color: const Color(0xFF636E72), fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoCard(Todo todo, int index) {
    Color priorityColor = _getPriorityColor(todo.priority);
    IconData categoryIcon = _getCategoryIcon(todo.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: priorityColor, width: 4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더 영역
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(categoryIcon, color: priorityColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: todo.isCompleted
                              ? const Color(0xFF636E72)
                              : const Color(0xFF2D3436),
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                    CompletedToggle(
                      isCompleted: todo.isCompleted,
                      onToggle: () {
                        setState(() {
                          _todoManager.toggleComplete(todo.id);
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 정보 영역
                Row(
                  children: [
                    _buildInfoChip(
                      label: todo.category,
                      color: _getCategoryColor(todo.category),
                      icon: categoryIcon,
                    ),
                    const SizedBox(width: 12),
                    _buildInfoChip(
                      label: todo.priority,
                      color: priorityColor,
                      icon: _getPriorityIcon(todo.priority),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 우선순위 변경 버튼들
                PriorityButtons(
                  priority: todo.priority,
                  onPress: (changePriority) {
                    setState(() {
                      _todoManager.updatePriority(todo.id, changePriority);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
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

  Color _getCategoryColor(String category) {
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

  IconData _getCategoryIcon(String category) {
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

  IconData _getPriorityIcon(String priority) {
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

class CompletedToggle extends StatefulWidget {
  final bool isCompleted;
  final VoidCallback onToggle;

  CompletedToggle({Key? key, required this.isCompleted, required this.onToggle})
    : super(key: key);

  @override
  State<CompletedToggle> createState() => _CompletedToggleState();
}

class _CompletedToggleState extends State<CompletedToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        widget.onToggle();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: widget.isCompleted
                ? const Color(0xFF4ECDC4)
                : Colors.transparent,
            border: Border.all(
              color: widget.isCompleted
                  ? const Color(0xFF4ECDC4)
                  : const Color(0xFFDDD),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: widget.isCompleted
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
              : null,
        ),
      ),
    );
  }
}

class PriorityButtons extends StatefulWidget {
  String priority;
  final Function(String) onPress;

  PriorityButtons({super.key, required this.priority, required this.onPress});

  @override
  State<PriorityButtons> createState() => _PriorityButtonsState();
}

class _PriorityButtonsState extends State<PriorityButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildPriorityButton("높음", const Color(0xFFFF5757)),
        const SizedBox(width: 8),
        _buildPriorityButton("중간", const Color(0xFFFFB84D)),
        const SizedBox(width: 8),
        _buildPriorityButton("낮음", const Color(0xFF4ECDC4)),
      ],
    );
  }

  Widget _buildPriorityButton(String priority, Color color) {
    bool isSelected = widget.priority == priority;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.onPress(priority);
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(isSelected ? 1.0 : 0.3),
              width: 1,
            ),
          ),
          child: Text(
            priority,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
