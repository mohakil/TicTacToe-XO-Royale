import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';
import 'package:tictactoe_xo_royale/core/models/game_history.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';
import 'package:tictactoe_xo_royale/shared/widgets/icons/icon_text.dart';

class HistoryList extends ConsumerStatefulWidget {
  const HistoryList({super.key});

  @override
  ConsumerState<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends ConsumerState<HistoryList> {
  bool _showAllHistory = false;

  @override
  Widget build(BuildContext context) {
    // Use the reactive stream from profile provider for automatic updates
    final gameHistoryStream = ref
        .watch(profileProvider.notifier)
        .gameHistoryStream;

    return StreamBuilder<List<GameHistoryItem>>(
      stream: gameHistoryStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading game history: ${snapshot.error}'),
          );
        }

        final gameHistory = snapshot.data ?? [];
        final displayHistory = _showAllHistory
            ? gameHistory
            : gameHistory.take(3).toList();

        return Container(
          margin: context.getResponsivePadding(
            phonePadding: 12.0,
            tabletPadding: 16.0,
          ),
          padding: context.getResponsivePadding(
            phonePadding: 16.0,
            tabletPadding: 20.0,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconText(
                    icon: Icons.history,
                    text: 'Game History',
                    iconColor: Theme.of(context).colorScheme.primary,
                    textStyle: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                    size: IconTextSize.large,
                    direction: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showAllHistory = !_showAllHistory;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: context.getResponsivePadding(
                        phonePadding: 8.0,
                        tabletPadding: 12.0,
                      ),
                    ),
                    child: Text(
                      _showAllHistory ? 'Show Less' : 'View All',
                      style: context.getResponsiveTextStyle(
                        const TextStyle(),
                        phoneSize: 12.0,
                        tabletSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: context.getResponsiveSpacing(
                  phoneSpacing: 18.0,
                  tabletSpacing: 20.0,
                ),
              ),

              if (gameHistory.isEmpty)
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.history,
                        size: context.getResponsiveIconSize(
                          phoneSize: 48.0,
                          tabletSize: 64.0,
                        ),
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                      SizedBox(
                        height: context.getResponsiveSpacing(
                          phoneSpacing: 12.0,
                          tabletSpacing: 16.0,
                        ),
                      ),
                      Text(
                        'No games played yet',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: context.isPhone ? 16.0 : null,
                            ),
                      ),
                      SizedBox(
                        height: context.getResponsiveSpacing(
                          phoneSpacing: 6.0,
                          tabletSpacing: 8.0,
                        ),
                      ),
                      Text(
                        'Start playing to see your game history here!',
                        style: context.getResponsiveTextStyle(
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant
                                    .withValues(alpha: 0.7),
                              ) ??
                              const TextStyle(),
                          phoneSize: 12.0,
                          tabletSize: 14.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayHistory.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: context.getResponsiveSpacing(
                      phoneSpacing: 8.0,
                      tabletSpacing: 12.0,
                    ),
                  ),
                  itemBuilder: (context, index) {
                    final game = displayHistory[index];
                    return _HistoryTile(
                      key: ValueKey<String>(
                        'history_${game.date.millisecondsSinceEpoch}_${game.opponent}',
                      ),
                      game: game,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final GameHistoryItem game;

  const _HistoryTile({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final resultColor = _getResultColor(game.result);
    final resultIcon = _getResultIcon(game.result);
    final resultText = _getResultText(game.result);

    // Use responsive system instead of parameter
    final padding = context.getResponsiveSpacing(
      phoneSpacing: 12.0,
      tabletSpacing: 16.0,
    );
    final iconSize = context.getResponsiveIconSize(
      phoneSize: 20.0,
      tabletSize: 24.0,
    );
    final spacing = context.getResponsiveSpacing(
      phoneSpacing: 8.0,
      tabletSpacing: 16.0,
    );
    final smallSpacing = context.getResponsiveSpacing(
      phoneSpacing: 4.0,
      tabletSpacing: 8.0,
    );

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          // Result Icon
          Container(
            padding: context.getResponsivePadding(
              phonePadding: 8.0,
              tabletPadding: 12.0,
            ),
            decoration: BoxDecoration(
              color: resultColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: resultColor.withValues(alpha: 0.3)),
            ),
            child: Icon(resultIcon, color: resultColor, size: iconSize),
          ),
          SizedBox(width: spacing),

          // Game Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        game.opponent,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.getResponsiveSpacing(
                          phoneSpacing: 6.0,
                          tabletSpacing: 8.0,
                        ),
                        vertical: context.getResponsiveSpacing(
                          phoneSpacing: 2.0,
                          tabletSpacing: 4.0,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: resultColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        resultText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: resultColor,
                          fontWeight: FontWeight.w600,
                          fontSize: context.isPhone ? 10.0 : null,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: smallSpacing),
                // Simplified layout without time information
                Row(
                  children: [
                    IconText(
                      icon: Icons.grid_on,
                      text: game.boardSize,
                      iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
                      textStyle: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                      size: IconTextSize.small,
                      direction: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    SizedBox(width: spacing),
                    IconText(
                      icon: Icons.score,
                      text: game.score,
                      iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
                      textStyle: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                      size: IconTextSize.small,
                      direction: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Button
          IconButton(
            onPressed: () {
              // TODO(Implement view game details)
            },
            icon: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            iconSize: context.getResponsiveIconSize(
              phoneSize: 20.0,
              tabletSize: 24.0,
            ),
            padding: context.getResponsivePadding(
              phonePadding: 6.0,
              tabletPadding: 8.0,
            ),
            constraints: BoxConstraints(
              minWidth: context.scale(32.0),
              minHeight: context.scale(40.0),
            ),
          ),
        ],
      ),
    );
  }

  Color _getResultColor(GameResult result) {
    switch (result) {
      case GameResult.win:
        return Colors.green;
      case GameResult.loss:
        return Colors.red;
      case GameResult.draw:
        return Colors.orange;
    }
  }

  IconData _getResultIcon(GameResult result) {
    switch (result) {
      case GameResult.win:
        return Icons.emoji_events;
      case GameResult.loss:
        return Icons.close;
      case GameResult.draw:
        return Icons.remove;
    }
  }

  String _getResultText(GameResult result) {
    switch (result) {
      case GameResult.win:
        return 'WIN';
      case GameResult.loss:
        return 'LOSS';
      case GameResult.draw:
        return 'DRAW';
    }
  }
}
