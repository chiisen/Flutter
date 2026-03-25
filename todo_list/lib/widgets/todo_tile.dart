import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

/// 待辦事項列表項目元件
class TodoTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 優先級顏色
    Color priorityColor;
    IconData priorityIcon;
    switch (todo.priorityLevel) {
      case Priority.high:
        priorityColor = Colors.red;
        priorityIcon = Icons.arrow_upward;
        break;
      case Priority.medium:
        priorityColor = Colors.orange;
        priorityIcon = Icons.remove;
        break;
      case Priority.low:
        priorityColor = Colors.green;
        priorityIcon = Icons.arrow_downward;
        break;
    }

    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        return await _showConfirmDialog(context);
      },
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: (_) => onToggle(),
            activeColor: Colors.green,
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              color: todo.isCompleted 
                  ? theme.colorScheme.onSurface.withOpacity(0.5)
                  : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 描述
              if (todo.description?.isNotEmpty ?? false) ...[
                const SizedBox(height: 4),
                Text(
                  todo.description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              // 元數據（優先級、截止日期、分類）
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  // 優先級
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        priorityIcon,
                        size: 14,
                        color: priorityColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        _getPriorityText(todo.priorityLevel),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: priorityColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  // 截止日期
                  if (todo.dueDate != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: todo.isOverdue 
                              ? Colors.red 
                              : todo.isDueSoon 
                                  ? Colors.orange 
                                  : theme.iconTheme.color?.withOpacity(0.7),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          DateFormat('yyyy/MM/dd').format(todo.dueDate!),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: todo.isOverdue 
                                ? Colors.red 
                                : todo.isDueSoon 
                                    ? Colors.orange 
                                    : theme.colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  // 分類
                  if (todo.category?.isNotEmpty ?? false)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark 
                            ? Colors.blueGrey.shade800 
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        todo.category!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.blue.shade200 : Colors.blue.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          trailing: onEdit != null
              ? IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                )
              : null,
          isThreeLine: true,
        ),
      ),
    );
  }

  String _getPriorityText(Priority priority) {
    switch (priority) {
      case Priority.high:
        return '高';
      case Priority.medium:
        return '中';
      case Priority.low:
        return '低';
    }
  }

  Future<bool> _showConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('確認刪除'),
            content: Text('確定要刪除「${todo.title}」嗎？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('刪除', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }
}
