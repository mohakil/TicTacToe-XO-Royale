# Flutter TicTacToe XO Royale - Best Practices Guide
## August 2025 Edition

### Table of Contents
1. [State Management with Riverpod](#state-management-with-riverpod)
2. [Navigation with GoRouter](#navigation-with-gorouter)
3. [Code Generation & Immutability](#code-generation--immutability)
4. [UI & Animations](#ui--animations)
5. [Performance Optimization](#performance-optimization)
6. [Testing Strategies](#testing-strategies)
7. [Security Best Practices](#security-best-practices)
8. [Code Quality & Linting](#code-quality--linting)



## 🎯 State Management with Riverpod

### Provider Types & Usage

#### 1. StateNotifierProvider (Recommended for complex state)
```dart
// ✅ GOOD: StateNotifierProvider for game state
@riverpod
class GameNotifier extends _$GameNotifier {
  @override
  GameState build() => const GameState();
  
  void makeMove(int row, int col) {
    if (state.canMakeMove(row, col)) {
      state = state.copyWith(
        board: state.board.makeMove(row, col, state.currentPlayer),
        currentPlayer: state.currentPlayer.next,
      );
    }
  }
  
  void resetGame() {
    state = const GameState();
  }
}

// Usage in UI
class GameScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameNotifierProvider);
    final gameNotifier = ref.read(gameNotifierProvider.notifier);
    
    return Column(
      children: [
        GameBoard(
          board: gameState.board,
          onCellTap: gameNotifier.makeMove,
        ),
        if (gameState.hasWinner)
          WinnerDisplay(player: gameState.winner!),
      ],
    );
  }
}
```

#### 2. FutureProvider (For async operations)
```dart
// ✅ GOOD: FutureProvider for API calls
@riverpod
Future<GameSettings> gameSettings(GameSettingsRef ref) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.getGameSettings();
}

// Usage with loading states
class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(gameSettingsProvider);
    
    return settingsAsync.when(
      data: (settings) => SettingsForm(settings: settings),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => ErrorDisplay(error: error),
    );
  }
}
```

#### 3. StreamProvider (For real-time data)
```dart
// ✅ GOOD: StreamProvider for real-time game updates
@riverpod
Stream<GameUpdate> gameUpdates(GameUpdatesRef ref, String gameId) {
  final gameService = ref.read(gameServiceProvider);
  return gameService.watchGame(gameId);
}
```

### Best Practices for Riverpod

#### 1. Provider Scoping
```dart
// ✅ GOOD: Scope providers to specific features
@riverpod
class GameNotifier extends _$GameNotifier {
  @override
  GameState build() => const GameState();
}

// ✅ GOOD: Use family providers for parameterized data
@riverpod
Future<Game> game(GameRef ref, String gameId) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.getGame(gameId);
}
```

#### 2. Optimizing Rebuilds
```dart
// ✅ GOOD: Use select for granular rebuilds
class GameScore extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.select((GameState state) => state.score);
    
    return Text('Score: $score');
  }
}

// ✅ GOOD: Use ref.listen for side effects
class GameScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(gameNotifierProvider, (previous, next) {
      if (next.hasWinner && !previous.hasWinner) {
        // Show winner celebration
        showWinnerDialog(context, next.winner!);
      }
    });
    
    // ... rest of the widget
  }
}
```

#### 3. Error Handling
```dart
// ✅ GOOD: Proper error handling in providers
@riverpod
Future<GameSettings> gameSettings(GameSettingsRef ref) async {
  try {
    final apiService = ref.read(apiServiceProvider);
    return await apiService.getGameSettings();
  } catch (e, stack) {
    // Log error for debugging
    ref.read(loggerProvider).error('Failed to load game settings', e, stack);
    
    // Return default settings as fallback
    return const GameSettings.defaults();
  }
}
```

---

## 🧭 Navigation with GoRouter

### Route Configuration

#### 1. Type-Safe Routes
```dart
// ✅ GOOD: Type-safe route definitions
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/game/:id',
      name: 'game',
      builder: (context, state) {
        final gameId = state.pathParameters['id']!;
        return GameScreen(gameId: gameId);
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  errorBuilder: (context, state) => ErrorScreen(error: state.error),
);
```

#### 2. Navigation Methods
```dart
// ✅ GOOD: Use GoRouter.of(context) for navigation
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to new game
              context.go('/game/new');
            },
            child: const Text('New Game'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to settings
              context.go('/settings');
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}

// ✅ GOOD: Use push for modal-like navigation
void showGameOverDialog(BuildContext context, Player winner) {
  context.push('/game-over', extra: winner);
}
```

#### 3. Deep Linking Support
```dart
// ✅ GOOD: Support deep linking for game sharing
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/game/:id',
      name: 'game',
      builder: (context, state) {
        final gameId = state.pathParameters['id']!;
        return GameScreen(gameId: gameId);
      },
      redirect: (context, state) {
        // Check if user is authenticated for private games
        final authService = GoRouterState.of(context).extra as AuthService?;
        if (authService?.isAuthenticated == false) {
          return '/login?redirect=${Uri.encodeComponent(state.uri.toString())}';
        }
        return null;
      },
    ),
  ],
);
```

---

## 🔧 Code Generation & Immutability

### Freezed Models

#### 1. Basic Model Structure
```dart
// ✅ GOOD: Immutable game state model
@freezed
class GameState with _$GameState {
  const factory GameState({
    @Default([]) List<Player> players,
    @Default(GameStatus.waiting) GameStatus status,
    @Default(null) Player? winner,
    @Default(0) int currentPlayerIndex,
    @Default([]) List<GameMove> moves,
    @Default(DateTime.now()) DateTime createdAt,
  }) = _GameState;
  
  const GameState._();
  
  // Computed properties
  Player get currentPlayer => players[currentPlayerIndex];
  bool get hasWinner => winner != null;
  bool get isGameOver => hasWinner || status == GameStatus.draw;
  
  // Helper methods
  bool canMakeMove(int row, int col) {
    return status == GameStatus.playing && 
           !moves.any((move) => move.row == row && move.col == col);
  }
}

// ✅ GOOD: Union types for different states
@freezed
class GameResult with _$GameResult {
  const factory GameResult.win(Player winner) = _Win;
  const factory GameResult.draw() = _Draw;
  const factory GameResult.ongoing() = _Ongoing;
}
```

#### 2. JSON Serialization
```dart
// ✅ GOOD: JSON serialization with Freezed
@freezed
class Game with _$Game {
  const factory Game({
    required String id,
    required List<Player> players,
    required GameState state,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Game;
  
  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}

// ✅ GOOD: Custom JSON converters
@freezed
class GameMove with _$GameMove {
  const factory GameMove({
    required int row,
    required int col,
    required Player player,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required DateTime timestamp,
  }) = _GameMove;
  
  factory GameMove.fromJson(Map<String, dynamic> json) => _$GameMoveFromJson(json);
}

DateTime _dateTimeFromJson(String json) => DateTime.parse(json);
String _dateTimeToJson(DateTime dateTime) => dateTime.toIso8601String();
```

### Build Runner Configuration

#### 1. Build Configuration
```yaml
# ✅ GOOD: build.yaml configuration
targets:
  $default:
    builders:
      freezed:
        options:
          union_key: 'type'
          union_value_case: 'snake'
          map: false
          when: false
          copy_with: true
          to_string: true
          equals: true
      
      json_serializable:
        options:
          explicit_to_json: true
          include_if_null: false
          field_rename: snake
      
      riverpod_generator:
        options:
          provider_name_suffix: Provider
```

#### 2. Build Commands
```bash
# ✅ GOOD: Build commands with proper flags
flutter packages pub run build_runner build --delete-conflicting-outputs

# For continuous building during development
flutter packages pub run build_runner watch --delete-conflicting-outputs

# Clean build
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

---

## 🎨 UI & Animations

### Flutter Animate Usage

#### 1. Basic Animations
```dart
// ✅ GOOD: Flutter Animate with proper timing
class AnimatedGameCell extends StatelessWidget {
  final bool isHighlighted;
  final VoidCallback onTap;
  
  const AnimatedGameCell({
    required this.isHighlighted,
    required this.onTap,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container()
        .animate()
        .fadeIn(duration: 300.ms, curve: Curves.easeOut)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 200.ms,
          curve: Curves.elasticOut,
        )
        .animate(target: isHighlighted ? 1 : 0)
        .shimmer(
          duration: 1000.ms,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
    );
  }
}
```

#### 2. Staggered Animations
```dart
// ✅ GOOD: Staggered animations for game board
class AnimatedGameBoard extends StatelessWidget {
  final List<List<GameCell>> board;
  final Function(int, int) onCellTap;
  
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        final row = index ~/ 3;
        final col = index % 3;
        
        return AnimatedGameCell(
          isHighlighted: board[row][col].isHighlighted,
          onTap: () => onCellTap(row, col),
        )
          .animate(delay: (index * 50).ms)
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.3, end: 0);
      },
    );
  }
}
```

### Material Design 3

#### 1. Theme Configuration
```dart
// ✅ GOOD: Material 3 theme configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      typography: Typography.material2021(),
      // Custom theme extensions
      extensions: [
        GameThemeExtension.light,
      ],
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      typography: Typography.material2021(),
      extensions: [
        GameThemeExtension.dark,
      ],
    );
  }
}
```

#### 2. Custom Theme Extensions
```dart
// ✅ GOOD: Custom theme extensions for game-specific styling
class GameThemeExtension extends ThemeExtension<GameThemeExtension> {
  final Color primaryGameColor;
  final Color secondaryGameColor;
  final Color accentGameColor;
  
  const GameThemeExtension({
    required this.primaryGameColor,
    required this.secondaryGameColor,
    required this.accentGameColor,
  });
  
  static const light = GameThemeExtension(
    primaryGameColor: Color(0xFF2196F3),
    secondaryGameColor: Color(0xFF03DAC6),
    accentGameColor: Color(0xFFFF4081),
  );
  
  static const dark = GameThemeExtension(
    primaryGameColor: Color(0xFF90CAF9),
    secondaryGameColor: Color(0xFF80DEEA),
    accentGameColor: Color(0xFFFF80AB),
  );
  
  @override
  ThemeExtension<GameThemeExtension> copyWith({
    Color? primaryGameColor,
    Color? secondaryGameColor,
    Color? accentGameColor,
  }) {
    return GameThemeExtension(
      primaryGameColor: primaryGameColor ?? this.primaryGameColor,
      secondaryGameColor: secondaryGameColor ?? this.secondaryGameColor,
      accentGameColor: accentGameColor ?? this.accentGameColor,
    );
  }
  
  @override
  ThemeExtension<GameThemeExtension> lerp(
    covariant ThemeExtension<GameThemeExtension>? other,
    double t,
  ) {
    if (other is! GameThemeExtension) {
      return this;
    }
    
    return GameThemeExtension(
      primaryGameColor: Color.lerp(primaryGameColor, other.primaryGameColor, t)!,
      secondaryGameColor: Color.lerp(secondaryGameColor, other.secondaryGameColor, t)!,
      accentGameColor: Color.lerp(accentGameColor, other.accentGameColor, t)!,
    );
  }
}
```

---

## ⚡ Performance Optimization

### Widget Optimization

#### 1. const Constructors
```dart
// ✅ GOOD: Use const constructors where possible
class GameCell extends StatelessWidget {
  const GameCell({
    required this.value,
    required this.onTap,
    super.key,
  });
  
  final GameCellValue value;
  final VoidCallback onTap;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: _buildCellContent(),
        ),
      ),
    );
  }
  
  Widget _buildCellContent() {
    switch (value) {
      case GameCellValue.x:
        return const Icon(Icons.close, size: 32);
      case GameCellValue.o:
        return const Icon(Icons.circle_outlined, size: 32);
      case GameCellValue.empty:
        return const SizedBox.shrink();
    }
  }
}
```

#### 2. RepaintBoundary
```dart
// ✅ GOOD: Use RepaintBoundary for expensive widgets
class GameBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GridView.builder(
        // ... grid configuration
        itemBuilder: (context, index) {
          return GameCell(
            value: board[index ~/ 3][index % 3],
            onTap: () => onCellTap(index ~/ 3, index % 3),
          );
        },
      ),
    );
  }
}
```

### State Management Optimization

#### 1. Provider Scoping
```dart
// ✅ GOOD: Scope providers to minimize rebuilds
class GameScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          // Only rebuilds when score changes
          Consumer(
            builder: (context, ref, child) {
              final score = ref.watch(gameScoreProvider);
              return ScoreDisplay(score: score);
            },
          ),
          // Only rebuilds when board changes
          Consumer(
            builder: (context, ref, child) {
              final board = ref.watch(gameBoardProvider);
              return GameBoard(board: board);
            },
          ),
        ],
      ),
    );
  }
}
```

#### 2. Select Optimization
```dart
// ✅ GOOD: Use select for granular rebuilds
class GameStatus extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.select((GameState state) => state.status);
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        status.displayText,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
```

---

## 🧪 Testing Strategies

### Unit Testing

#### 1. Provider Testing
```dart
// ✅ GOOD: Test providers with proper setup
void main() {
  group('GameNotifier', () {
    late ProviderContainer container;
    
    setUp(() {
      container = ProviderContainer();
    });
    
    tearDown(() {
      container.dispose();
    });
    
    test('should start with initial state', () {
      final gameState = container.read(gameNotifierProvider);
      
      expect(gameState.status, GameStatus.waiting);
      expect(gameState.players, isEmpty);
      expect(gameState.winner, isNull);
    });
    
    test('should add player when joining game', () {
      final notifier = container.read(gameNotifierProvider.notifier);
      final player = Player(id: '1', name: 'Player 1');
      
      notifier.addPlayer(player);
      
      final gameState = container.read(gameNotifierProvider);
      expect(gameState.players, contains(player));
    });
    
    test('should start game when two players join', () {
      final notifier = container.read(gameNotifierProvider.notifier);
      final player1 = Player(id: '1', name: 'Player 1');
      final player2 = Player(id: '2', name: 'Player 2');
      
      notifier.addPlayer(player1);
      notifier.addPlayer(player2);
      
      final gameState = container.read(gameNotifierProvider);
      expect(gameState.status, GameStatus.playing);
      expect(gameState.players, hasLength(2));
    });
  });
}
```

#### 2. Model Testing
```dart
// ✅ GOOD: Test Freezed models
void main() {
  group('GameState', () {
    test('should create initial state', () {
      const state = GameState();
      
      expect(state.players, isEmpty);
      expect(state.status, GameStatus.waiting);
      expect(state.winner, isNull);
    });
    
    test('should copy with new values', () {
      const initialState = GameState();
      final updatedState = initialState.copyWith(
        status: GameStatus.playing,
        players: [const Player(id: '1', name: 'Player 1')],
      );
      
      expect(updatedState.status, GameStatus.playing);
      expect(updatedState.players, hasLength(1));
      expect(updatedState.winner, isNull); // Unchanged
    });
    
    test('should compute current player correctly', () {
      const state = GameState(
        players: [
          Player(id: '1', name: 'Player 1'),
          Player(id: '2', name: 'Player 2'),
        ],
        currentPlayerIndex: 1,
      );
      
      expect(state.currentPlayer.id, '2');
    });
  });
}
```

### Widget Testing

#### 1. Basic Widget Tests
```dart
// ✅ GOOD: Test widgets with proper setup
void main() {
  group('GameCell', () {
    testWidgets('should display X when value is X', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GameCell(
            value: GameCellValue.x,
            onTap: () {},
          ),
        ),
      );
      
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
    
    testWidgets('should call onTap when tapped', (tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: GameCell(
            value: GameCellValue.empty,
            onTap: () => tapped = true,
          ),
        ),
      );
      
      await tester.tap(find.byType(GameCell));
      
      expect(tapped, isTrue);
    });
  });
}
```

#### 2. Integration Testing
```dart
// ✅ GOOD: Test complete game flow
void main() {
  group('Game Flow', () {
    testWidgets('should complete full game cycle', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: GameScreen(),
          ),
        ),
      );
      
      // Start new game
      await tester.tap(find.text('New Game'));
      await tester.pumpAndSettle();
      
      // Make moves
      await tester.tap(find.byType(GameCell).first);
      await tester.pumpAndSettle();
      
      // Verify game state
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });
}
```

---

## 🔒 Security Best Practices

### Data Storage

#### 1. Secure Storage for Sensitive Data
```dart
// ✅ GOOD: Use flutter_secure_storage for sensitive data
class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  
  static Future<void> saveAuthToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
  
  static Future<String?> getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }
  
  static Future<void> clearAuthToken() async {
    await _storage.delete(key: 'auth_token');
  }
}

