import 'package:flutter/material.dart';

class MotionConstants {
  // Global durations
  static const Duration micro = Duration(milliseconds: 120);
  static const Duration standard = Duration(milliseconds: 240);
  static const Duration emphasized = Duration(milliseconds: 400);

  // Extended durations for complex animations
  static const Duration extended = Duration(milliseconds: 600);
  static const Duration celebration = Duration(milliseconds: 1200);

  // Easing curves
  static const Curve standardEasing = Curves.easeInOutCubic;
  static const Curve emphasizedEasing = Curves.elasticOut;
  static const Curve celebrationEasing = Curves.elasticOut;

  // Custom easing curves matching PRD specifications
  static const Curve standardCurve = Cubic(0.2, 0, 0, 1);
  static const Curve emphasizedCurve = Cubic(0.34, 1.56, 0.64, 1);

  // Animation curves for specific interactions
  static const Curve buttonPress = Curves.easeOutCubic;
  static const Curve cardHover = Curves.easeOutCubic;
  static const Curve carouselSnap = Curves.easeOutCubic;
  static const Curve markDraw = Curves.easeOutCubic;
  static const Curve winningLine = Curves.easeInOutCubic;

  // Haptic feedback patterns
  static const Duration hapticLight = Duration(milliseconds: 50);
  static const Duration hapticMedium = Duration(milliseconds: 100);
  static const Duration hapticHeavy = Duration(milliseconds: 150);

  // Sound cue durations
  static const Duration soundTap = Duration(milliseconds: 150);
  static const Duration soundMark = Duration(milliseconds: 200);
  static const Duration soundWin = Duration(milliseconds: 800);
  static const Duration soundLoss = Duration(milliseconds: 400);
  static const Duration soundDraw = Duration(milliseconds: 300);

  // Performance targets
  static const int targetFPS = 60;
  static const int maxFPS = 144;
  static const Duration maxFrameTime = Duration(
    microseconds: 1667,
  ); // 60 FPS target

  // Board animation timing
  static const Duration cellHover = Duration(milliseconds: 150);
  static const Duration cellPress = Duration(milliseconds: 100);
  static const Duration markAppear = Duration(milliseconds: 200);
  static const Duration winningLineSweep = Duration(milliseconds: 450);

  // UI transition timing
  static const Duration navigationTransition = Duration(milliseconds: 200);
  static const Duration modalTransition = Duration(milliseconds: 120);
  static const Duration modalExit = Duration(milliseconds: 90);
  static const Duration typewriterChar = Duration(milliseconds: 40);
  static const Duration caretBlink = Duration(milliseconds: 600);

  // Ambient animation timing
  static const Duration ambientFloat = Duration(milliseconds: 3000);
  static const Duration ambientOpacity = Duration(milliseconds: 2000);
  static const Duration logoPulse = Duration(milliseconds: 2000);

  // Carousel timing
  static const Duration carouselAutoAdvance = Duration(seconds: 5);
  static const Duration carouselSnapDuration = Duration(milliseconds: 300);

  // Loading screen timing
  static const Duration loadingTarget = Duration(seconds: 2);
  static const Duration loadingSkeleton = Duration(seconds: 3);

  // Helper methods for responsive timing
  static Duration getResponsiveDuration(
    Duration baseDuration,
    double scaleFactor,
  ) => Duration(
    milliseconds: (baseDuration.inMilliseconds * scaleFactor).round(),
  );

  static Duration getTabletDuration(Duration baseDuration) =>
      Duration(milliseconds: (baseDuration.inMilliseconds * 1.2).round());

  static Duration getLargeTabletDuration(Duration baseDuration) =>
      Duration(milliseconds: (baseDuration.inMilliseconds * 1.4).round());
}
