import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/adaptive_widgets.dart';

void main() {
  runApp(const MultiStyleUXApp());
}

class MultiStyleUXApp extends StatefulWidget {
  const MultiStyleUXApp({super.key});

  @override
  State<MultiStyleUXApp> createState() => _MultiStyleUXAppState();
}

class _MultiStyleUXAppState extends State<MultiStyleUXApp> {
  final AppStateNotifier _notifier = AppStateNotifier();

  @override
  void initState() {
    super.initState();
    _notifier.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_notifier.style == AppDesignStyle.cupertino) {
      final brightness = _notifier.isDarkMode ? Brightness.dark : Brightness.light;
      return CupertinoApp(
        title: 'DualStyle UX Demo',
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeConfig.themeData(brightness),
        home: HomeScreen(notifier: _notifier),
      );
    } else {
      return MaterialApp(
        title: 'DualStyle UX Demo',
        debugShowCheckedModeBanner: false,
        theme: MaterialThemeConfig.lightTheme(),
        darkTheme: MaterialThemeConfig.darkTheme(),
        themeMode: _notifier.themeMode,
        home: HomeScreen(notifier: _notifier),
      );
    }
  }
}

class HomeScreen extends StatefulWidget {
  final AppStateNotifier notifier;

  const HomeScreen({super.key, required this.notifier});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  bool _hapticsEnabled = true;
  double _fontSizeScale = 1.0;
  bool _isLoading = false;
  String _lastFeedback = 'No action recorded yet.';

