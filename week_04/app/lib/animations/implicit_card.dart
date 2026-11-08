import 'package:flutter/material.dart';
import '../theme/motion_tokens.dart';

/// Demonstrates Implicit Animation via [AnimatedContainer] and [AnimatedOpacity].
///
/// Features:
/// - Declarative state change (target value interpolation).
/// - Zero manual controller management (zero memory leak risk).
/// - Non-blocking interaction: does not lock the screen or input pipeline.
class ImplicitMotionCard extends StatefulWidget {
  final VoidCallback? onFavoriteToggled;

  const ImplicitMotionCard({super.key, this.onFavoriteToggled});

  @override
  State<ImplicitMotionCard> createState() => _ImplicitMotionCardState();
}

class _ImplicitMotionCardState extends State<ImplicitMotionCard> {
  bool _isExpanded = false;
  bool _isLiked = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _toggleLiked() {
    setState(() {
      _isLiked = !_isLiked;
    });
    widget.onFavoriteToggled?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: 'Implicit Animation Interactive Card',
      child: Card(
        elevation: _isExpanded ? 6.0 : 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MotionTokens.cardRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: AnimatedContainer(
          duration: MotionTokens.standardDuration,
          curve: MotionTokens.standardCurve,
          padding: const EdgeInsets.all(MotionTokens.space16),
          decoration: BoxDecoration(
            color: _isExpanded
                ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(MotionTokens.cardRadius),
            border: Border.all(
              color: _isExpanded
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: _isExpanded ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: MotionTokens.standardDuration,
                    curve: MotionTokens.emphasizedCurve,
                    width: _isExpanded ? 48.0 : 40.0,
                    height: _isExpanded ? 48.0 : 40.0,
                    decoration: BoxDecoration(
                      color: _isExpanded
                          ? colorScheme.primary
                          : colorScheme.secondaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: _isExpanded
                          ? colorScheme.onPrimary
                          : colorScheme.onSecondaryContainer,
                      size: _isExpanded ? 26.0 : 22.0,
                    ),
                  ),
                  const SizedBox(width: MotionTokens.space12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Implicit Motion Showcase',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Powered by AnimatedContainer',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    iconSize: 26.0,
                    tooltip: _isLiked ? 'Unlike' : 'Like',
                    icon: AnimatedScale(
                      scale: _isLiked ? 1.25 : 1.0,
                      duration: MotionTokens.fastDuration,
                      curve: MotionTokens.emphasizedCurve,
                      child: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.redAccent : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    onPressed: _toggleLiked,
                  ),
                ],
              ),
              const SizedBox(height: MotionTokens.space12),
              AnimatedCrossFade(
                firstChild: Text(
                  'Tap expand button below to inspect declarative animation interpolation...',
                  style: theme.textTheme.bodyMedium,
                ),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AnimatedContainer automatically interpolates width, height, colors, and borders without manual controller or ticker bindings.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: MotionTokens.space8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Zero Controller Boilerplate • Zero Memory Leak',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: MotionTokens.standardDuration,
              ),
              const SizedBox(height: MotionTokens.space12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _toggleExpanded,
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  label: Text(_isExpanded ? 'Show Less' : 'Inspect Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
