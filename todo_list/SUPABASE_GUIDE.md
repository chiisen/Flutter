# Supabase 整合說明

## 📋 完成項目

✅ 已將 Todo List 從本地 Hive 儲存遷移至 Supabase 雲端資料庫
✅ 建立設定對話框，可於 App 內輸入 Supabase URL 和 Anon Key
✅ 使用 SharedPreferences 儲存設定，重開 App 不需重新輸入
✅ 完整 CRUD 功能（新增/讀取/更新/刪除）
✅ 支援搜尋、篩選、排序
✅ 重新整理按鈕，手動同步雲端資料

---

## 🚀 快速開始

### 1. 首次執行 App

```bash
cd todo_list
flutter run
```

首次啟動會自動跳出設定對話框，要求輸入：
- **Supabase URL**：`https://your-project-id.supabase.co`
- **Supabase Anon Key**：從 Dashboard → Settings → API 取得

### 2. 修改設定

在 App 主畫面右上角點擊 **⚙️ 設定按鈕** 即可修改 Supabase 連線資訊。

---

## 🗄️ 資料庫結構

資料表名稱：`todos`

| 欄位 | 類型 | 說明 |
|------|------|------|
| id | UUID | 主鍵（自動生成） |
| title | TEXT | 事項標題（必填） |
| description | TEXT | 詳細描述 |
| is_completed | BOOLEAN | 是否已完成 |
| priority | INTEGER | 優先級（0:低, 1:中, 2:高） |
| due_date | TIMESTAMPTZ | 截止日期 |
| category | TEXT | 分類標籤 |
| created_at | TIMESTAMPTZ | 建立時間 |
| completed_at | TIMESTAMPTZ | 完成時間 |

---

## 📁 專案結構

```
todo_list/lib/
├── main.dart                        # 應用程式入口（含 Supabase 初始化）
├── config/
│   └── supabase_config.dart         # 設定管理器（SharedPreferences）
├── services/
│   └── supabase_todo_service.dart   # Supabase CRUD 服務
├── providers/
│   └── todo_provider.dart           # Provider 狀態管理
├── models/
│   └── todo.dart                    # Todo 資料模型
├── pages/
│   └── todo_list_page.dart          # 主頁面（含設定按鈕）
└── widgets/
    ├── settings_dialog.dart         # Supabase 設定對話框
    ├── todo_tile.dart               # 列表項目元件
    ├── todo_form_dialog.dart        # 新增/編輯對話框
    └── empty_state.dart             # 空狀態元件
```

---

## 🔧 技術棧

| 類別 | 套件 | 版本 |
|------|------|------|
| 狀態管理 | provider | ^6.1.2 |
| 雲端資料庫 | supabase_flutter | ^2.12.2 |
| 設定儲存 | shared_preferences | ^2.5.5 |
| UUID 生成 | uuid | ^4.5.1 |

---

## ⚠️ 注意事項

1. **網路連線**：需要網路連線才能操作資料庫
2. **RLS 政策**：目前設定為允許所有操作（測試用），正式環境應加入認證機制
3. **錯誤處理**：所有 CRUD 操作均包含 try-catch 與日誌記錄

---

## 🐛 常見問題

### Q: 出現連線錯誤？
A: 檢查 Supabase URL 是否正確，確認專案存在且運作中

### Q: 資料無法寫入？
A: 確認 SQL 腳本已執行，`todos` 資料表已建立

### Q: 如何清除設定？
A: 在設定對話框中點擊「清除設定」按鈕

---

## 📝 更新日誌

### 2026-04-12
- ✅ 移除 Hive 本地儲存
- ✅ 整合 Supabase 雲端資料庫
- ✅ 新增設定對話框
- ✅ 完整 CRUD 功能
