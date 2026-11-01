import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week03_dual_ui/main.dart';
import 'package:week03_dual_ui/theme/app_theme.dart';
import 'package:week03_dual_ui/widgets/adaptive_widgets.dart';

void main() {
  group('UI & Style Transition Automated Tests (Material 3 & Cupertino)', () {
    testWidgets('Initial launch defaults to Material Design 3 style', (WidgetTester tester) async {
      await tester.pumpWidget(const MultiStyleUXApp());
      await tester.pumpAndSettle();

      // Verify Material-specific root widgets
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('DualStyle Hub (Material 3)'), findsOneWidget);
    });

    testWidgets('Switches to Apple Cupertino style upon tapping swap button', (WidgetTester tester) async {
      await tester.pumpWidget(const MultiStyleUXApp());
      await tester.pumpAndSettle();

      // Tap swap action on AppBar
      final swapButton = find.byIcon(Icons.swap_horiz);
      expect(swapButton, findsOneWidget);
      await tester.tap(swapButton);
      await tester.pumpAndSettle();

      // Verify Cupertino root widgets
      expect(find.byType(CupertinoApp), findsOneWidget);
      expect(find.byType(CupertinoTabBar), findsOneWidget);
      expect(find.text('DualStyle Hub (iOS)'), findsOneWidget);
    });

    testWidgets('AdaptivePrimaryButton adheres to touch target accessibility guidelines', (WidgetTester tester) async {
      // 1. Verify Material touch target constraint (>= 48x48 dp)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AdaptivePrimaryButton(
                style: AppDesignStyle.material,
                label: 'A11y Test Button',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
      final materialSize = tester.getSize(find.byType(AdaptivePrimaryButton));
      expect(materialSize.height, greaterThanOrEqualTo(AppTokens.minTouchTargetMaterial));

      // 2. Verify Cupertino touch target constraint (>= 44x44 pt)
      await tester.pumpWidget(
        CupertinoApp(
          home: CupertinoPageScaffold(
            child: Center(
              child: AdaptivePrimaryButton(
                style: AppDesignStyle.cupertino,
                label: 'A11y Test Button',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
      final cupertinoSize = tester.getSize(find.byType(AdaptivePrimaryButton));
      expect(cupertinoSize.height, greaterThanOrEqualTo(AppTokens.minTouchTargetCupertino));
    });

    testWidgets('Switches tabs and verifies font scaling slider interaction', (WidgetTester tester) async {
      await tester.pumpWidget(const MultiStyleUXApp());
      await tester.pumpAndSettle();

      // Tap "UX Controls" tab
      final settingsTab = find.text('UX Controls');
      expect(settingsTab, findsOneWidget);
      await tester.tap(settingsTab);
      await tester.pumpAndSettle();

      // Verify Slider availability
      expect(find.byType(Slider), findsOneWidget);
      expect(find.textContaining('Current Font Scale:'), findsOneWidget);
    });
  });
}
