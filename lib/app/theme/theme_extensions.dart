import 'dart:ui';
import 'package:flutter/material.dart';

// Game-specific color extensions
class GameColors extends ThemeExtension<GameColors> {
  final Color win;
  final Color loss;
  final Color draw;
  final Color gem;
  final Color hint;
  final Color boardLine;
  final Color cellHover;
  final Color cellPressed;
  final Color glowCyan;
  final Color glowMagenta;

  const GameColors({
    required this.win,
    required this.loss,
    required this.draw,
    required this.gem,
    required this.hint,
    required this.boardLine,
    required this.cellHover,
    required this.cellPressed,
    required this.glowCyan,
    required this.glowMagenta,
  });

  // Light theme colors
  static const GameColors light = GameColors(
    win: Color(0xFF22C55E),
    loss: Color(0xFFEF4444),
    draw: Color(0xFF6B7280),
    gem: Color(0xFFFFC24D),
    hint: Color(0xFFFFB020),
    boardLine: Color(0xFFD6DAE3),
    cellHover: Color(0xFFF1F5F9),
    cellPressed: Color(0xFFE2E8F0),
    glowCyan: Color(0xFF00E5FF),
    glowMagenta: Color(0xFFFF4D9D),
  );

  // Dark theme colors
  static const GameColors dark = GameColors(
    win: Color(0xFF34D399),
    loss: Color(0xFFF87171),
    draw: Color(0xFF9CA3AF),
    gem: Color(0xFFFFCF6A),
    hint: Color(0xFFFFC448),
    boardLine: Color(0xFF223041),
    cellHover: Color(0xFF1E293B),
    cellPressed: Color(0xFF334155),
    glowCyan: Color(0xFF00E5FF),
    glowMagenta: Color(0xFFFF4D9D),
  );

  @override
  ThemeExtension<GameColors> copyWith({
    Color? win,
    Color? loss,
    Color? draw,
    Color? gem,
    Color? hint,
    Color? boardLine,
    Color? cellHover,
    Color? cellPressed,
    Color? glowCyan,
    Color? glowMagenta,
  }) => GameColors(
    win: win ?? this.win,
    loss: loss ?? this.loss,
    draw: draw ?? this.draw,
    gem: gem ?? this.gem,
    hint: hint ?? this.hint,
    boardLine: boardLine ?? this.boardLine,
    cellHover: cellHover ?? this.cellHover,
    cellPressed: cellPressed ?? this.cellPressed,
    glowCyan: glowCyan ?? this.glowCyan,
    glowMagenta: glowMagenta ?? this.glowMagenta,
  );

  @override
  ThemeExtension<GameColors> lerp(ThemeExtension<GameColors>? other, double t) {
    if (other is! GameColors) {
      return this;
    }

    return GameColors(
      win: Color.lerp(win, other.win, t)!,
      loss: Color.lerp(loss, other.loss, t)!,
      draw: Color.lerp(draw, other.draw, t)!,
      gem: Color.lerp(gem, other.gem, t)!,
      hint: Color.lerp(hint, other.hint, t)!,
      boardLine: Color.lerp(boardLine, other.boardLine, t)!,
      cellHover: Color.lerp(cellHover, other.cellHover, t)!,
      cellPressed: Color.lerp(cellPressed, other.cellPressed, t)!,
      glowCyan: Color.lerp(glowCyan, other.glowCyan, t)!,
      glowMagenta: Color.lerp(glowMagenta, other.glowMagenta, t)!,
    );
  }
}

// Motion duration extensions
class MotionDurations extends ThemeExtension<MotionDurations> {
  final Duration micro;
  final Duration standard;
  final Duration emphasized;
  final Duration extended;
  final Duration celebration;

  const MotionDurations({
    required this.micro,
    required this.standard,
    required this.emphasized,
    required this.extended,
    required this.celebration,
  });

  static const MotionDurations defaultDurations = MotionDurations(
    micro: Duration(milliseconds: 120),
    standard: Duration(milliseconds: 240),
    emphasized: Duration(milliseconds: 400),
    extended: Duration(milliseconds: 600),
    celebration: Duration(milliseconds: 1200),
  );

  @override
  ThemeExtension<MotionDurations> copyWith({
    Duration? micro,
    Duration? standard,
    Duration? emphasized,
    Duration? extended,
    Duration? celebration,
  }) => MotionDurations(
    micro: micro ?? this.micro,
    standard: standard ?? this.standard,
    emphasized: emphasized ?? this.emphasized,
    extended: extended ?? this.extended,
    celebration: celebration ?? this.celebration,
  );

