import 'package:flutter/material.dart';
import '../theme/motion_tokens.dart';

/// Demonstrates an interruptible Morphing Action Button with async feedback.
///
/// Features:
/// - Smooth transition between idle, loading, and completed state.
/// - Non-blocking execution with instant visual feedback.
class MorphingActionButton extends StatefulWidget {
  final Future<void> Function() onAction;

  const MorphingActionButton({super.key, required this.onAction});

  @override
  State<MorphingActionButton> createState() => _MorphingActionButtonState();
}

enum ActionButtonState { idle, loading, success }

class _MorphingActionButtonState extends State<MorphingActionButton> {
  ActionButtonState _state = ActionButtonState.idle;

  Future<void> _handlePress() async {
    if (_state != ActionButtonState.idle) return;

    setState(() {
      _state = ActionButtonState.loading;
    });

    try {
      await widget.onAction();
      if (!mounted) return;
      setState(() {
        _state = ActionButtonState.success;
      });

      // Reset back to idle after short delay
      await Future<void>.delayed(const Duration(milliseconds: 1400));
      if (!mounted) return;
      setState(() {
        _state = ActionButtonState.idle;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _state = ActionButtonState.idle;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isIdle = _state == ActionButtonState.idle;
    final isLoading = _state == ActionButtonState.loading;
    final isSuccess = _state == ActionButtonState.success;

    final buttonWidth = isIdle ? 260.0 : 54.0;
    final buttonColor = isSuccess
        ? Colors.green
        : (isLoading ? colorScheme.primaryContainer : colorScheme.primary);

    return Semantics(
      button: true,
      enabled: isIdle,
      label: isIdle ? 'Trigger Async Task' : (isLoading ? 'Processing' : 'Done'),
      child: Center(
        child: AnimatedContainer(
          duration: MotionTokens.standardDuration,
          curve: MotionTokens.emphasizedCurve,
          width: buttonWidth,
          height: 52.0,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(
              isIdle ? MotionTokens.buttonRadius : 27.0,
            ),
            boxShadow: [
              BoxShadow(
                color: buttonColor.withValues(alpha: 0.3),
                blurRadius: isIdle ? 8 : 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(
                isIdle ? MotionTokens.buttonRadius : 27.0,
              ),
              onTap: isIdle ? _handlePress : null,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: AnimatedSwitcher(
                    duration: MotionTokens.fastDuration,
                    child: _buildButtonContent(context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (_state) {
      case ActionButtonState.idle:
        return Row(
          key: const ValueKey('idle'),
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flash_on, color: colorScheme.onPrimary, size: 20),
            const SizedBox(width: MotionTokens.space8),
            Text(
              'Trigger Fluid Action',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      case ActionButtonState.loading:
        return SizedBox(
          key: const ValueKey('loading'),
          width: 24.0,
          height: 24.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
        );
      case ActionButtonState.success:
        return const Icon(
          key: ValueKey('success'),
          Icons.check,
          color: Colors.white,
          size: 28.0,
        );
    }
  }
}
