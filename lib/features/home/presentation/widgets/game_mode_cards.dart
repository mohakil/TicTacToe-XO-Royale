import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Game mode card for Local Player and Robot modes
/// Features hover/press states and slight parallax icon movement
class GameModeCard extends StatefulWidget {
  const GameModeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.isRobotMode = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isRobotMode;

  @override
  State<GameModeCard> createState() => _GameModeCardState();
}

class _GameModeCardState extends State<GameModeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _parallaxAnimation;
  late Animation<double> _elevationAnimation;

  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _parallaxAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, -0.5), // 8px movement on hover
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _elevationAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _isPressed ? 0.96 : _scaleAnimation.value,
              child: Card(
                elevation: _elevationAnimation.value,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  height: 120,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.surfaceContainer,
                        colorScheme.surfaceContainer.withValues(alpha: 0.8),
                      ],
                    ),
                    border: Border.all(
                      color: _isHovered
                          ? colorScheme.primary.withValues(alpha: 0.3)
                          : colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.title,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.subtitle,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Transform.translate(
                          offset:
                              _parallaxAnimation.value *
                              8, // 8px parallax movement
                          child: Icon(
                            widget.icon,
                            size: 48,
                            color: widget.isRobotMode
                                ? colorScheme.secondary
                                : colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Container for displaying game mode cards in a responsive grid
class GameModeCards extends StatelessWidget {
  const GameModeCards({
    super.key,
    required this.onLocalModeSelected,
    required this.onRobotModeSelected,
  });

  final VoidCallback onLocalModeSelected;
  final VoidCallback onRobotModeSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive layout: single column on small screens, side by side on larger screens
        if (constraints.maxWidth < 600) {
          return Column(
            children: [
              GameModeCard(
                title: 'Local Player',
                subtitle: 'Play with a friend',
                icon: Icons.groups_2,
                onTap: onLocalModeSelected,
              ),
              const SizedBox(height: 16),
              GameModeCard(
                title: 'Robot',
                subtitle: 'Challenge the computer',
                icon: Icons.smart_toy,
                onTap: onRobotModeSelected,
                isRobotMode: true,
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: GameModeCard(
                  title: 'Local Player',
                  subtitle: 'Play with a friend',
                  icon: Icons.groups_2,
                  onTap: onLocalModeSelected,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GameModeCard(
                  title: 'Robot',
                  subtitle: 'Challenge the computer',
                  icon: Icons.smart_toy,
                  onTap: onRobotModeSelected,
                  isRobotMode: true,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
