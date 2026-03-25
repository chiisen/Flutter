import 'dart:io' show Platform;
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';

/// 待辦事項服務
/// 負責資料的持久化操作（CRUD）
class TodoService {
  static final TodoService _instance = TodoService._internal();
  factory TodoService() => _instance;
  TodoService._internal();

  Box<Todo>? _todoBox;
  final _uuid = const Uuid();
  bool _isInitialized = false;

  /// 初始化 Hive
  Future<void> init() async {
    if (_isInitialized) return;

    // Web 平台需要指定路徑（使用 localStorage）
    // 其他平台使用預設路徑
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TodoAdapter());
    }

    // 開啟 Box - Web 平台會自動使用 indexedDB
    _todoBox = await Hive.openBox<Todo>('todos');
    _isInitialized = true;
  }

  /// 確保已初始化
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  /// 獲取所有待辦事項
  List<Todo> getAllTodos() {
    if (_todoBox == null) return [];
    return _todoBox!.values.toList();
  }

  /// 獲取未完成的待辦事項
  List<Todo> getActiveTodos() {
    if (_todoBox == null) return [];
    return _todoBox!.values.where((todo) => !todo.isCompleted).toList();
  }

  /// 獲取已完成的待辦事項
  List<Todo> getCompletedTodos() {
    if (_todoBox == null) return [];
    return _todoBox!.values.where((todo) => todo.isCompleted).toList();
  }

  /// 根據 ID 獲取待辦事項
  Todo? getTodoById(String id) {
    if (_todoBox == null) return null;
    return _todoBox!.get(id);
  }

  /// 新增待辦事項
  Future<Todo> addTodo({
    required String title,
    String? description,
    int priority = 1,
    DateTime? dueDate,
    String? category,
  }) async {
    await _ensureInitialized();
    final todo = Todo(
      id: _uuid.v4(),
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      category: category,
    );
    await _todoBox!.put(todo.id, todo);
    return todo;
  }

  /// 更新待辦事項
  Future<void> updateTodo(Todo todo) async {
    await _ensureInitialized();
    await _todoBox!.put(todo.id, todo);
  }

  /// 切換完成狀態
  Future<void> toggleTodo(String id) async {
    await _ensureInitialized();
    final todo = _todoBox!.get(id);
    if (todo == null) return;

    final updatedTodo = todo.copyWith(
      isCompleted: !todo.isCompleted,
      completedAt: !todo.isCompleted ? DateTime.now() : null,
    );
    await _todoBox!.put(id, updatedTodo);
  }

  /// 刪除待辦事項
  Future<void> deleteTodo(String id) async {
    await _ensureInitialized();
    await _todoBox!.delete(id);
  }

  /// 批量刪除
  Future<void> deleteTodos(List<String> ids) async {
    await _ensureInitialized();
    await _todoBox!.deleteAll(ids);
  }

  /// 清除已完成的待辦事項
  Future<void> clearCompleted() async {
    await _ensureInitialized();
    final completedIds = getCompletedTodos().map((todo) => todo.id).toList();
    await deleteTodos(completedIds);
  }

  /// 搜尋待辦事項
  List<Todo> searchTodos(String query) {
    if (_todoBox == null) return [];
    if (query.trim().isEmpty) {
      return getAllTodos();
    }

    final lowerQuery = query.toLowerCase();
    return _todoBox!.values.where((todo) {
      final titleMatch = todo.title.toLowerCase().contains(lowerQuery);
      final descMatch = todo.description?.toLowerCase().contains(lowerQuery) ?? false;
      final categoryMatch = todo.category?.toLowerCase().contains(lowerQuery) ?? false;
      return titleMatch || descMatch || categoryMatch;
    }).toList();
  }

  /// 依條件排序
  List<Todo> sortTodos({
    required SortOption option,
    bool ascending = true,
  }) {
    var todos = getAllTodos();
    
    switch (option) {
      case SortOption.createdAt:
        todos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortOption.dueDate:
        todos.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case SortOption.priority:
        todos.sort((a, b) => b.priority.compareTo(a.priority));
        break;
      case SortOption.title:
        todos.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.completed:
        todos.sort((a, b) {
          // bool 沒有 compareTo，使用比較邏輯
          if (a.isCompleted == b.isCompleted) return 0;
          return a.isCompleted ? 1 : -1;
        });
        break;
    }
    
    if (!ascending) {
      todos = todos.reversed.toList();
    }
    
    return todos;
  }

  /// 獲取統計資訊
  Map<String, int> getStats() {
    final all = getAllTodos();
    final completed = getCompletedTodos();
    final active = getActiveTodos();
    final overdue = active.where((todo) => todo.isOverdue).length;
    
    return {
      'total': all.length,
      'completed': completed.length,
      'active': active.length,
      'overdue': overdue,
    };
  }

  /// 關閉資料庫
  Future<void> close() async {
    if (_todoBox != null) {
      await _todoBox!.close();
    }
  }
}

/// 排序選項
enum SortOption {
  createdAt,   // 依建立時間
  dueDate,     // 依截止日期
  priority,    // 依優先級
  title,       // 依標題
  completed,   // 依完成狀態
}