// ❌ AVOID: Don't store sensitive data in SharedPreferences
// SharedPreferences.getInstance().then((prefs) {
//   prefs.setString('auth_token', token); // Not secure!
// });
```

#### 2. Input Validation
```dart
// ✅ GOOD: Validate all user inputs
class InputValidator {
  static String? validatePlayerName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Player name cannot be empty';
    }
    
    if (name.trim().length < 2) {
      return 'Player name must be at least 2 characters';
    }
    
    if (name.trim().length > 20) {
      return 'Player name cannot exceed 20 characters';
    }
    
    // Check for invalid characters
    if (!RegExp(r'^[a-zA-Z0-9\s\-_]+$').hasMatch(name.trim())) {
      return 'Player name contains invalid characters';
    }
    
    return null;
  }
  
  static String? validateGameId(String? gameId) {
    if (gameId == null || gameId.trim().isEmpty) {
      return 'Game ID cannot be empty';
    }
    
    if (!RegExp(r'^[a-zA-Z0-9\-_]{8,32}$').hasMatch(gameId.trim())) {
      return 'Invalid game ID format';
    }
    
    return null;
  }
}
```

### Network Security

#### 1. HTTPS Enforcement
```dart
// ✅ GOOD: Enforce HTTPS for all network requests
class ApiService {
  static const String _baseUrl = 'https://api.gameserver.com';
  
