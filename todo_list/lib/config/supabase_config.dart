import 'package:shared_preferences/shared_preferences.dart';

/// Supabase 設定管理器
/// 使用 SharedPreferences 儲存使用者的 Supabase 連線設定
class SupabaseConfig {
  /// 預設 Supabase URL（Demo 用）
  static const String defaultUrl = 'https://omareqsfkeqslywwvkyg.supabase.co';

  static const String _keyUrl = 'supabase_url';
  static const String _keyAnonKey = 'supabase_anon_key';
  static const String _keyIsConfigured = 'supabase_is_configured';

  /// 檢查是否已完成設定
  static Future<bool> isConfigured() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsConfigured) ?? false;
  }

  /// 取得 Supabase URL（若無則回傳預設值）
  static Future<String> getUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUrl) ?? defaultUrl;
  }

  /// 取得 Supabase Anon Key
  static Future<String?> getAnonKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAnonKey);
  }

  /// 儲存設定
  static Future<void> saveConfig({
    required String url,
    required String anonKey,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUrl, url);
    await prefs.setString(_keyAnonKey, anonKey);
    await prefs.setBool(_keyIsConfigured, true);
  }

  /// 清除設定
  static Future<void> clearConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUrl);
    await prefs.remove(_keyAnonKey);
    await prefs.setBool(_keyIsConfigured, false);
  }

  /// 取得完整設定（用於顯示）
  static Future<Map<String, String>> getConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'url': prefs.getString(_keyUrl) ?? defaultUrl,
      'anonKey': prefs.getString(_keyAnonKey) ?? '',
      'isConfigured': (prefs.getBool(_keyIsConfigured) ?? false).toString(),
    };
  }

  /// 檢查是否已有 Anon Key（已連線）
  static Future<bool> hasAnonKey() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(_keyAnonKey);
    return key != null && key.isNotEmpty;
  }
}
