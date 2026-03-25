import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// 應用程式語言設定
/// 定義支援的語言選項
enum AppLocale {
  zhTW,  // 繁體中文
  enUS,  // 英文
}

/// 國際化翻譯類別
/// 提供多語言支援，可根據當前語言設定返回對應的文字
class AppLocalizations {
  final AppLocale locale;

  const AppLocalizations(this.locale);

  /// 從 context 中獲取 AppLocalizations 實例
  /// 使用方式：AppLocalizations.of(context).greeting
  static AppLocalizations of(BuildContext context) {
    final appLocalizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (appLocalizations != null) {
      return appLocalizations;
    }
    // 如果找不到（例如在測試環境中），返回預設的繁體中文實例
    return const AppLocalizations(AppLocale.zhTW);
  }

  /// 繁體中文翻譯
  static const Map<String, String> _zhTW = {
    'app_title': 'To Do List',
    'add_hint': '新增待辦事項...',
    'clear_completed': '清除已完成',
    'total_count': '共 {} 項',
    'completed_count': '已完成 {} 項',
    'no_todos': '尚無待辦事項',
    'delete': '刪除',
  };

  /// 英文翻譯
  static const Map<String, String> _enUS = {
    'app_title': 'To Do List',
    'add_hint': 'Add a todo...',
    'clear_completed': 'Clear Completed',
    'total_count': 'Total: {} items',
    'completed_count': 'Completed: {} items',
    'no_todos': 'No todos yet',
    'delete': 'Delete',
  };

  /// 根據語言設定選擇對應的翻譯字典
  Map<String, String> get _translations {
    switch (locale) {
      case AppLocale.zhTW:
        return _zhTW;
      case AppLocale.enUS:
        return _enUS;
    }
  }

  /// 獲取翻譯文字
  /// [key] 翻譯鍵
  /// [params] 可選的參數，用於替換 {} 佔位符
  String translate(String key, [List<String>? params]) {
    String text = _translations[key] ?? key;
    
    // 如果有參數，替換 {} 佔位符
    if (params != null && params.isNotEmpty) {
      for (var param in params) {
        text = text.replaceFirst('{}', param);
      }
    }
    
    return text;
  }

  /// 便捷方法：獲取應用程式標題
  String get appTitle => translate('app_title');

  /// 便捷方法：獲取輸入框提示文字
  String get addHint => translate('add_hint');

  /// 便捷方法：獲取清除已完成按鈕文字
  String get clearCompleted => translate('clear_completed');

  /// 便捷方法：獲取總計文字（帶參數）
  String totalCount(int count) => translate('total_count', [count.toString()]);

  /// 便捷方法：獲取已完成文字（帶參數）
  String completedCount(int count) => translate('completed_count', [count.toString()]);

  /// 便捷方法：獲取空狀態文字
  String get noTodos => translate('no_todos');

  /// 便捷方法：獲取刪除文字
  String get delete => translate('delete');
}

/// LocalizationsDelegate 實例
/// 用於設定 MaterialApp 的 localizationsDelegates
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final AppLocale locale;

  const AppLocalizationsDelegate(this.locale);

  @override
  bool isSupported(Locale locale) {
    // 支援 zh_TW 和 en_US
    return locale.languageCode == 'zh' || locale.languageCode == 'en';
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    // 根據語言代碼決定使用哪個 AppLocale
    AppLocale appLocale = AppLocale.zhTW; // 預設繁體中文
    
    if (locale.languageCode == 'en') {
      appLocale = AppLocale.enUS;
    } else if (locale.languageCode == 'zh' && locale.countryCode == 'TW') {
      appLocale = AppLocale.zhTW;
    }
    
    // 直接返回已建立的 AppLocalizations 實例
    return Future.value(AppLocalizations(appLocale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
