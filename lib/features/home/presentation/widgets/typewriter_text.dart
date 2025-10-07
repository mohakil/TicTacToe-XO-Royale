import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/services/animation_pool.dart';

/// A typewriter text widget that animates text character by character
/// Used for the hero section in the home screen
class TypewriterText extends StatefulWidget {
  const TypewriterText({
    required this.text,
    super.key,
    this.style,
    this.speed = const Duration(milliseconds: 40),
    this.caretBlinkDuration = const Duration(milliseconds: 600),
    this.textAlign = TextAlign.left,
  });

  final String text;
  final TextStyle? style;
  final Duration speed;
  final Duration caretBlinkDuration;
  final TextAlign textAlign;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with TickerProviderStateMixin {
  late AnimationController _typewriterController;
  late AnimationController _caretController;
  late Animation<int> _typewriterAnimation;
  late Animation<double> _caretAnimation;

  int _currentLength = 0;
  bool _showCaret = true;

  @override
  void initState() {
    super.initState();

    _typewriterController = AnimationPool.getController(
      vsync: this,
      poolName: 'ui',
      duration: Duration(
        milliseconds: widget.text.length * widget.speed.inMilliseconds,
      ),
    );

    _caretController = AnimationPool.getController(
      vsync: this,
      poolName: 'ui',
      duration: widget.caretBlinkDuration,
    );

    _typewriterAnimation = IntTween(begin: 0, end: widget.text.length).animate(
      CurvedAnimation(parent: _typewriterController, curve: Curves.easeInOut),
    );

    _caretAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _caretController, curve: Curves.easeInOut),
    );

    _typewriterController.addListener(_typewriterListener);
    _caretController.addListener(_caretListener);

    // Start the typewriter animation
    _typewriterController.forward();

    // Start the caret blinking
    _caretController.repeat();
  }

  void _typewriterListener() {
    if (mounted) {
      setState(() {
        _currentLength = _typewriterAnimation.value;
      });
    }
  }

  void _caretListener() {
    if (mounted) {
      setState(() {
        _showCaret = _caretAnimation.value > 0.5;
      });
    }
  }

  @override
  void dispose() {
    // Remove listeners before returning controllers to pool
    _typewriterController.removeListener(_typewriterListener);
    _caretController.removeListener(_caretListener);

    // Return controllers to the pool instead of disposing them directly
    AnimationPool.returnController(_typewriterController, 'ui');
    AnimationPool.returnController(_caretController, 'ui');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Flexible(
        child: Text(
          widget.text.substring(0, _currentLength),
          style: widget.style,
          textAlign: widget.textAlign,
        ),
      ),
      if (_showCaret && _currentLength < widget.text.length)
        AnimatedBuilder(
          animation: _caretAnimation,
          builder: (context, child) => Opacity(
            opacity: _caretAnimation.value,
            child: Container(
              width: 2,
              height: (widget.style?.fontSize ?? 16) * 1.2,
              margin: const EdgeInsets.only(left: 2),
              decoration: BoxDecoration(
                color:
                    widget.style?.color ??
                    Theme.of(context).colorScheme.onSurface,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ),
    ],
  );
}
