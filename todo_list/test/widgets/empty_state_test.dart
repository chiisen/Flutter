import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/widgets/empty_state.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('EmptyState 元件測試', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyState(
            title: '測試標題',
            subtitle: '測試副標題',
            icon: Icons.inbox_outlined,
          ),
        ),
      ),
    );

    // 驗證標題
    expect(find.text('測試標題'), findsOneWidget);
    
    // 驗證副標題
    expect(find.text('測試副標題'), findsOneWidget);
    
    // 驗證圖示
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
  });

  testWidgets('EmptyState 自訂動作按鈕', (WidgetTester tester) async {
    bool buttonPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyState(
            title: '測試',
            action: ElevatedButton(
              onPressed: () => buttonPressed = true,
              child: const Text('點擊我'),
            ),
          ),
        ),
      ),
    );

    // 驗證按鈕存在
    expect(find.text('點擊我'), findsOneWidget);
    
    // 點擊按鈕
    await tester.tap(find.text('點擊我'));
    await tester.pump();
    
    // 驗證按鈕被點擊
    expect(buttonPressed, true);
  });
}
