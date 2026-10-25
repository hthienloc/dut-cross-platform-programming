import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:async_stream_demo/main.dart';

void main() {
  testWidgets('Capture demo app screenshot', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2.0;

    await tester.pumpWidget(const AsyncStreamApp());
    await tester.pumpAndSettle();

    // Tap Start button
    await tester.tap(find.byKey(const Key('btn_start')));
    // Fast-forward 5 seconds to simulate 5 ticks
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('5'), findsOneWidget);
    expect(find.text('TRẠNG THÁI: ĐANG PHÁT LUỒNG DỮ LIỆU (RUNNING)'), findsOneWidget);

    // Save screenshot
    await expectLater(
      find.byType(AsyncStreamApp),
      matchesGoldenFile('goldens/demo_ui.png'),
    );
  });
}
