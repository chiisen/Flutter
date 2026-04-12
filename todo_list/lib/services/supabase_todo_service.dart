import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/todo.dart';

/// Supabase 待辦事項服務
/// 負責與 Supabase PostgreSQL 資料庫進行 CRUD 操作
class SupabaseTodoService {
  /// 確保 Supabase 已初始化
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  /// 取得 SupabaseClient（延遲存取）
  SupabaseClient get _supabase => Supabase.instance.client;

  /// 獲取所有待辦事項
  Future<List<Todo>> getAllTodos() async {
    try {
      final response = await _supabase
          .from('todos')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Todo.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('❌ 獲取待辦事項失敗：$e');
      rethrow;
    }
  }

  /// 獲取未完成的待辦事項
  Future<List<Todo>> getActiveTodos() async {
    try {
      final response = await _supabase
          .from('todos')
          .select()
          .eq('is_completed', false)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Todo.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('❌ 獲取未完成待辦事項失敗：$e');
      rethrow;
    }
  }

  /// 獲取已完成的待辦事項
  Future<List<Todo>> getCompletedTodos() async {
    try {
      final response = await _supabase
          .from('todos')
          .select()
          .eq('is_completed', true)
          .order('completed_at', ascending: false);

      return (response as List)
          .map((json) => Todo.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('❌ 獲取已完成待辦事項失敗：$e');
      rethrow;
    }
  }

  /// 根據 ID 獲取待辦事項
  Future<Todo?> getTodoById(String id) async {
    try {
      final response = await _supabase
          .from('todos')
          .select()
          .eq('id', id)
          .single();

      return Todo.fromJson(response);
    } catch (e) {
      debugPrint('❌ 獲取待辦事項 ($id) 失敗：$e');
      return null;
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
    try {
      // 不傳 id，讓資料庫自動生成 UUID
      final response = await _supabase
          .from('todos')
          .insert({
            'title': title,
            'description': description,
            'priority': priority,
            'due_date': dueDate?.toIso8601String(),
            'category': category,
            'is_completed': false,
          })
          .select()
          .single();

      return Todo.fromJson(response);
    } catch (e) {
      debugPrint('❌ 新增待辦事項失敗：$e');
      rethrow;
    }
  }

  /// 更新待辦事項
  Future<void> updateTodo(Todo todo) async {
    try {
      await _supabase
          .from('todos')
          .update(todo.toJson())
          .eq('id', todo.id);
    } catch (e) {
      debugPrint('❌ 更新待辦事項 (${todo.id}) 失敗：$e');
      rethrow;
    }
  }

  /// 切換完成狀態
  Future<void> toggleTodo(String id) async {
    try {
      final todo = await getTodoById(id);
      if (todo == null) return;

      final updatedTodo = todo.copyWith(
        isCompleted: !todo.isCompleted,
        completedAt: !todo.isCompleted ? DateTime.now() : null,
      );

      await updateTodo(updatedTodo);
    } catch (e) {
      debugPrint('❌ 切換完成狀態失敗：$e');
      rethrow;
    }
  }

  /// 刪除待辦事項
  Future<void> deleteTodo(String id) async {
    try {
      await _supabase.from('todos').delete().eq('id', id);
    } catch (e) {
      debugPrint('❌ 刪除待辦事項 ($id) 失敗：$e');
      rethrow;
    }
  }

  /// 批量刪除
  Future<void> deleteTodos(List<String> ids) async {
    try {
      await _supabase.from('todos').delete().inFilter('id', ids);
    } catch (e) {
      debugPrint('❌ 批量刪除待辦事項失敗：$e');
      rethrow;
    }
  }

  /// 清除已完成的待辦事項
  Future<void> clearCompleted() async {
    try {
      await _supabase.from('todos').delete().eq('is_completed', true);
    } catch (e) {
      debugPrint('❌ 清除已完成待辦事項失敗：$e');
      rethrow;
    }
  }

  /// 搜尋待辦事項
  Future<List<Todo>> searchTodos(String query) async {
    try {
      if (query.trim().isEmpty) {
        return getAllTodos();
      }

      final response = await _supabase
          .from('todos')
          .select()
          .or('title.ilike.%$query%,description.ilike.%$query%,category.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Todo.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('❌ 搜尋待辦事項失敗：$e');
      rethrow;
    }
  }

  /// 獲取統計資訊
  Future<Map<String, int>> getStats() async {
    try {
      final all = await getAllTodos();
      final completed = getCompletedTodos();
      final active = getActiveTodos();
      final overdue = (await active).where((todo) => todo.isOverdue).length;

      return {
        'total': all.length,
        'completed': (await completed).length,
        'active': (await active).length,
        'overdue': overdue,
      };
    } catch (e) {
      debugPrint('❌ 獲取統計資訊失敗：$e');
      return {
        'total': 0,
        'completed': 0,
        'active': 0,
        'overdue': 0,
      };
    }
  }
}
