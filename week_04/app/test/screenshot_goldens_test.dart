import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motion_gesture_app/animations/explicit_drag_card.dart';
import 'package:motion_gesture_app/animations/implicit_card.dart';
import 'package:motion_gesture_app/animations/morphing_button.dart';
import 'package:motion_gesture_app/main.dart';

Future<void> loadFonts() async {
  final robotoFile = File('/home/loccun/development/flutter/bin/cache/artifacts/material_fonts/Roboto-Regular.ttf');
  if (robotoFile.existsSync()) {
    final fontData = await robotoFile.readAsBytes();
    final names = ['Roboto', 'CupertinoSystemText', '.SF Pro Text'];
    for (final name in names) {
      final loader = FontLoader(name)..addFont(Future.value(ByteData.view(fontData.buffer)));
      await loader.load();
    }
  }

  final materialIconsFile = File('/home/loccun/development/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
  if (materialIconsFile.existsSync()) {
    final fontData = await materialIconsFile.readAsBytes();
    final fontLoader = FontLoader('MaterialIcons')..addFont(Future.value(ByteData.view(fontData.buffer)));
    await fontLoader.load();
  }
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  testWidgets('Capture exact screenshots for Week 04 presentation', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2160);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // 1. Initial State (Overview)
    await tester.pumpWidget(const MotionGestureApp());
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MotionGestureApp),
      matchesGoldenFile('goldens/app_overview.png'),
    );

    // 2. Expand Implicit Card
    final inspectBtn = find.text('Inspect Details');
    await tester.tap(inspectBtn);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MotionGestureApp),
      matchesGoldenFile('goldens/implicit_expanded.png'),
    );

    // Revert Implicit card back to rest
    await tester.tap(find.text('Show Less'));
    await tester.pumpAndSettle();

    // 3. Drag Gesture Card - Active state under pointer
    final dragCardState = tester.state<DragSpringCardState>(find.byType(DragSpringCard));
    // Manually set drag offset to simulate real mid-drag with rotation tilt
    dragCardState.setTestOffset(const Offset(110.0, 35.0));
    await tester.pump();

    await expectLater(
      find.byType(MotionGestureApp),
      matchesGoldenFile('goldens/explicit_dragged.png'),
    );

    dragCardState.setTestOffset(Offset.zero);
    await tester.pumpAndSettle();
  });
}
