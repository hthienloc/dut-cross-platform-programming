import 'package:flutter/material.dart';

/// App-wide design tokens for consistent spacing, animation duration, and curves.
class MotionTokens {
  MotionTokens._();

  // Spacing (8dp grid)
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;

  // Animation Durations (Material Motion Specs)
  static const Duration fastDuration = Duration(milliseconds: 150);
  static const Duration standardDuration = Duration(milliseconds: 300);
  static const Duration longDuration = Duration(milliseconds: 450);

  // Curves
  static const Curve standardCurve = Curves.easeInOutCubic;
  static const Curve emphasizedCurve = Curves.easeOutBack;
  static const Curve springCurve = Curves.elasticOut;

  // Touch targets & geometry
  static const double minTouchTarget = 48.0;
  static const double cardRadius = 16.0;
  static const double buttonRadius = 24.0;
}
