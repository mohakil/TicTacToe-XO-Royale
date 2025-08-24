# Advanced Router System for Tic Tac Toe XO Royale

This directory contains a comprehensive, advanced routing system built with GoRouter that provides enterprise-grade navigation capabilities for the Tic Tac Toe XO Royale app.

## 🚀 Features

### Core Features
- **ShellRoute Integration**: Nested navigation with bottom navigation bar
- **Parent Navigator Keys**: Proper navigation hierarchy management
- **Custom Transitions**: Smooth, Material 3-compliant page transitions
- **Deep Linking**: Comprehensive deep link support with validation
- **Route Guards**: Authentication and permission-based route protection
- **Navigation State Management**: Reactive navigation state tracking
- **Error Handling**: Graceful error screens and fallbacks

### Advanced Navigation
- **Named Routes**: Type-safe route navigation
- **Query Parameters**: Dynamic route parameter handling
- **Path Parameters**: RESTful URL structure support
- **Navigation Analytics**: Built-in navigation tracking
- **State Restoration**: App state persistence across sessions

## 📁 File Structure

```
lib/app/router/
├── README.md                    # This documentation
├── router_index.dart           # Main export file
├── router_config.dart          # Comprehensive router configuration
├── advanced_router.dart        # ShellRoute and advanced features
├── deep_linking.dart           # Deep link handling and validation
├── navigation_service.dart     # Enhanced navigation service
├── routes.dart                 # Route constants and utilities
├── route_transitions.dart      # Custom page transitions
└── navigation_helper.dart      # Navigation utility functions
```

## 🔧 Usage

### Basic Navigation

```dart
import 'package:tictactoe_xo_royale/app/router/router_index.dart';

// Navigate to a route
context.go(AppRoutes.home);

// Navigate with parameters
context.go('${AppRoutes.game}?boardSize=3&difficulty=easy');

// Navigate with custom transition
NavigationService.navigateWithTransition(
  context,
  AppRoutes.setup,
  transitionType: PageTransitionType.sharedAxisVertical,
);
```

### Advanced Navigation

```dart
// Navigate to game setup with all parameters
NavigationService.navigateToGameSetup(
  context,
  boardSize: 3,
  winCondition: 3,
  gameMode: 'classic',
  difficulty: 'medium',
  player1: 'Player 1',
  player2: 'Player 2',
  firstMove: 'player1',
);

// Navigate to store with category filter
NavigationService.navigateToStore(
  context,
  category: 'themes',
  itemId: 'dark_theme',
);

// Navigate to profile with user ID
NavigationService.navigateToProfile(
  context,
  userId: 'user123',
  leaderboardId: 'global',
);
```

### Deep Linking

```dart
// Generate shareable links
final gameLink = DeepLinkingConfig.generateShareLink(
  type: 'game',
  id: 'game123',
  additionalParams: {'difficulty': 'hard'},
);

// Handle incoming deep links
final route = DeepLinkingConfig.handleDeepLink(uri);
if (route != null) {
  context.go(route);
}
```

## 🏗️ Architecture

### Router Hierarchy

```
Root Navigator (AdvancedRouter.rootNavigatorKey)
├── Loading Screen (outside shell)
└── Shell Route (AdvancedRouter.shellNavigatorKey)
    ├── Home Screen
    ├── Game Setup Screen
    ├── Game Screen
    ├── Store Screen
    ├── Profile Screen
    └── Settings Screen
```

### Navigation Flow

1. **App Launch**: Routes to `/loading`
2. **Shell Navigation**: Main app navigation with bottom nav
3. **Deep Links**: External links route to appropriate screens
4. **Route Guards**: Authentication and permission checks
5. **State Management**: Navigation state tracking and analytics

## 🎨 Custom Transitions

### Available Transitions

- **Fade**: Smooth opacity transitions for loading/utility screens
- **Shared Axis Horizontal**: Slide transitions for main navigation
- **Shared Axis Vertical**: Slide transitions for game-related navigation
- **Scale**: Interactive transitions for detailed views
- **Hero**: Smooth transitions for related content

### Custom Transition Usage

```dart
CustomTransitionPage(
  key: state.pageKey,
  child: YourScreen(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return AppRouteTransitions.sharedAxisHorizontal(child: child).transitionsBuilder(
      context, animation, secondaryAnimation, child);
  },
),
```

## 🔗 Deep Linking

### Supported Patterns

- `/game/:gameId` - Direct game access
- `/store/:category/:itemId` - Store item details
- `/profile/:userId` - User profiles
- `/challenge/:challengeId` - Game challenges
- `/tournament/:tournamentId` - Tournament access
- `/leaderboard/:boardId` - Leaderboard views
- `/share` - Shareable content links

### URL Schemes

