import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_config.dart';
import '../models/game_state.dart';

final gameConfigProvider = StateProvider<GameConfig>((ref) {
  return GameConfig.defaultConfig();
});

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((
  ref,
) {
  final config = ref.watch(gameConfigProvider);
  return GameStateNotifier(config.boardSize);
});

class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier(int boardSize) : super(GameState.initial(boardSize));

  void makeMove(int row, int col) {
    if (state.isGameOver || state.boardState[row][col] != null) {
      return;
    }

    final newBoard = List<List<String?>>.from(state.boardState);
    newBoard[row][col] = state.currentPlayer;

    final isGameOver = _checkGameOver(newBoard, row, col);
    final winningLine = isGameOver ? _getWinningLine(newBoard, row, col) : null;
    final nextPlayer = state.currentPlayer == 'X' ? 'O' : 'X';

    state = state.copyWith(
      boardState: newBoard,
      currentPlayer: nextPlayer,
      isGameOver: isGameOver,
      winningLine: winningLine,
      status: isGameOver ? GameStatus.finished : GameStatus.playing,
    );
  }

  void resetGame() {
    state = GameState.initial(state.boardState.length);
  }

  void updateScore(String winner) {
    if (winner == 'X') {
      state = state.copyWith(player1Wins: state.player1Wins + 1);
    } else if (winner == 'O') {
      state = state.copyWith(player2Wins: state.player2Wins + 1);
    } else {
      state = state.copyWith(draws: state.draws + 1);
    }
  }

  bool _checkGameOver(List<List<String?>> board, int row, int col) {
    final boardSize = board.length;
    final mark = board[row][col];

    // Check row
    bool rowWin = true;
    for (int c = 0; c < boardSize; c++) {
      if (board[row][c] != mark) {
        rowWin = false;
        break;
      }
    }
    if (rowWin) return true;

    // Check column
    bool colWin = true;
    for (int r = 0; r < boardSize; r++) {
      if (board[r][col] != mark) {
        colWin = false;
        break;
      }
    }
    if (colWin) return true;

    // Check diagonals if on diagonal
    if (row == col) {
      bool diagWin = true;
      for (int i = 0; i < boardSize; i++) {
        if (board[i][i] != mark) {
          diagWin = false;
          break;
        }
      }
      if (diagWin) return true;
    }

    if (row + col == boardSize - 1) {
      bool diagWin = true;
      for (int i = 0; i < boardSize; i++) {
        if (board[i][boardSize - 1 - i] != mark) {
          diagWin = false;
          break;
        }
      }
      if (diagWin) return true;
    }

    // Check for draw
    for (int r = 0; r < boardSize; r++) {
      for (int c = 0; c < boardSize; c++) {
        if (board[r][c] == null) {
          return false; // Game not over yet
        }
      }
    }
    return true; // Draw
  }

  List<int>? _getWinningLine(List<List<String?>> board, int row, int col) {
    final boardSize = board.length;
    final mark = board[row][col];

    // Check row
    bool rowWin = true;
    for (int c = 0; c < boardSize; c++) {
      if (board[row][c] != mark) {
        rowWin = false;
        break;
      }
    }
    if (rowWin) {
      return List.generate(boardSize, (i) => row * boardSize + i);
    }

    // Check column
    bool colWin = true;
    for (int r = 0; r < boardSize; r++) {
      if (board[r][col] != mark) {
        colWin = false;
        break;
      }
    }
    if (colWin) {
      return List.generate(boardSize, (i) => i * boardSize + col);
    }

    // Check diagonals
    if (row == col) {
      bool diagWin = true;
      for (int i = 0; i < boardSize; i++) {
        if (board[i][i] != mark) {
          diagWin = false;
          break;
        }
      }
      if (diagWin) {
        return List.generate(boardSize, (i) => i * boardSize + i);
      }
    }

    if (row + col == boardSize - 1) {
      bool diagWin = true;
      for (int i = 0; i < boardSize; i++) {
        if (board[i][boardSize - 1 - i] != mark) {
          diagWin = false;
          break;
        }
      }
      if (diagWin) {
        return List.generate(
          boardSize,
          (i) => i * boardSize + (boardSize - 1 - i),
        );
      }
    }

    return null;
  }
}
