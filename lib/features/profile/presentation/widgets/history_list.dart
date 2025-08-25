import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryList extends ConsumerWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace with actual game history data from provider
    final mockHistory = _generateMockHistory();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Game History',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Implement view all history
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (mockHistory.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No games played yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start playing to see your game history here!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
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
              itemCount: mockHistory.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final game = mockHistory[index];
                return _HistoryTile(game: game);
              },
            ),
        ],
      ),
    );
  }

  List<GameHistoryItem> _generateMockHistory() {
    return [
      GameHistoryItem(
        opponent: 'Robot (Hard)',
        result: GameResult.win,
        boardSize: '3x3',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        duration: const Duration(minutes: 5),
        score: '3-0',
      ),
      GameHistoryItem(
        opponent: 'Local Player',
        result: GameResult.loss,
        boardSize: '4x4',
        date: DateTime.now().subtract(const Duration(days: 1)),
        duration: const Duration(minutes: 8),
        score: '2-3',
      ),
      GameHistoryItem(
        opponent: 'Robot (Medium)',
        result: GameResult.draw,
        boardSize: '3x3',
        date: DateTime.now().subtract(const Duration(days: 2)),
        duration: const Duration(minutes: 6),
        score: '1-1',
      ),
      GameHistoryItem(
        opponent: 'Robot (Easy)',
        result: GameResult.win,
        boardSize: '3x3',
        date: DateTime.now().subtract(const Duration(days: 3)),
        duration: const Duration(minutes: 3),
        score: '3-0',
      ),
    ];
  }
}

class GameHistoryItem {
  final String opponent;
  final GameResult result;
  final String boardSize;
  final DateTime date;
  final Duration duration;
  final String score;

  const GameHistoryItem({
    required this.opponent,
    required this.result,
    required this.boardSize,
    required this.date,
    required this.duration,
    required this.score,
  });
}

enum GameResult { win, loss, draw }

class _HistoryTile extends StatelessWidget {
  final GameHistoryItem game;

  const _HistoryTile({required this.game});

  @override
  Widget build(BuildContext context) {
    final resultColor = _getResultColor(game.result);
    final resultIcon = _getResultIcon(game.result);
    final resultText = _getResultText(game.result);

    return Container(
      padding: const EdgeInsets.all(16),
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: resultColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: resultColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(resultIcon, color: resultColor, size: 24),
          ),
          const SizedBox(width: 16),

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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
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
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.grid_on,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      game.boardSize,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.timer,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${game.duration.inMinutes}m',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.score,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      game.score,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(game.date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          // Action Button
          IconButton(
            onPressed: () {
              // TODO: Implement view game details
            },
            icon: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}
