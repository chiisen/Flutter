import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';

/// 待辦事項提供者
/// 使用 Provider 模式進行狀態管理
class TodoProvider extends ChangeNotifier {
  final TodoService _todoService = TodoService();
  
  List<Todo> _todos = [];
  List<Todo> _filteredTodos = [];
  bool _isLoading = false;
  String _searchQuery = '';
  SortOption _sortOption = SortOption.createdAt;
  bool _ascending = false;
  FilterOption _filterOption = FilterOption.all;
  
  // 最後刪除的項目（用於撤銷）
  List<Todo> _lastDeletedTodos = [];

  /// 獲取所有待辦事項
  List<Todo> get todos => _filteredTodos;
  
  /// 獲取原始所有待辦事項
  List<Todo> get allTodos => _todos;

  /// 是否正在載入
  bool get isLoading => _isLoading;

  /// 搜尋關鍵字
  String get searchQuery => _searchQuery;

  /// 當前排序選項
  SortOption get sortOption => _sortOption;

  /// 是否遞增排序
  bool get ascending => _ascending;

  /// 當前篩選選項
  FilterOption get filterOption => _filterOption;

  /// 最後刪除的項目
  List<Todo> get lastDeletedTodos => _lastDeletedTodos;

  /// 統計資訊
  Map<String, int> get stats => _todoService.getStats();

  /// 初始化
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _todoService.init();
      _todos = _todoService.getAllTodos();
      _applyFiltersAndSort();
    } catch (e) {
      debugPrint('初始化失敗：$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 新增待辦事項
  Future<Todo> addTodo({
    required String title,
    String? description,
    int priority = 1,
    DateTime? dueDate,
    String? category,
  }) async {
    final todo = await _todoService.addTodo(
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      category: category,
    );
    _todos.add(todo);
    _applyFiltersAndSort();
    notifyListeners();
    return todo;
  }

  /// 更新待辦事項
  Future<void> updateTodo(Todo todo) async {
    await _todoService.updateTodo(todo);
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      _applyFiltersAndSort();
      notifyListeners();
    }
  }

  /// 切換完成狀態
  Future<void> toggleTodo(String id) async {
    await _todoService.toggleTodo(id);
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      final todo = _todos[index];
      _todos[index] = todo.copyWith(
        isCompleted: !todo.isCompleted,
        completedAt: !todo.isCompleted ? DateTime.now() : null,
      );
      _applyFiltersAndSort();
      notifyListeners();
    }
  }

  /// 刪除待辦事項（支援撤銷）
  Future<void> deleteTodo(String id, {bool enableUndo = true}) async {
    final todo = _todos.firstWhere((t) => t.id == id);
    _todos.removeWhere((t) => t.id == id);
    
    if (enableUndo) {
      _lastDeletedTodos = [todo];
    }
    
    await _todoService.deleteTodo(id);
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// 撤銷刪除
  Future<void> undoDelete() async {
    if (_lastDeletedTodos.isEmpty) return;
    
    for (final todo in _lastDeletedTodos) {
      _todos.add(todo);
      await _todoService.updateTodo(todo);
    }
    
    _lastDeletedTodos.clear();
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// 清除最後刪除的記錄
  void clearUndoStack() {
    _lastDeletedTodos.clear();
  }

  /// 批量刪除
  Future<void> deleteTodos(List<String> ids) async {
    final deletedTodos = _todos.where((t) => ids.contains(t.id)).toList();
    _todos.removeWhere((t) => ids.contains(t.id));
    
    _lastDeletedTodos = deletedTodos;
    
    await _todoService.deleteTodos(ids);
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// 清除已完成的
  Future<void> clearCompleted() async {
    final completedTodos = _todos.where((t) => t.isCompleted).toList();
    
    _todos.removeWhere((t) => t.isCompleted);
    _lastDeletedTodos = completedTodos;
    
    await _todoService.clearCompleted();
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// 設定搜尋關鍵字
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// 設定排序選項
  void setSortOption(SortOption option, {bool? ascending}) {
    _sortOption = option;
    if (ascending != null) {
      _ascending = ascending;
    }
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// 切換排序方向
  void toggleSortDirection() {
    _ascending = !_ascending;
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// 設定篩選選項
  void setFilterOption(FilterOption option) {
    _filterOption = option;
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// 套用篩選和排序
  void _applyFiltersAndSort() {
    // 1. 套用篩選
    _filteredTodos = _todos.where((todo) {
      // 搜尋篩選
      if (_searchQuery.isNotEmpty) {
        final lowerQuery = _searchQuery.toLowerCase();
        final titleMatch = todo.title.toLowerCase().contains(lowerQuery);
        final descMatch = todo.description?.toLowerCase().contains(lowerQuery) ?? false;
        final categoryMatch = todo.category?.toLowerCase().contains(lowerQuery) ?? false;
        if (!titleMatch && !descMatch && !categoryMatch) {
          return false;
        }
      }
      
      // 狀態篩選
      switch (_filterOption) {
        case FilterOption.all:
          return true;
        case FilterOption.active:
          return !todo.isCompleted;
        case FilterOption.completed:
          return todo.isCompleted;
        case FilterOption.overdue:
          return todo.isOverdue;
      }
    }).toList();
    
    // 2. 套用排序
    switch (_sortOption) {
      case SortOption.createdAt:
        _filteredTodos.sort((a, b) => 
          _ascending ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.dueDate:
        _filteredTodos.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return _ascending ? -1 : 1;
          if (b.dueDate == null) return _ascending ? 1 : -1;
          return _ascending ? a.dueDate!.compareTo(b.dueDate!) : b.dueDate!.compareTo(a.dueDate!);
        });
        break;
      case SortOption.priority:
        _filteredTodos.sort((a, b) => 
          _ascending ? a.priority.compareTo(b.priority) : b.priority.compareTo(a.priority));
        break;
      case SortOption.title:
        _filteredTodos.sort((a, b) => 
          _ascending ? a.title.compareTo(b.title) : b.title.compareTo(a.title));
        break;
      case SortOption.completed:
        _filteredTodos.sort((a, b) {
          // bool 沒有 compareTo，使用比較邏輯
          if (a.isCompleted == b.isCompleted) return 0;
          return _ascending ? (a.isCompleted ? 1 : -1) : (b.isCompleted ? 1 : -1);
        });
        break;
    }
  }

  /// 釋放資源
  @override
  void dispose() {
    _todoService.close();
    super.dispose();
  }
}

/// 篩選選項
enum FilterOption {
  all,        // 全部
  active,     // 進行中
  completed,  // 已完成
  overdue,    // 已過期
}
