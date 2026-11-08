import 'package:flutter/material.dart';
import 'animations/implicit_card.dart';
import 'animations/explicit_drag_card.dart';
import 'animations/morphing_button.dart';
import 'theme/motion_tokens.dart';

void main() {
  runApp(const MotionGestureApp());
}

class MotionGestureApp extends StatefulWidget {
  const MotionGestureApp({super.key});

  @override
  State<MotionGestureApp> createState() => _MotionGestureAppState();
}

class _MotionGestureAppState extends State<MotionGestureApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Motion & Gestures',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4), // M3 Primary Purple
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
      ),
      home: MotionGestureHomeScreen(
        themeMode: _themeMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class MotionGestureHomeScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const MotionGestureHomeScreen({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  State<MotionGestureHomeScreen> createState() =>
      _MotionGestureHomeScreenState();
}

class _MotionGestureHomeScreenState extends State<MotionGestureHomeScreen> {
  int _actionCount = 0;

  void _incrementAction() {
    setState(() {
      _actionCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Motion & Gestures Hub'),
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to Light' : 'Switch to Dark',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: MotionTokens.space16,
            vertical: MotionTokens.space12,
          ),
          children: [
            // Header stats
            Container(
              padding: const EdgeInsets.all(MotionTokens.space16),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(MotionTokens.cardRadius),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.speed,
                    color: colorScheme.onSecondaryContainer,
                    size: 28,
                  ),
                  const SizedBox(width: MotionTokens.space12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hardware VSync Active (60 / 120 Hz)',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Actions triggered: $_actionCount',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: MotionTokens.space16),

            // Section 1: Implicit Animations
            Text(
              '1. Implicit Animation (Declarative)',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: MotionTokens.space8),
            ImplicitMotionCard(onFavoriteToggled: _incrementAction),
            const SizedBox(height: MotionTokens.space24),

            // Section 2: Explicit Animation & Drag Gestures
            Text(
              '2. Explicit Animation & Gesture Arena',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: MotionTokens.space8),
            DragSpringCard(
              onDismissed: () {
                _incrementAction();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Threshold reached! Drag gesture recognized.'),
                    duration: Duration(milliseconds: 1500),
                  ),
                );
              },
            ),
            const SizedBox(height: MotionTokens.space24),

            // Section 3: Non-blocking Interactive Action Button
            Text(
              '3. Non-Blocking Fluid Interaction',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: MotionTokens.space12),
            MorphingActionButton(
              onAction: () async {
                _incrementAction();
                // Simulate async API workload
                await Future<void>.delayed(const Duration(milliseconds: 1200));
              },
            ),
            const SizedBox(height: MotionTokens.space32),
          ],
        ),
      ),
    );
  }
}
