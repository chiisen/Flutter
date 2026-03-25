import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'i18n.dart';
import 'pages/todo_list_page.dart';

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
      // 設定國際化支援
      localizationsDelegates: [
        const AppLocalizationsDelegate(AppLocale.zhTW), // 使用自訂的翻譯代理
        ...GlobalMaterialLocalizations.delegates,       // Flutter Material 國際化（包含 Cupertino）
      ],
      // 設定支援的語言環境
      supportedLocales: const [
        Locale('zh', 'TW'), // 繁體中文
        Locale('en', 'US'), // 英文
      ],
      // 設定區域設定（強制使用繁體中文）
      locale: const Locale('zh', 'TW'),
    );
  }
}
