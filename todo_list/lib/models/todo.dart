import 'package:hive/hive.dart';

part 'todo.g.dart';

/// 優先級列舉
enum Priority {
  low,    // 低
  medium, // 中
  high,   // 高
}

/// 待辦事項資料模型
@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String id;          // 唯一識別碼

  @HiveField(1)
  String title;       // 事項標題

  @HiveField(2)
  bool isCompleted;   // 是否已完成

  @HiveField(3)
  String? description;  // 詳細描述（可選）

  @HiveField(4)
  int priority;       // 優先級 (0: low, 1: medium, 2: high)

  @HiveField(5)
  DateTime? dueDate;  // 截止日期（可選）

  @HiveField(6)
  String? category;   // 分類（可選）

  @HiveField(7)
  DateTime createdAt; // 建立時間

  @HiveField(8)
  DateTime? completedAt; // 完成時間

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.description,
    this.priority = 1,  // 預設為中
    this.dueDate,
    this.category,
    DateTime? createdAt,
    this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// 獲取優先級列舉
  Priority get priorityLevel => Priority.values[priority];

  /// 是否已過期
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  /// 是否即將到期（24 小時內）
  bool get isDueSoon {
    if (dueDate == null || isCompleted) return false;
    final now = DateTime.now();
    final difference = dueDate!.difference(now);
    return difference.inDays <= 1 && difference.inDays >= 0;
  }

  /// 複製並修改
  Todo copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    String? description,
    int? priority,
    DateTime? dueDate,
    String? category,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// 轉換為 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'description': description,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  /// 從 JSON 建立
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
      description: json['description'] as String?,
      priority: json['priority'] as int,
      dueDate: json['dueDate'] != null 
          ? DateTime.parse(json['dueDate'] as String) 
          : null,
      category: json['category'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String) 
          : null,
    );
  }

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, isCompleted: $isCompleted, priority: ${priorityLevel.name})';
  }
}
