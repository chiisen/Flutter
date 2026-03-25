# To Do List - Flutter 應用

一個功能完整的待辦事項管理應用程式，使用 Flutter 開發。

## ✨ 功能特色

### 基本功能
- ✅ 新增/編輯/刪除待辦事項
- ✅ 標記完成/未完成
- ✅ 滑動刪除（含確認對話框）
- ✅ 一鍵清除已完成
- ✅ 統計顯示（總數/進行中/已完成/已過期）

### 進階功能
- 🔔 **優先級設定** - 高/中/低優先級，顏色標示
- 📅 **截止日期** - 設定到期日，自動標示已過期/即將到期
- 🏷️ **分類標籤** - 為事項分類管理
- 📝 **詳細描述** - 為事項添加說明
- 🔍 **搜尋功能** - 快速找到待辦事項
- 🎯 **篩選功能** - 全部/進行中/已完成/已過期
- 🔄 **排序功能** - 依時間/優先級/標題排序
- ↩️ **撤銷刪除** - 刪除後可立即復原
- 🌙 **深色模式** - 跟隨系統主題自動切換
- 💾 **資料持久化** - 使用 Hive 本機儲存，關閉 App 不遺失

## 📁 專案結構

```
todo_list/
├── lib/
│   ├── main.dart                  # 應用程式入口
│   ├── i18n.dart                  # 國際化設定
│   ├── models/
│   │   └── todo.dart              # Todo 資料模型（含 Hive 註解）
│   ├── services/
│   │   └── todo_service.dart      # 資料持久化服務層
│   ├── providers/
│   │   └── todo_provider.dart     # Provider 狀態管理
│   ├── pages/
│   │   └── todo_list_page.dart    # 主頁面 UI
│   └── widgets/
│       ├── todo_tile.dart         # 列表項目元件
│       ├── todo_form_dialog.dart  # 新增/編輯對話框
│       └── empty_state.dart       # 空狀態元件
├── test/
│   ├── models/
│   │   └── todo_test.dart         # 模型單元測試
│   └── widgets/
│       └── empty_state_test.dart  # 元件測試
├── pubspec.yaml                   # 專案設定
└── ...
```

## 🚀 快速開始

### 安裝依賴
```bash
cd todo_list
flutter pub get

# 生成 Hive adapter（如需修改模型）
dart run build_runner build --delete-conflicting-outputs
```

### 執行應用
```bash
flutter run
```

### 編譯 APK
```bash
flutter build apk
```

### APK 檔案位置
```
build/app/outputs/flutter-apk/
├── app-debug.apk          # 開發測試用 (約 145 MB)
└── app-release.apk        # 發布用 (約 47 MB)
```

**完整路徑：**
```
D:\github\chiisen\Flutter\todo_list\build\app\outputs\flutter-apk\
```

### 安裝 APK
```bash
# 透過 ADB 安裝
adb install build/app/outputs/flutter-apk/app-release.apk
```

## 📦 使用的套件

| 套件 | 用途 |
|------|------|
| `provider` | 狀態管理 |
| `hive` / `hive_flutter` | 本機資料持久化 |
| `path_provider` | 取得儲存路徑 |
| `uuid` | 生成唯一 ID |
| `intl` | 日期格式化 |
| `flutter_localizations` | 國際化支援 |

### 開發依賴
| 套件 | 用途 |
|------|------|
| `hive_generator` | 生成 Hive adapter |
| `build_runner` | 程式碼生成工具 |
| `flutter_launcher_icons` | 產生 App Icon |
| `flutter_test` | 單元測試框架 |

## 🧪 執行測試

```bash
# 執行所有測試
flutter test

# 執行特定測試檔案
flutter test test/models/todo_test.dart
flutter test test/widgets/empty_state_test.dart
```

## 🎨 開發環境

- **Flutter:** 3.41.5 (stable)
- **Dart:** 3.11.3
- **支援平台：** Android, iOS, Web, Windows, macOS, Linux

## 📝 開發筆記

### 修改 Todo 模型後
如果修改了 `lib/models/todo.dart` 中的模型結構，需要重新生成 Hive adapter：

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 資料模型欄位
- `id` - 唯一識別碼（UUID）
- `title` - 事項標題（必填）
- `description` - 詳細描述（選填）
- `isCompleted` - 是否已完成
- `priority` - 優先級（0: 低，1: 中，2: 高）
- `dueDate` - 截止日期（選填）
- `category` - 分類（選填）
- `createdAt` - 建立時間（自動）
- `completedAt` - 完成時間（自動）

## 📚 學習資源

- [Flutter 官方文件](https://docs.flutter.dev/)
- [Provider 套件文件](https://pub.dev/packages/provider)
- [Hive 資料庫文件](https://docs.hivedb.dev/)
- [Material Design 3](https://m3.material.io/)

## 📄 License

MIT License
