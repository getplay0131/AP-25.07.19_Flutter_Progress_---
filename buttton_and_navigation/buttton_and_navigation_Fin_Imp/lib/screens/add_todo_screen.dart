import 'package:buttton_and_navigation/models/todo.dart';
import 'package:buttton_and_navigation/screens/todo_list_screen.dart';
import 'package:flutter/material.dart';

class AddTodoScreen extends StatefulWidget {
  String category;
  String priority;

  AddTodoScreen({Key? key, required this.category, required this.priority})
    : super(key: key);

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  static String todoId = "todoId";
  static int todoIndex = 0;
  static bool isLoading = false;

  String get title => _titleController.text;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String mode = arguments?['mode'] ?? 'view';
    final Map<String, dynamic> profileData =
        arguments?['profileData'] ??
        {"id": "defaultId", "name": "defaultName", "email": "defaultEmail"};

    debugAddTodoScreenState(
      mode: mode,
      profileData: profileData,
      category: widget.category,
      priority: widget.priority,
      title: title,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(mode == "edit" ? "할일 수정" : "할일 추가"),
        actions: [
          appBarLoadingOrSave(
            isLoading: isLoading,
            onSave: saveToDoWithLoading,
            formKey: _formKey,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0eafc), Color(0xFFcfdef3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 입력 필드 카드
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          controller: _titleController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              print('❗️ [디버깅] 입력값 없음');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please enter some text'),
                                ),
                              );
                              return 'Please enter some text';
                            }
                            if (value.trim().isEmpty) {
                              print('❗️ [디버깅] 공백만 입력됨');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('공백은 입력할 수 없습니다!')),
                              );
                              return '공백은 입력할 수 없습니다!';
                            }
                            if (value.length > 20) {
                              print('❗️ [디버깅] 20자 초과 입력됨');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('20자 이하로 입력해주세요!')),
                              );
                              return '20자 이하로 입력해주세요!';
                            }
                            if (value.trim().length < 2) {
                              print('❗️ [디버깅] 2자 미만 입력됨');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('2자 이상 입력해주세요!')),
                              );
                              return '2자 이상 입력해주세요!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "할일을 입력해주세요!",
                            labelText: "제목",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            filled: true,
                            fillColor: isLoading
                                ? Colors.grey[200]
                                : Colors.white,
                            prefixIcon: Icon(
                              Icons.edit_note,
                              color: Colors.blueAccent,
                            ),
                          ),
                          enabled: !isLoading,
                          autofocus: true,
                        ),
                      ),
                    ),
                    // 카테고리 선택 카드
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Opacity(
                          opacity: isLoading ? 0.5 : 1.0,
                          child: choiceCategory(
                            category: widget.category,
                            onPress: (changeCategory) {
                              setState(() {
                                widget.category = changeCategory;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    // 우선순위 선택 카드
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Opacity(
                          opacity: isLoading ? 0.5 : 1.0,
                          child: priorityBtns(
                            priority: widget.priority,
                            onPress: (changePriority) {
                              setState(() {
                                widget.priority = changePriority;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveToDo(GlobalKey<FormState> key) {
    debugAddTodoScreenState(
      mode: "save",
      profileData: {},
      category: widget.category,
      priority: widget.priority,
      title: title,
    );

    if (key.currentState?.validate() == true) {
      if (widget.category.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("카테고리를 선택해주세요!"),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      if (widget.priority.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("우선순위 선택해주세요!"),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      var todo = Todo(
        id: createToDoId(todoId, todoIndex),
        title: title,
        category: widget.category,
        priority: widget.priority,
        isCompleted: false,
      );

      Navigator.of(context).pop(todo);
    }
  }

  Future<void> saveToDoWithLoading(GlobalKey<FormState> key) async {
    debugAddTodoScreenState(
      mode: "save",
      profileData: {},
      category: widget.category,
      priority: widget.priority,
      title: title,
    );

    setState(() {
      isLoading = true;
    });

    if (key.currentState?.validate() == true) {
      if (widget.category.isEmpty) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("카테고리를 선택해주세요!"),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      if (widget.priority.isEmpty) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("우선순위 선택해주세요!"),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      try {
        await Future.delayed(Duration(seconds: 2));

        var todo = Todo(
          id: createToDoId(todoId, todoIndex),
          title: title,
          category: widget.category,
          priority: widget.priority,
          isCompleted: false,
        );

        setState(() {
          isLoading = false;
        });

        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(todo);
        } else {
          print("이전 화면이 존재하지 않습니다.");
          throw Exception("Navigator cannot pop");
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("저장 중 문제가 발생했습니다. 다시 시도해 주세요!"),
            backgroundColor: Colors.red,
          ),
        );
        print("🚨 [오류] 할 일 저장 중 오류 발생: ${e.toString()}");
      }
    } else {
      setState(() {
        isLoading = false;
      });
      return;
    }
  }

  String createToDoId(String id, int idx) {
    todoIndex++;
    return id + idx.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }
}

Widget appBarLoadingOrSave({
  required bool isLoading,
  required void Function(GlobalKey<FormState>) onSave,
  required GlobalKey<FormState> formKey,
}) {
  if (isLoading) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  } else {
    return IconButton(
      onPressed: () => onSave(formKey),
      icon: Icon(Icons.save, color: Colors.blueAccent),
      tooltip: "저장",
    );
  }
}

class choiceCategory extends StatefulWidget {
  String category;
  final Function(String) onPress;

  choiceCategory({Key? key, required this.category, required this.onPress})
    : super(key: key);

  @override
  State<choiceCategory> createState() => _choiceCategoryState();
}

class _choiceCategoryState extends State<choiceCategory> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCategoryButton("아침", Icons.bed, Colors.yellow),
        _buildCategoryButton("오후", Icons.sunny, Colors.deepOrange),
        _buildCategoryButton("저녁", Icons.nightlight, Colors.indigo),
      ],
    );
  }

  Widget _buildCategoryButton(String label, IconData icon, Color color) {
    final bool isSelected = widget.category == label;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: CircleBorder(),
        backgroundColor: isSelected
            ? color.withOpacity(0.8)
            : color.withOpacity(0.3),
        side: BorderSide(
          color: isSelected ? Colors.blueAccent : Colors.transparent,
          width: 2,
        ),
        padding: EdgeInsets.all(0),
      ),
      onPressed: () {
        setState(() {
          widget.onPress(label);
        });
      },
      child: SizedBox(
        width: 64,
        height: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.black : Colors.grey[700]),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class priorityBtns extends StatefulWidget {
  String priority;
  final Function(String) onPress;

  priorityBtns({super.key, required this.priority, required this.onPress});

  @override
  State<priorityBtns> createState() => _priorityBtnsState();
}

class _priorityBtnsState extends State<priorityBtns> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildPriorityButton("높음", Colors.redAccent, Icons.priority_high),
        _buildPriorityButton("중간", Colors.amber, Icons.trending_up),
        _buildPriorityButton("낮음", Colors.green, Icons.low_priority),
      ],
    );
  }

  Widget _buildPriorityButton(String label, Color color, IconData icon) {
    final bool isSelected = widget.priority == label;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? color : color.withOpacity(0.3),
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: isSelected ? 6 : 1,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      onPressed: () {
        setState(() {
          widget.onPress(label);
        });
      },
      icon: Icon(icon, size: 20),
      label: Text("우선순위 $label"),
    );
  }
}

void debugAddTodoScreenState({
  required String mode,
  required Map<String, dynamic> profileData,
  required String category,
  required String priority,
  required String title,
}) {
  print("🔍 [디버깅] AddTodoScreen 상태 확인");
  print("  - mode: $mode");
  print("  - profileData: $profileData");
  print("  - category: $category");
  print("  - priority: $priority");
  print("  - title: $title");
  print("  - profileData 타입: ${profileData.runtimeType}");
  if (profileData.isNotEmpty) {
    profileData.forEach((k, v) {
      print("    - $k: $v (${v.runtimeType})");
    });
  }
}

void main() {
  runApp(
    MaterialApp(
      home: AddTodoScreen(category: "", priority: "높음"),
      debugShowCheckedModeBanner: false,
    ),
  );
}
