import 'package:flutter/material.dart';

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

    _typewriterController = AnimationController(
      duration: Duration(
        milliseconds: widget.text.length * widget.speed.inMilliseconds,
      ),
      vsync: this,
    );

    _caretController = AnimationController(
      duration: widget.caretBlinkDuration,
      vsync: this,
    );

    _typewriterAnimation = IntTween(begin: 0, end: widget.text.length).animate(
      CurvedAnimation(parent: _typewriterController, curve: Curves.easeInOut),
    );

    _caretAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _caretController, curve: Curves.easeInOut),
    );

    _typewriterController.addListener(() {
      setState(() {
        _currentLength = _typewriterAnimation.value;
      });
    });

    _caretController.addListener(() {
      setState(() {
        _showCaret = _caretAnimation.value > 0.5;
      });
    });

    // Start the typewriter animation
    _typewriterController.forward();

    // Start the caret blinking
    _caretController.repeat();
  }

  @override
  void dispose() {
    _typewriterController.dispose();
    _caretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        widget.text.substring(0, _currentLength),
        style: widget.style,
        textAlign: widget.textAlign,
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
