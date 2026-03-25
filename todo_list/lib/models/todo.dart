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