  void _triggerSimulatedAction() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _lastFeedback = 'Async task synced at ${DateTime.now().toIso8601String().substring(11, 19)} successfully!';
    });

    if (widget.notifier.style == AppDesignStyle.material) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_lastFeedback),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _confirmReset() async {
    final confirmed = await showAdaptiveConfirmDialog(
      context: context,
      style: widget.notifier.style,
      title: 'Reset Preferences',
      content: 'Are you sure you want to restore default UX and accessibility settings?',
    );
    if (confirmed == true && mounted) {
      setState(() {
        _hapticsEnabled = true;
        _fontSizeScale = 1.0;
        _lastFeedback = 'Default settings restored!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCupertino = widget.notifier.style == AppDesignStyle.cupertino;

    if (isCupertino) {
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          currentIndex: _selectedTabIndex,
          onTap: (index) => setState(() => _selectedTabIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_grid_2x2),
              activeIcon: Icon(CupertinoIcons.square_grid_2x2_fill),
              label: 'Overview',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.slider_horizontal_3),
              label: 'UX Controls',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.info_circle),
              activeIcon: Icon(CupertinoIcons.info_circle_fill),
              label: 'Principles',
            ),
          ],
        ),
        tabBuilder: (context, index) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(
                index == 0
                    ? 'DualStyle Hub (iOS)'
                    : index == 1
                        ? 'UX & Theme Settings'
                        : 'Design Principles',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => widget.notifier.toggleThemeMode(),
                    child: Icon(
                      widget.notifier.isDarkMode
                          ? CupertinoIcons.sun_max_fill
                          : CupertinoIcons.moon_fill,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => widget.notifier.toggleStyle(),
                    child: const Icon(CupertinoIcons.arrow_2_circlepath, size: 22),
                  ),
                ],
              ),
            ),
            child: SafeArea(
              child: _buildTabBody(index, isCupertino),
            ),
          );
        },
      );
    } else {
      // Material 3 Scaffold
      return Scaffold(
        appBar: AppBar(
          title: Text(
            _selectedTabIndex == 0
                ? 'DualStyle Hub (Material 3)'
                : _selectedTabIndex == 1
                    ? 'UX & Theme Settings'
                    : 'Design Principles',
          ),
          actions: [
            IconButton(
              tooltip: 'Toggle Dark/Light Mode',
              icon: Icon(
                widget.notifier.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () => widget.notifier.toggleThemeMode(),
            ),
            IconButton(
              tooltip: 'Switch to Cupertino (iOS)',
              icon: const Icon(Icons.swap_horiz),
              onPressed: () => widget.notifier.toggleStyle(),
            ),
          ],
        ),
        body: _buildTabBody(_selectedTabIndex, isCupertino),
        floatingActionButton: _selectedTabIndex == 0
            ? FloatingActionButton.extended(
                onPressed: _triggerSimulatedAction,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Icon(Icons.sync),
                label: const Text('Sync'),
              )
            : null,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedTabIndex,
          onDestinationSelected: (index) => setState(() => _selectedTabIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Overview',
            ),
            NavigationDestination(
              icon: Icon(Icons.tune_outlined),
              selectedIcon: Icon(Icons.tune),
              label: 'UX Controls',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: 'Principles',
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTabBody(int tabIndex, bool isCupertino) {
    if (tabIndex == 0) {
      return _buildOverviewTab(isCupertino);
    } else if (tabIndex == 1) {
      return _buildSettingsTab(isCupertino);
    } else {
      return _buildTheoryTab(isCupertino);
    }
  }

  // --- TAB 1: OVERVIEW & INTERACTIVE FEEDBACK ---
  Widget _buildOverviewTab(bool isCupertino) {
    return ListView(
      padding: const EdgeInsets.all(AppTokens.space16),
      children: [
        _buildStyleBadgeCard(isCupertino),
        const SizedBox(height: AppTokens.space16),

        _buildSectionTitle('1. Interactive Feedback & State', isCupertino),
        const SizedBox(height: AppTokens.space8),
        _buildFeedbackDemoCard(isCupertino),
        const SizedBox(height: AppTokens.space16),

        _buildSectionTitle('2. Readability & Visual Hierarchy', isCupertino),
        const SizedBox(height: AppTokens.space8),
        _buildReadabilityDemoCard(isCupertino),
      ],
    );
  }

  Widget _buildStyleBadgeCard(bool isCupertino) {
    final styleName = isCupertino ? 'Cupertino (Apple iOS HIG)' : 'Material Design 3 (Google)';
    final desc = isCupertino
        ? 'Focuses on Clarity, Deference, and Depth. Features translucent frosted backdrops, crisp hairline dividers, and fluid motion feedback.'
        : 'Emphasizes personalization through Dynamic Color seeds, tonal surface elevation, generous rounded corners, and expressive ripple effects.';

    if (isCupertino) {
      return Container(
        padding: const EdgeInsets.all(AppTokens.space16),
        decoration: BoxDecoration(
          color: widget.notifier.isDarkMode
              ? const Color(0xFF1C1C1E)
              : CupertinoColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.notifier.isDarkMode
                ? const Color(0xFF38383A)
                : const Color(0xFFE5E5EA),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(CupertinoIcons.device_phone_portrait, color: CupertinoColors.activeBlue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    styleName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              style: TextStyle(
                fontSize: 14 * _fontSizeScale,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    } else {
      return Card(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.style, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      styleName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                desc,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14 * _fontSizeScale,
                      height: 1.4,
                    ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildFeedbackDemoCard(bool isCupertino) {
    return _buildContainerWrapper(
      isCupertino: isCupertino,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Touch response & Loading State validation:',
            style: TextStyle(
              fontSize: 15 * _fontSizeScale,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTokens.space12),
          Wrap(
            spacing: AppTokens.space16,
            runSpacing: AppTokens.space8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AdaptivePrimaryButton(
                style: widget.notifier.style,
                label: 'Simulate Async Action',
                icon: isCupertino ? CupertinoIcons.arrow_down_circle : Icons.download,
                onPressed: _triggerSimulatedAction,
              ),
              if (_isLoading) AdaptiveLoadingIndicator(style: widget.notifier.style),
            ],
          ),
          const SizedBox(height: AppTokens.space12),
          Container(
            padding: const EdgeInsets.all(AppTokens.space12),
            decoration: BoxDecoration(
              color: isCupertino
                  ? (widget.notifier.isDarkMode
                      ? const Color(0xFF2C2C2E)
                      : CupertinoColors.systemGrey6)
                  : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isCupertino ? CupertinoIcons.bell : Icons.notifications_active,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _lastFeedback,
                    style: TextStyle(fontSize: 13 * _fontSizeScale),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadabilityDemoCard(bool isCupertino) {
    return _buildContainerWrapper(
      isCupertino: isCupertino,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Headline Level 1 (Title Large)',
            style: TextStyle(
              fontSize: 18 * _fontSizeScale,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Subtitle Level 2 (Body Medium) - Compliant with WCAG AA Contrast (> 4.5:1)',
            style: TextStyle(
              fontSize: 14 * _fontSizeScale,
              color: isCupertino
                  ? CupertinoColors.secondaryLabel.resolveFrom(context)
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppTokens.space12),
          Text(
            'Layout spacing strictly follows the standard 8dp grid (8, 16, 24, 32). Interactive touch targets strictly adhere to >= 48dp on Android and >= 44pt on iOS, safeguarding high accessibility across all user demographics.',
            style: TextStyle(
              fontSize: 14 * _fontSizeScale,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: UX CONTROLS & ACCESSIBILITY ---
  Widget _buildSettingsTab(bool isCupertino) {
    return ListView(
      padding: const EdgeInsets.all(AppTokens.space16),
      children: [
        _buildSectionTitle('Live System Configuration', isCupertino),
        const SizedBox(height: AppTokens.space8),
        _buildContainerWrapper(
          isCupertino: isCupertino,
          child: Column(
            children: [
              // Style Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Cupertino (Apple iOS) Mode',
                      style: TextStyle(fontSize: 15 * _fontSizeScale, fontWeight: FontWeight.w500),
                    ),
                  ),
                  if (isCupertino)
                    CupertinoSwitch(
                      value: widget.notifier.style == AppDesignStyle.cupertino,
                      onChanged: (val) {
                        widget.notifier.setStyle(
                          val ? AppDesignStyle.cupertino : AppDesignStyle.material,
                        );
                      },
                    )
                  else
                    Switch(
                      value: widget.notifier.style == AppDesignStyle.cupertino,
                      onChanged: (val) {
                        widget.notifier.setStyle(
                          val ? AppDesignStyle.cupertino : AppDesignStyle.material,
                        );
                      },
                    ),
                ],
              ),
              const Divider(),

              // Dark Mode Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Dark Theme (High Contrast)',
                      style: TextStyle(fontSize: 15 * _fontSizeScale, fontWeight: FontWeight.w500),
                    ),
                  ),
                  if (isCupertino)
                    CupertinoSwitch(
                      value: widget.notifier.isDarkMode,
                      onChanged: (_) => widget.notifier.toggleThemeMode(),
                    )
                  else
                    Switch(
                      value: widget.notifier.isDarkMode,
                      onChanged: (_) => widget.notifier.toggleThemeMode(),
                    ),
                ],
              ),
              const Divider(),

              // Haptics Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Auditory / Haptic Feedback',
                      style: TextStyle(fontSize: 15 * _fontSizeScale, fontWeight: FontWeight.w500),
                    ),
                  ),
                  if (isCupertino)
                    CupertinoSwitch(
                      value: _hapticsEnabled,
                      onChanged: (v) => setState(() => _hapticsEnabled = v),
                    )
                  else
                    Switch(
                      value: _hapticsEnabled,
                      onChanged: (v) => setState(() => _hapticsEnabled = v),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTokens.space16),

        _buildSectionTitle('Text Scaling (Accessibility - a11y)', isCupertino),
        const SizedBox(height: AppTokens.space8),
        _buildContainerWrapper(
          isCupertino: isCupertino,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Font Scale: ${(_fontSizeScale * 100).toInt()}%',
                style: TextStyle(fontSize: 15 * _fontSizeScale, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              if (isCupertino)
                CupertinoSlider(
                  value: _fontSizeScale,
                  min: 0.8,
                  max: 1.4,
                  divisions: 6,
                  onChanged: (v) => setState(() => _fontSizeScale = v),
                )
              else
                Slider(
                  value: _fontSizeScale,
                  min: 0.8,
                  max: 1.4,
                  divisions: 6,
                  label: '${(_fontSizeScale * 100).toInt()}%',
                  onChanged: (v) => setState(() => _fontSizeScale = v),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppTokens.space24),

        // Reset Settings Button (Triggers Adaptive Dialog)
        Center(
          child: isCupertino
              ? CupertinoButton(
                  onPressed: _confirmReset,
                  child: const Text('Reset Defaults (Cupertino Dialog)'),
                )
              : OutlinedButton.icon(
                  onPressed: _confirmReset,
                  icon: const Icon(Icons.restore),
                  label: const Text('Reset Defaults (Material Dialog)'),
                ),
        ),
      ],
    );
  }

  // --- TAB 3: PRINCIPLES & DESIGN SYSTEM SPECIFICATIONS ---
  Widget _buildTheoryTab(bool isCupertino) {
    return ListView(
      padding: const EdgeInsets.all(AppTokens.space16),
      children: [
        _buildTheoryTile(
          isCupertino: isCupertino,
          icon: isCupertino ? CupertinoIcons.layers : Icons.layers,
          title: 'Scaffold & Core Structural Foundations',
          content: 'Material utilizes Scaffold integrated with AppBar, FloatingActionButton, and NavigationBar. Cupertino adopts CupertinoPageScaffold with translucent CupertinoNavigationBar and CupertinoTabBar.',
        ),
        const SizedBox(height: AppTokens.space12),
        _buildTheoryTile(
          isCupertino: isCupertino,
          icon: isCupertino ? CupertinoIcons.paintbrush : Icons.palette,
          title: 'Theme & Color Systems',
          content: 'Material 3 calculates 30+ accessible tonal shades automatically via ColorScheme.fromSeed(). Cupertino leverages CupertinoDynamicColor resolving dynamically with system contrast preferences.',
        ),
        const SizedBox(height: AppTokens.space12),
        _buildTheoryTile(
          isCupertino: isCupertino,
          icon: isCupertino ? CupertinoIcons.hand_draw : Icons.touch_app,
          title: 'Interactive Feedback Mechanics',
          content: 'Material propagates radial InkWell ripples from the touch point. Cupertino applies instantaneous opacity reduction down to 40% upon contact along with haptic impulse.',
        ),
        const SizedBox(height: AppTokens.space12),
        _buildTheoryTile(
          isCupertino: isCupertino,
          icon: isCupertino ? CupertinoIcons.eye : Icons.visibility,
          title: 'Readability & Accessibility (a11y)',
          content: 'Guarantees WCAG AA contrast ratio >= 4.5:1. Enforces min touch target dimensions of 48x48dp (Material) and 44x44pt (Cupertino) to eliminate tap misses.',
        ),
      ],
    );
  }

  Widget _buildTheoryTile({
    required bool isCupertino,
    required IconData icon,
    required String title,
    required String content,
  }) {
    return _buildContainerWrapper(
      isCupertino: isCupertino,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: isCupertino ? CupertinoColors.activeBlue : Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppTokens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16 * _fontSizeScale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 13.5 * _fontSizeScale,
                    height: 1.45,
                    color: isCupertino
                        ? CupertinoColors.label.resolveFrom(context).withValues(alpha: 0.85)
                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isCupertino) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14 * _fontSizeScale,
        fontWeight: FontWeight.w600,
        color: isCupertino
            ? CupertinoColors.secondaryLabel.resolveFrom(context)
            : Theme.of(context).colorScheme.primary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildContainerWrapper({required bool isCupertino, required Widget child}) {
    if (isCupertino) {
      return Container(
        padding: const EdgeInsets.all(AppTokens.space16),
        decoration: BoxDecoration(
          color: widget.notifier.isDarkMode
              ? const Color(0xFF1C1C1E)
              : CupertinoColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: widget.notifier.isDarkMode
                ? const Color(0xFF38383A)
                : const Color(0xFFE5E5EA),
            width: 1,
          ),
        ),
        child: child,
      );
    } else {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.space16),
          child: child,
        ),
      );
    }
  }
}
