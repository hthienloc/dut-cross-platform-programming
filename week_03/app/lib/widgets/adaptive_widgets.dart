import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Adaptive confirmation dialog supporting Cupertino and Material design systems
Future<bool?> showAdaptiveConfirmDialog({
  required BuildContext context,
  required AppDesignStyle style,
  required String title,
  required String content,
}) {
  if (style == AppDesignStyle.cupertino) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(content),
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  } else {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('CONFIRM'),
          ),
        ],
      ),
    );
  }
}

/// Adaptive primary button: enforces touch target guidelines (min 48dp on Android, 44pt on iOS)
class AdaptivePrimaryButton extends StatelessWidget {
  final AppDesignStyle style;
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const AdaptivePrimaryButton({
    super.key,
    required this.style,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (style == AppDesignStyle.cupertino) {
      return Semantics(
        button: true,
        label: label,
        child: SizedBox(
          height: AppTokens.minTouchTargetCupertino,
          child: CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            borderRadius: BorderRadius.circular(10),
            onPressed: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Semantics(
        button: true,
        label: label,
        child: SizedBox(
          height: AppTokens.minTouchTargetMaterial,
          child: icon != null
              ? FilledButton.icon(
                  onPressed: onPressed,
                  icon: Icon(icon, size: 20),
                  label: Text(label),
                )
              : FilledButton(
                  onPressed: onPressed,
                  child: Text(label),
                ),
        ),
      );
    }
  }
}

/// Adaptive progress indicator supporting CircularProgressIndicator (M3) and CupertinoActivityIndicator (iOS)
class AdaptiveLoadingIndicator extends StatelessWidget {
  final AppDesignStyle style;

  const AdaptiveLoadingIndicator({super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    if (style == AppDesignStyle.cupertino) {
      return const CupertinoActivityIndicator(radius: 14);
    } else {
      return const SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(strokeWidth: 3),
      );
    }
  }
}
