import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motion_gesture_app/main.dart';
import 'package:motion_gesture_app/animations/implicit_card.dart';
import 'package:motion_gesture_app/animations/explicit_drag_card.dart';
import 'package:motion_gesture_app/animations/morphing_button.dart';

void main() {
  group('Week 04 - Motion & Gestures Automated Test Suite', () {
    testWidgets('1. App launches with M3 theme and initial components', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const MotionGestureApp());
      await tester.pumpAndSettle();

      expect(find.text('Motion & Gestures Hub'), findsOneWidget);
      expect(find.text('1. Implicit Animation (Declarative)'), findsOneWidget);
      expect(find.text('2. Explicit Animation & Gesture Arena'), findsOneWidget);
      expect(find.text('3. Non-Blocking Fluid Interaction'), findsOneWidget);
      expect(find.byType(ImplicitMotionCard), findsOneWidget);
      expect(find.byType(DragSpringCard), findsOneWidget);
      expect(find.byType(MorphingActionButton), findsOneWidget);
    });

    testWidgets('2. Implicit Animation toggles state and interpolates smoothly', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const MotionGestureApp());
      await tester.pumpAndSettle();

      final inspectButton = find.text('Inspect Details');
      expect(inspectButton, findsOneWidget);

      await tester.tap(inspectButton);
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.text('Show Less'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Zero Controller Boilerplate • Zero Memory Leak'), findsOneWidget);

      final likeButton = find.byTooltip('Like');
      expect(likeButton, findsOneWidget);
      await tester.tap(likeButton);
      await tester.pumpAndSettle();
      expect(find.byTooltip('Unlike'), findsOneWidget);
    });

    testWidgets('3. Explicit Drag & Spring Gesture tracks offset and springs back', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const MotionGestureApp());
      await tester.pumpAndSettle();

      final dragCardFinder = find.byType(DragSpringCard);
      expect(dragCardFinder, findsOneWidget);

      // Perform a pan gesture (drag horizontally by 80px)
      await tester.drag(dragCardFinder, const Offset(80.0, 20.0));
      await tester.pump();

      // Settle spring simulation back to rest
      await tester.pumpAndSettle();
      expect(find.text('At Rest'), findsOneWidget);
      expect(find.text('Offset: (0.0, 0.0)'), findsOneWidget);
    });

    testWidgets('4. Morphing button executes non-blocking async lifecycle without locking UI', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const MotionGestureApp());
      await tester.pumpAndSettle();

      final actionButton = find.text('Trigger Fluid Action');
      expect(actionButton, findsOneWidget);

      await tester.tap(actionButton);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for delayed async simulated work
      await tester.pump(const Duration(milliseconds: 1300));
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Wait for reset timer
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pumpAndSettle();

      expect(find.text('Trigger Fluid Action'), findsOneWidget);
    });

    testWidgets('5. AnimationController properly disposes without active ticker assertions', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DragSpringCard(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox.shrink(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
