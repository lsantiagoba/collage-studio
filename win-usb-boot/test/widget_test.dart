import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:win_usb_boot/main.dart';

void main() {
  testWidgets('shows the boot media workflow', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomePage(scanOnStart: false)),
    );
    expect(find.text('Win USB Boot'), findsOneWidget);
    expect(find.text('Create your Windows installer'), findsOneWidget);
    expect(find.text('Drag & drop your ISO here'), findsOneWidget);
    expect(find.text('Windows 11'), findsOneWidget);
  });
}
