import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'i18n.dart';
import 'pages/todo_list_page.dart';
import 'providers/todo_provider.dart';

/// 應用程式入口函式
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Hive
  await Hive.initFlutter();

  // 初始化 Provider
  final todoProvider = TodoProvider();
  await todoProvider.init();

  runApp(
    ChangeNotifierProvider.value(
      value: todoProvider,
      child: const TodoApp(),
    ),
  );
}

/// 待辦事項應用程式主體
class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 如果是桌面/網頁，強制限制最大寬度為手機尺寸
        final isWideScreen = constraints.maxWidth > 480;
        
        return MaterialApp(
          title: 'To Do List',
          // 設定應用程式的主題
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // 深色模式主題
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // 跟隨系統主題
          themeMode: ThemeMode.system,
          // 設定首頁為待辦事項列表頁面
          home: isWideScreen
              ? const Center(
                  child: SizedBox(
                    width: 480, // 手機最大寬度
                    child: TodoListPage(),
                  ),
                )
              : const TodoListPage(),
          // 設定國際化支援
          localizationsDelegates: [
            const AppLocalizationsDelegate(AppLocale.zhTW),
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: const [
            Locale('zh', 'TW'),
            Locale('en', 'US'),
          ],
          locale: const Locale('zh', 'TW'),
        );
      },
    );
  }
}
