import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import '../theme/motion_tokens.dart';

/// Demonstrates Explicit Animation & Gesture Arena integration.
///
/// Features:
/// - Explicit [AnimationController] bound via [SingleTickerProviderStateMixin].
/// - [GestureDetector] with 2D pan tracking (`onPanUpdate`, `onPanEnd`).
/// - Interruptible physics-based spring return ([SpringSimulation]).
/// - Strictly prevents memory leaks by disposing controller before super.dispose.
class DragSpringCard extends StatefulWidget {
  final VoidCallback? onDismissed;

  const DragSpringCard({super.key, this.onDismissed});

  @override
  State<DragSpringCard> createState() => DragSpringCardState();
}

class DragSpringCardState extends State<DragSpringCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<Offset> _animation;

  Offset _dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: MotionTokens.standardDuration,
    );

    _animation = _controller.drive(
      Tween<Offset>(begin: Offset.zero, end: Offset.zero),
    );

    _controller.addListener(() {
      setState(() {
        _dragOffset = _animation.value;
      });
    });
  }

  @visibleForTesting
  void setTestOffset(Offset offset) {
    setState(() {
      _dragOffset = offset;
    });
  }

  @override
  void dispose() {
    // CRITICAL: Always dispose AnimationController before calling super.dispose()
    // to unlink the active Ticker and prevent heap memory leaks.
    _controller.dispose();
    super.dispose();
  }

  void _runSpringAnimation(Offset targetOffset, Velocity velocity) {
    _animation = _controller.drive(
      Tween<Offset>(
        begin: _dragOffset,
        end: targetOffset,
      ),
    );

    // Calculate spring physics simulation using touch release velocity
    final pxPerSec = velocity.pixelsPerSecond;
    final distance = (targetOffset - _dragOffset).distance;
    final unitsPerSec = distance > 0 ? (pxPerSec.distance / distance) : 1.0;

    const spring = SpringDescription(
      mass: 1.0,
      stiffness: 180.0,
      damping: 18.0,
    );

    final simulation = SpringSimulation(spring, 0.0, 1.0, -unitsPerSec);

    _controller.reset();
    _controller.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate rotation angle and elevation dynamically from drag offset
    final rotationAngle = (_dragOffset.dx / 400.0).clamp(-0.25, 0.25);
    final isDragging = _dragOffset != Offset.zero;

    return Semantics(
      label: 'Draggable Spring Card',
      child: GestureDetector(
        onPanStart: (details) {
          // Interrupt any running spring return instantly
          if (_controller.isAnimating) {
            _controller.stop();
          }
        },
        onPanUpdate: (details) {
          setState(() {
            _dragOffset += details.delta;
          });
        },
        onPanEnd: (details) {
          // Threshold check: If dragged horizontally > 150dp, snap dismiss or reset
          if (_dragOffset.dx.abs() > 160.0) {
            widget.onDismissed?.call();
          }
          // Spring back to origin smoothly
          _runSpringAnimation(Offset.zero, details.velocity);
        },
        child: Transform.translate(
          offset: _dragOffset,
          child: Transform.rotate(
            angle: rotationAngle,
            child: Card(
              elevation: isDragging ? 10.0 : 3.0,
              shadowColor: colorScheme.shadow.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MotionTokens.cardRadius),
                side: BorderSide(
                  color: isDragging
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                  width: isDragging ? 2.0 : 1.0,
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(MotionTokens.space16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(MotionTokens.cardRadius),
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.surface,
                      isDragging
                          ? colorScheme.primaryContainer.withValues(alpha: 0.25)
                          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: colorScheme.tertiaryContainer,
                          child: Icon(
                            Icons.touch_app,
                            color: colorScheme.onTertiaryContainer,
                          ),
                        ),
                        const SizedBox(width: MotionTokens.space12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Interactive Drag & Spring Physics',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'GestureDetector + AnimationController',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: MotionTokens.space12),
                    Text(
                      'Drag this card anywhere on the screen. Notice the responsive tilt angle. Release to observe the organic SpringSimulation recoil.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: MotionTokens.space12),
                    Row(
                      children: [
                        Icon(
                          Icons.swap_horiz,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Offset: (${_dragOffset.dx.toStringAsFixed(1)}, ${_dragOffset.dy.toStringAsFixed(1)})',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontFamily: 'monospace',
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text(
                            isDragging ? 'Dragging' : 'At Rest',
                            style: theme.textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