- **App**: `xotictactoe://`
- **Web**: `https://xotictactoe.com/`
- **Store**: Platform-specific app store URLs

### Deep Link Validation

All deep link parameters are validated using regex patterns and business logic:

```dart
// Validate board size
static bool _isValidBoardSize(String boardSize) {
  final size = int.tryParse(boardSize);
  return size != null && size >= 3 && size <= 10;
}

// Validate difficulty level
static bool _isValidDifficulty(String difficulty) {
  final validDifficulties = ['easy', 'medium', 'hard'];
  return validDifficulties.contains(difficulty.toLowerCase());
}
```

## 🛡️ Route Guards

### Authentication Guards

```dart
static bool _requiresAuth(String route) {
  final protectedRoutes = [
    AppRoutes.profile,
    AppRoutes.settings,
  ];
  return protectedRoutes.contains(route);
}
```

### Permission Guards

```dart
static Future<bool> canAccessRoute(
  BuildContext context,
  String route, {
  bool checkAuth = true,
  bool checkPermissions = true,
) async {
  // Add your permission logic here
  return true;
}
```

## 📊 Navigation Analytics

### Built-in Tracking

- Route navigation history
- Navigation timing
- Error tracking
- Deep link usage analytics
- User navigation patterns

### Analytics Service

```dart
NavigationAnalyticsService.instance.logNavigation(
  route: '/game',
  parameters: {'difficulty': 'hard'},
  transitionType: PageTransitionType.sharedAxisVertical,
  duration: Duration(milliseconds: 300),
);
```

## 🔄 State Management

### Navigation State

```dart
class NavigationState {
  final String currentRoute;
  final String? previousRoute;
  final List<String> navigationHistory;
  final DateTime lastNavigationTime;
  final String? lastError;
  final DateTime? lastErrorTime;
  final int totalNavigations;
}
```

### State Providers

- `navigationStateProvider`: Current navigation state
- `routerStateProvider`: Router-specific state
- `deepLinkStateProvider`: Deep link tracking state

## 🧪 Testing

### Route Testing

```dart
test('should navigate to game setup with parameters', () {
  final router = GoRouter(routes: appRoutes);
  
  router.go('/setup?boardSize=3&difficulty=easy');
  
  expect(router.location, contains('boardSize=3'));
  expect(router.location, contains('difficulty=easy'));
});
```

### Deep Link Testing

```dart
test('should handle game deep link', () {
  final uri = Uri.parse('xotictactoe://game/game123');
  final route = DeepLinkingConfig.handleDeepLink(uri);
  
  expect(route, contains('game?gameId=game123'));
});
```

## 🚀 Performance Optimizations

### Caching

- Route parameter caching
- Navigation state persistence
- Deep link resolution caching

### Lazy Loading

- Screen widgets loaded on demand
- Route transitions optimized
- Memory-efficient navigation

## 🔧 Configuration

### Environment Variables

```dart
// Deep link configuration
static const String urlScheme = 'xotictactoe';
static const String webHost = 'xotictactoe.com';

// App store URLs
static const Map<String, String> appStoreUrls = {
  'ios': 'https://apps.apple.com/app/xo-tictactoe-royale/id123456789',
  'android': 'https://play.google.com/store/apps/details?id=com.astrixforge.tictactoe_xo_royale',
  'web': 'https://xotictactoe.com',
};
```

### Customization

All aspects of the router system can be customized:

- Transition durations and curves
- Deep link patterns and validation
- Route guard logic
- Navigation analytics
- Error handling

## 📚 Best Practices

### Route Naming

- Use descriptive, consistent route names
- Group related routes together
- Use query parameters for dynamic content
- Implement proper route validation

### Navigation Patterns

- Always use the NavigationService for complex navigation
- Implement proper error handling
- Use appropriate transitions for different navigation types
- Track navigation analytics for user experience insights

### Deep Linking

- Validate all incoming parameters
- Implement proper fallbacks
- Use semantic URL structures
- Test deep links across platforms

## 🐛 Troubleshooting

### Common Issues

1. **Route Not Found**: Check route definitions and imports
2. **Transition Errors**: Verify transition builder implementations
3. **Deep Link Failures**: Validate URL schemes and patterns
4. **Navigation State Issues**: Check provider configurations

### Debug Mode

Enable debug logging:

```dart
GoRouter(
  debugLogDiagnostics: true,
  // ... other configuration
);
```

## 🤝 Contributing

When adding new features to the router system:

1. Follow the existing architecture patterns
2. Add comprehensive documentation
3. Include proper error handling
4. Add unit tests for new functionality
5. Update this README with new features

## 📄 License

This router system is part of the Tic Tac Toe XO Royale app and follows the same licensing terms.

---

**Note**: This router system is designed to be scalable and maintainable. All features are implemented with best practices and can be easily extended for future requirements.