  @override
  ThemeExtension<MotionDurations> lerp(
    ThemeExtension<MotionDurations>? other,
    double t,
  ) {
    if (other is! MotionDurations) {
      return this;
    }

    return MotionDurations(
      micro: _lerpDuration(micro, other.micro, t),
      standard: _lerpDuration(standard, other.standard, t),
      emphasized: _lerpDuration(emphasized, other.emphasized, t),
      extended: _lerpDuration(extended, other.extended, t),
      celebration: _lerpDuration(celebration, other.celebration, t),
    );
  }
}

// Motion easing extensions
class MotionEasings extends ThemeExtension<MotionEasings> {
  final Curve standard;
  final Curve emphasized;
  final Curve celebration;
  final Curve buttonPress;
  final Curve cardHover;
  final Curve carouselSnap;
  final Curve markDraw;
  final Curve winningLine;

  const MotionEasings({
    required this.standard,
    required this.emphasized,
    required this.celebration,
    required this.buttonPress,
    required this.cardHover,
    required this.carouselSnap,
    required this.markDraw,
    required this.winningLine,
  });

  static const MotionEasings defaultEasings = MotionEasings(
    standard: Cubic(0.2, 0, 0, 1),
    emphasized: Cubic(0.34, 1.56, 0.64, 1),
    celebration: Cubic(0.34, 1.56, 0.64, 1),
    buttonPress: Curves.easeOutCubic,
    cardHover: Curves.easeOutCubic,
    carouselSnap: Curves.easeOutCubic,
    markDraw: Curves.easeOutCubic,
    winningLine: Curves.easeInOutCubic,
  );

  @override
  ThemeExtension<MotionEasings> copyWith({
    Curve? standard,
    Curve? emphasized,
    Curve? celebration,
    Curve? buttonPress,
    Curve? cardHover,
    Curve? carouselSnap,
    Curve? markDraw,
    Curve? winningLine,
  }) => MotionEasings(
    standard: standard ?? this.standard,
    emphasized: emphasized ?? this.emphasized,
    celebration: celebration ?? this.celebration,
    buttonPress: buttonPress ?? this.buttonPress,
    cardHover: cardHover ?? this.cardHover,
    carouselSnap: carouselSnap ?? this.carouselSnap,
    markDraw: markDraw ?? this.markDraw,
    winningLine: winningLine ?? this.winningLine,
  );

  @override
  ThemeExtension<MotionEasings> lerp(
    ThemeExtension<MotionEasings>? other,
    double t,
  ) {
    if (other is! MotionEasings) {
      return this;
    }
    // For curves, we'll just return the current instance since lerping curves is complex
    return this;
  }
}

// Elevation extensions for overlays
class GameElevations extends ThemeExtension<GameElevations> {
  final double card;
  final double floating;
  final double modal;
  final double tooltip;
  final double overlay;

  const GameElevations({
    required this.card,
    required this.floating,
    required this.modal,
    required this.tooltip,
    required this.overlay,
  });

  static const GameElevations defaultElevations = GameElevations(
    card: 1,
    floating: 3,
    modal: 8,
    tooltip: 6,
    overlay: 12,
  );

  @override
  ThemeExtension<GameElevations> copyWith({
    double? card,
    double? floating,
    double? modal,
    double? tooltip,
    double? overlay,
  }) => GameElevations(
    card: card ?? this.card,
    floating: floating ?? this.floating,
    modal: modal ?? this.modal,
    tooltip: tooltip ?? this.tooltip,
    overlay: overlay ?? this.overlay,
  );

  @override
  ThemeExtension<GameElevations> lerp(
    ThemeExtension<GameElevations>? other,
    double t,
  ) {
    if (other is! GameElevations) {
      return this;
    }

    return GameElevations(
      card: lerpDouble(card, other.card, t)!,
      floating: lerpDouble(floating, other.floating, t)!,
      modal: lerpDouble(modal, other.modal, t)!,
      tooltip: lerpDouble(tooltip, other.tooltip, t)!,
      overlay: lerpDouble(overlay, other.overlay, t)!,
    );
  }
}

// Extension methods for easy access
extension ThemeExtensionX on ThemeData {
  GameColors get gameColors => extension<GameColors>() ?? GameColors.light;
  MotionDurations get motionDurations =>
      extension<MotionDurations>() ?? MotionDurations.defaultDurations;
  MotionEasings get motionEasings =>
      extension<MotionEasings>() ?? MotionEasings.defaultEasings;
  GameElevations get gameElevations =>
      extension<GameElevations>() ?? GameElevations.defaultElevations;
}

// Helper function to interpolate between Duration objects
Duration _lerpDuration(Duration a, Duration b, double t) => Duration(
  microseconds: lerpDouble(
    a.inMicroseconds.toDouble(),
    b.inMicroseconds.toDouble(),
    t,
  )!.round(),
);
