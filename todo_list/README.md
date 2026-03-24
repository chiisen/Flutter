# To Do List - Flutter 應用

一個簡單的待辦事項管理應用程式，使用 Flutter 開發。

## 功能特色

- ✅ 新增待辦事項
- ✅ 標記完成/未完成
- ✅ 滑動刪除
- ✅ 一鍵清除已完成
- ✅ 統計顯示（總數/已完成）

## 專案結構

```
todo_list/
├── lib/
│   └── main.dart          # 主程式（To Do List 應用）
├── pubspec.yaml           # 專案設定
└── ...
```

## 執行方式

```bash
cd todo_list
flutter run
```

## 編譯 APK

```bash
cd todo_list
flutter build apk
```

### APK 檔案位置

編譯完成後，APK 檔案位於：

```
build/app/outputs/flutter-apk/
├── app-debug.apk          # 開發測試用 (約 145 MB)
└── app-release.apk        # 發布用 (約 47 MB)
```

**完整路徑：**
```
D:\github\chiisen\Flutter\todo_list\build\app\outputs\flutter-apk\
```

## 安裝 APK

將 APK 檔案傳輸到 Android 裝置並安裝：

```bash
# 透過 ADB 安裝
adb install build/app/outputs/flutter-apk/app-release.apk
```

## 開發環境

- Flutter 3.41.5 (stable)
- Dart 3.11.3
- 支援平台：Android, iOS, Web, Windows, macOS, Linux

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
