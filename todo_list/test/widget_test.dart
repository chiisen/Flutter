// Flutter Widget 測試基礎範例
//
// 在測試中與 Widget 進行互動，可使用 flutter_test 套件中的 WidgetTester 工具。
// 例如：發送點擊 (tap) 和滾動 (scroll) 手勢。
// 也可使用 WidgetTester 查找 widget 樹中的子 widget、讀取文字，
// 並驗證 widget 屬性的值是否正確。

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_list/main.dart';

/// 測試程式入口
void main() {
  /// Widget 測試：驗證待辦事項新增功能
  /// 這是一個基本的冒煙測試 (smoke test)，用於確認應用程式基本功能正常運作
  testWidgets('Add todo item smoke test', (WidgetTester tester) async {
    // ===== 建置應用程式 =====
    // 將 TodoApp widget 載入測試環境並觸發一幀渲染
    await tester.pumpWidget(const TodoApp());

    // 等待幀渲染完成
    await tester.pumpAndSettle();

    // ===== 驗證初始狀態 =====
    // 檢查初始時顯示「尚無待辦事項」
    expect(find.text('尚無待辦事項'), findsOneWidget);
    
    // 檢查新增按鈕存在
    expect(find.byIcon(Icons.add), findsOneWidget);

    // ===== 模擬使用者互動 =====
    // 在輸入框中輸入文字
    await tester.enterText(
      find.byType(TextField),
      '測試待辦事項',
    );
    
    // 點擊新增按鈕
    await tester.tap(find.byIcon(Icons.add));
    // 觸發一幀渲染，讓 UI 更新
    await tester.pumpAndSettle();

    // ===== 驗證更新後狀態 =====
    // 檢查「尚無待辦事項」已消失
    expect(find.text('尚無待辦事項'), findsNothing);
    
    // 檢查新增的事項已顯示在列表中
    expect(find.text('測試待辦事項'), findsOneWidget);
    
    // 檢查統計資訊正確
    expect(find.text('共 1 項'), findsOneWidget);
    expect(find.text('已完成 0 項'), findsOneWidget);

    // ===== 測試完成功能 =====
    // 點擊複選框標記為完成
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    // 驗證已完成統計更新
    expect(find.text('已完成 1 項'), findsOneWidget);
  });
}