  Future<Game> createGame(CreateGameRequest request) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/games'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await _getAuthToken()}',
      },
      body: jsonEncode(request.toJson()),
    );
    
    if (response.statusCode == 200) {
      return Game.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException('Failed to create game: ${response.statusCode}');
    }
  }
}
```

#### 2. Certificate Pinning (Advanced)
```dart
// ✅ GOOD: Certificate pinning for enhanced security
class SecureHttpClient {
  static http.Client createSecureClient() {
    return http.Client();
    // Note: For production apps, consider using certificate pinning
    // with packages like 'certificate_pinning' or custom implementations
  }
}
```

---

## 📏 Code Quality & Linting

### Linting Configuration

#### 1. Analysis Options
```yaml
# ✅ GOOD: analysis_options.yaml with strict rules
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.config.dart"
  
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
  
  errors:
    invalid_annotation_target: ignore

linter:
  rules:
    # Code style
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    prefer_const_declarations: true
    avoid_print: true
    avoid_unnecessary_containers: true
    
    # Performance
    prefer_single_quotes: true
    prefer_final_fields: true
    prefer_final_locals: true
    
    # Error prevention
    avoid_null_checks_in_equality_operators: true
    avoid_relative_lib_imports: true
    avoid_returning_null_for_future: true
    
    # Documentation
    public_member_api_docs: false
    package_api_docs: false
