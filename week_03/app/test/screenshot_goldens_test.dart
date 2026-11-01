import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week03_dual_ui/main.dart';
import 'package:week03_dual_ui/theme/app_theme.dart';
import 'package:week03_dual_ui/widgets/adaptive_widgets.dart';

Future<void> loadFonts() async {
  // 1. Roboto & iOS System Fonts
  final robotoFile = File('/home/loccun/development/flutter/bin/cache/artifacts/material_fonts/Roboto-Regular.ttf');
  if (robotoFile.existsSync()) {
    final fontData = await robotoFile.readAsBytes();
    final names = [
      'Roboto',
      'CupertinoSystemText',
      'CupertinoSystemDisplay',
      '.SF Pro Text',
      '.SF Pro Display',
      '.SF UI Text',
      '.SF UI Display',
    ];
    for (final name in names) {
      final loader = FontLoader(name)..addFont(Future.value(ByteData.view(fontData.buffer)));
      await loader.load();
    }
  }

  // 2. Material Icons
  final materialIconsFile = File('/home/loccun/development/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
  if (materialIconsFile.existsSync()) {
    final fontData = await materialIconsFile.readAsBytes();
    final fontLoader = FontLoader('MaterialIcons')..addFont(Future.value(ByteData.view(fontData.buffer)));
    await fontLoader.load();
  }

  // 3. Cupertino Icons
  final cupertinoIconsFile = File('/home/loccun/.pub-cache/hosted/pub.dev/cupertino_icons-1.0.9/assets/CupertinoIcons.ttf');
  if (cupertinoIconsFile.existsSync()) {
    final fontData = await cupertinoIconsFile.readAsBytes();
    final fontLoader = FontLoader('packages/cupertino_icons/CupertinoIcons')..addFont(Future.value(ByteData.view(fontData.buffer)));
    await fontLoader.load();
    final fontLoaderAlt = FontLoader('CupertinoIcons')..addFont(Future.value(ByteData.view(fontData.buffer)));
    await fontLoaderAlt.load();
  }
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  testWidgets('Capture full app screenshots and component dialogs', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // 1. Capture Material 3 Overview Tab
    await tester.pumpWidget(const MultiStyleUXApp());
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MultiStyleUXApp),
      matchesGoldenFile('goldens/material_overview.png'),
    );

    // 2. Capture Material 3 UX Controls Tab
    await tester.tap(find.text('UX Controls'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MultiStyleUXApp),
      matchesGoldenFile('goldens/material_settings.png'),
    );

    // 3. Trigger Material Dialog and capture
    await tester.tap(find.text('Reset Defaults (Material Dialog)'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MultiStyleUXApp),
      matchesGoldenFile('goldens/material_dialog.png'),
    );
    // Dismiss dialog
    await tester.tap(find.text('CANCEL'));
    await tester.pumpAndSettle();

    // 4. Switch to Apple Cupertino Style
    final swapBtn = find.byIcon(Icons.swap_horiz);
    await tester.tap(swapBtn);
    await tester.pumpAndSettle();

    // 5. Capture Cupertino Overview Tab
    await tester.tap(find.text('Overview'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MultiStyleUXApp),
      matchesGoldenFile('goldens/cupertino_overview.png'),
    );

    // 6. Capture Cupertino UX Controls Tab
    await tester.tap(find.text('UX Controls'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MultiStyleUXApp),
      matchesGoldenFile('goldens/cupertino_settings.png'),
    );

    // 7. Trigger Cupertino Dialog and capture
    await tester.tap(find.text('Reset Defaults (Cupertino Dialog)'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MultiStyleUXApp),
      matchesGoldenFile('goldens/cupertino_dialog.png'),
    );
    // Dismiss dialog
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  });

  testWidgets('Capture isolated component comparisons', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1000, 320);
    tester.view.devicePixelRatio = 2.0;

    // Component comparison card: Buttons & Indicators
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: MaterialThemeConfig.lightTheme(),
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Material Component Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Material 3 Button (48dp)', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.download),
                            label: const Text('Simulate Task'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Cupertino Component Card
                  Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5E5EA), width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Cupertino Button (44pt)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        const SizedBox(height: 12),
                        CupertinoButton.filled(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          borderRadius: BorderRadius.circular(10),
                          onPressed: () {},
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(CupertinoIcons.arrow_down_circle, size: 18),
                              SizedBox(width: 6),
                              Text('Simulate Task', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/button_comparison.png'),
    );
  });
}
