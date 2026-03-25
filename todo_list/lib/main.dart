import 'package:flutter/material.dart';

/// 應用程式入口函式
void main() {
  runApp(const TodoApp());
}

/// 待辦事項應用程式主體
/// 繼承自 StatelessWidget，表示這是一個無狀態的 Widget
class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      // 設定應用程式的主題
      theme: ThemeData(
        // 使用藍色作為種子顏色生成配色方案
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        // 啟用 Material 3 設計規範
        useMaterial3: true,
      ),
      // 設定首頁為待辦事項列表頁面
      home: const TodoListPage(),
    );
  }
}

/// 待辦事項資料模型
/// 用來儲存單個待辦事項的資訊
class Todo {
  String id;          // 唯一識別碼
  String title;       // 事項標題
  bool isCompleted;   // 是否已完成

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,  // 預設為未完成狀態
  });
}

/// 待辦事項列表頁面
/// 繼承自 StatefulWidget，表示這是一個有狀態的 Widget
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

/// TodoListPage 的狀態類別
/// 管理頁面的所有動態內容和使用者互動
class _TodoListPageState extends State<TodoListPage> {
  // 儲存所有待辦事項的列表
  final List<Todo> _todos = [];
  
  // 文字輸入控制器，用於管理輸入框的內容
  final TextEditingController _controller = TextEditingController();

  /// 新增待辦事項
  /// 當使用者輸入內容並按下新增按鈕時呼叫此方法
  void _addTodo() {
    // 如果輸入為空則不新增
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _todos.add(Todo(
        // 使用時間戳作為唯一 ID
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _controller.text.trim(),
      ));
      // 清空輸入框
      _controller.clear();
    });
  }

  /// 切換待辦事項的完成狀態
  /// [id] 要切換狀態的事項 ID
  void _toggleTodo(String id) {
    setState(() {
      // 找到對應 ID 的事項並切換其完成狀態
      final todo = _todos.firstWhere((t) => t.id == id);
      todo.isCompleted = !todo.isCompleted;
    });
  }

  /// 刪除待辦事項
  /// [id] 要刪除的事項 ID
  void _deleteTodo(String id) {
    setState(() {
      // 從列表中移除對應 ID 的事項
      _todos.removeWhere((t) => t.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 應用程式列
      appBar: AppBar(
        title: const Text('To Do List'),
        // 使用主題色系的反轉主色作為背景色
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // 清除已完成按鈕
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: '清除已完成',
            onPressed: () {
              setState(() {
                // 移除所有已完成的事項
                _todos.removeWhere((t) => t.isCompleted);
              });
            },
          ),
        ],
      ),
      // 頁面主體
      body: Column(
        children: [
          // ===== 輸入區域 =====
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // 文字輸入框
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '新增待辦事項...',
                      border: OutlineInputBorder(),  // 邊框樣式
                      prefixIcon: Icon(Icons.add_circle_outline),  // 前綴圖示
                    ),
                    // 按下 Enter 鍵時新增事項
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 8),
                // 新增按鈕
                FloatingActionButton(
                  onPressed: _addTodo,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          // ===== 統計資訊 =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 顯示總事項數
                Text(
                  '共 ${_todos.length} 項',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                // 顯示已完成事項數
                Text(
                  '已完成 ${_todos.where((t) => t.isCompleted).length} 項',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),  // 分隔線
          // ===== 列表區域 =====
          Expanded(
            child: _todos.isEmpty
                // 空狀態顯示
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '尚無待辦事項',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                // 事項列表
                : ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final todo = _todos[index];
                      // 可滑動刪除的列表項目
                      return Dismissible(
                        key: Key(todo.id),  // 用於識別列表項目的唯一鍵
                        direction: DismissDirection.endToStart,  // 從右向左滑動刪除
                        // 滑動時顯示的背景
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        // 滑動刪除後的回呼
                        onDismissed: (_) => _deleteTodo(todo.id),
                        child: ListTile(
                          // 前導複選框
                          leading: Checkbox(
                            value: todo.isCompleted,
                            onChanged: (_) => _toggleTodo(todo.id),
                          ),
                          // 事項標題
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              // 已完成時顯示刪除線
                              decoration: todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              // 已完成時文字變灰色
                              color: todo.isCompleted ? Colors.grey : null,
                            ),
                          ),
                          // 尾隨刪除按鈕
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => _deleteTodo(todo.id),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// 釋放資源
  /// 當 Widget 被銷毀時呼叫，用於清理控制器避免記憶體洩漏
  @override
  void dispose() {
    _controller.dispose();  // 釋放文字控制器
    super.dispose();
  }
}