```

#### 2. Custom Lint Rules
```dart
// ✅ GOOD: Custom lint rules for project-specific requirements
class GameStateLintRule extends DartLintRule {
  const GameStateLintRule() : super(code: _code);
  
  static const _code = LintCode(
    name: 'game_state_immutable',
    problemMessage: 'Game state classes must be immutable',
    errorSeverity: ErrorSeverity.ERROR,
  );
  
  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      if (node.name?.lexeme.contains('GameState') == true) {
        // Check if class is properly annotated with @freezed
        final hasFreezedAnnotation = node.metadata.any(
          (metadata) => metadata.name.name == 'freezed',
        );
        
        if (!hasFreezedAnnotation) {
          reporter.reportErrorForNode(_code, node);
        }
      }
    });
  }
}
```

### Code Review Checklist

#### 1. Architecture Review
- [ ] Does the code follow the established project structure?
- [ ] Are dependencies properly injected through Riverpod?
- [ ] Is the separation of concerns maintained?
- [ ] Are models immutable and properly serialized?

#### 2. Performance Review
- [ ] Are const constructors used where possible?
- [ ] Are RepaintBoundary widgets used for expensive operations?
- [ ] Are providers properly scoped to minimize rebuilds?
- [ ] Is the select method used for granular rebuilds?

#### 3. Security Review
- [ ] Are all user inputs properly validated?
- [ ] Is sensitive data stored securely?
- [ ] Are network requests made over HTTPS?
- [ ] Are authentication tokens handled securely?

#### 4. Testing Review
- [ ] Are all new features covered by tests?
- [ ] Are edge cases properly tested?
- [ ] Are integration tests included for critical flows?
- [ ] Is test coverage maintained above 80%?

---

## 📚 Additional Resources

### Official Documentation
- [Flutter Best Practices](https://docs.flutter.dev/development/ui/layout/best-practices)
- [Riverpod Best Practices](https://riverpod.dev/docs/concepts/best_practices)
- [GoRouter Best Practices](https://pub.dev/documentation/go_router/latest/topics/Configuration-topic.html)
- [Freezed Best Practices](https://pub.dev/documentation/freezed)

### Community Resources
- [Flutter Community](https://fluttercommunity.dev/)
- [Riverpod Discord](https://discord.gg/riverpod)
- [Flutter Dev Reddit](https://reddit.com/r/FlutterDev)

### Tools & Extensions
- [Flutter Inspector](https://docs.flutter.dev/development/tools/devtools/inspector)
- [Flutter Performance](https://docs.flutter.dev/development/tools/devtools/performance)
- [Flutter Memory](https://docs.flutter.dev/development/tools/devtools/memory)

---

## 🎯 Conclusion

This best practices guide provides a comprehensive foundation for building high-quality, maintainable Flutter applications. Key takeaways:

1. **Follow established patterns**: Use Riverpod for state management, GoRouter for navigation, and Freezed for immutability
2. **Optimize for performance**: Use const constructors, RepaintBoundary, and proper provider scoping
3. **Maintain security**: Validate inputs, use secure storage, and enforce HTTPS
4. **Write comprehensive tests**: Cover unit, widget, and integration testing
5. **Enforce code quality**: Use strict linting rules and maintain consistent code style

Remember that best practices evolve over time, so stay updated with the latest Flutter releases and community recommendations.

---

*Guide last updated: August 2025*  
*Next review: September 2025*
