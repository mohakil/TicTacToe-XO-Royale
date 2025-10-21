# Shared Components Documentation

This directory contains reusable UI components and utilities that eliminate duplication across the TicTacToe XO Royale application while maintaining visual consistency, performance, and comprehensive responsive design.

## 📁 Directory Structure

```
lib/shared/
├── widgets/
│   ├── cards/
│   │   ├── enhanced_card.dart          # EnhancedCard: elevated, outlined, filled, gradient variants
│   │   └── animated_card.dart          # AnimatedCard: hover/press animations with player colors
│   ├── buttons/
│   │   ├── enhanced_button.dart        # EnhancedButton: primary, secondary, outline, ghost variants
│   │   ├── icon_action_button.dart     # IconActionButton: responsive icon sizing and theme integration
│   │   ├── category_tab.dart           # CategoryTab: filled, outlined, tonal variants with animations
│   │   └── ad_watch_button.dart        # AdWatchButton: countdown timers, loading states, cooldown logic
│   ├── feedback/
│   │   ├── state_display.dart          # StateDisplay: loading, empty, error variants with retry actions
│   │   ├── confirmation_dialog.dart    # ConfirmationDialog: consistent dialog patterns
│   │   ├── currency_display.dart       # CurrencyDisplay: compact, prominent, large variants
│   │   └── progress_animation.dart     # ProgressAnimation: linear, circular, dots, wave variants
│   ├── forms/
│   │   └── form_input.dart             # FormInput: text input with validation, keyboard types, responsive sizing
│   ├── icons/
│   │   ├── icon_text.dart              # IconText: Icon + text combinations for consistent layouts
│   │   ├── icon_toggle.dart            # IconToggle: Animated toggleable icons for state switching
│   │   ├── icon_badge.dart             # IconBadge: Icons with notification badges
│   │   └── icon_avatar.dart            # IconAvatar: Circular avatar icons for profiles/achievements
│   ├── layout/
│   │   ├── positioned_layout.dart      # PositionedLayout: responsive positioning logic for game boards
│   │   └── animated_section.dart       # AnimatedSection: smooth content transitions with animation pooling
│   └── navigation/
│       └── app_bar.dart                # SharedAppBar: responsive navigation bar with automatic status bar color matching
└── mixins/
    └── responsive_mixins.dart           # 244+ responsive extension methods
```

## 🏗️ Widget Development Standards

### File Naming Conventions

**Widget Files**: Use `snake_case.dart` naming that clearly describes the widget's purpose:
- `enhanced_card.dart` - Main card component with multiple variants
- `animated_card.dart` - Card with hover/press animations
- `enhanced_button.dart` - Standardized button component
- `icon_action_button.dart` - Icon button with consistent styling
- `state_display.dart` - Loading, empty, and error state displays
- `positioned_layout.dart` - Responsive positioning wrapper
- `confirmation_dialog.dart` - Consistent confirmation dialogs

**Index Files**: Use `index.dart` for barrel exports in each category

### Class Naming Conventions

**Widget Classes**: Use `PascalCase` with descriptive names:
- `EnhancedCard` - Main card component
- `AnimatedCard` - Interactive card with animations
- `EnhancedButton` - Standardized button widget
- `IconActionButton` - Icon button component
- `StateDisplay` - State display component
- `PositionedLayout` - Layout positioning widget
- `ConfirmationDialog` - Dialog component

**Enum Types**: Use `PascalCase` for enum names and values:
```dart
enum CardVariant {
  elevated,
  outlined,
  filled,
  gradient,
}

enum ButtonSize {
  small,
  medium,
  large,
}
```

### Documentation Standards

**Widget Documentation**: Every public widget class must have:
```dart
/// A reusable card component that consolidates styling patterns across features.
///
/// Provides consistent card styling with multiple variants and responsive behavior.
/// Supports interactive cards with hover/press animations and haptic feedback.
///
/// **Usage:**
/// ```dart
/// EnhancedCard(
///   variant: CardVariant.elevated,
///   child: Text('Card content'),
///   onTap: () => print('Card tapped'),
/// )
/// ```
class EnhancedCard extends StatelessWidget {
  // ... implementation
}
```

**Parameter Documentation**: Document all public parameters:
```dart
/// The variant of card to display.
final CardVariant variant;

/// Callback when the card is tapped (only for interactive cards).
final VoidCallback? onTap;
```

**Example Usage**: Include practical usage examples in doc comments.

## 🔧 Implementation Guidelines

### Responsive Integration

All shared widgets must integrate with the existing responsive system:

```dart
// Use responsive extensions for sizing
child: Container(
  width: context.getResponsiveSpacing(phoneSpacing: 200.0, tabletSpacing: 300.0),
  padding: EdgeInsets.all(context.getResponsiveSpacing(phoneSpacing: 16.0, tabletSpacing: 24.0)),
)
```

### Performance Optimization

**RepaintBoundary**: Use for complex widgets with animations:
```dart
class AnimatedCard extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        // ... animation logic
      ),
    );
  }
}
```

**Animation Pooling**: Integrate with existing animation pooling for performance:
```dart
// Use AnimationPool for controller management
_animationController = AnimationPool.of(context).createController();
```

### Theme Integration

**Material 3 Compliance**: Use theme colors and typography:
```dart
color: Theme.of(context).colorScheme.primary,
style: Theme.of(context).textTheme.titleMedium,
```

**Dynamic Color Support**: Support Material 3 dynamic color schemes.

### Accessibility Standards

**48dp Touch Targets**: Ensure minimum touch target sizes:
```dart
// Use responsive sizing to maintain 48dp minimum
child: Container(
  constraints: BoxConstraints(
    minWidth: context.getResponsiveSpacing(phoneSpacing: 48.0, tabletSpacing: 48.0),
    minHeight: context.getResponsiveSpacing(phoneSpacing: 48.0, tabletSpacing: 48.0),
  ),
)
```

**Semantic Labels**: Provide proper semantics:
```dart
return Semantics(
  label: 'Card with title',
  child: EnhancedCard(
    // ... implementation
  ),
);
```

**Screen Reader Support**: Include value announcements for state changes.

## 🧪 Testing Requirements

### Unit Tests
Every widget must have comprehensive unit tests covering:
- All variants and configurations
- Responsive behavior across breakpoints
- Accessibility features
- Performance characteristics

### Widget Tests
```dart
testWidgets('EnhancedCard displays correctly', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: EnhancedCard(
          variant: CardVariant.elevated,
          child: Text('Test Card'),
        ),
      ),
    ),
  );

  expect(find.text('Test Card'), findsOneWidget);
  expect(find.byType(Card), findsOneWidget);
});
```

### Responsive Tests
```dart
testWidgets('EnhancedCard adapts to different screen sizes', (WidgetTester tester) async {
  // Test phone breakpoint
  tester.binding.window.physicalSizeTestValue = Size(375, 667);
  await tester.pumpWidget(/* phone layout */);

  // Test tablet breakpoint
  tester.binding.window.physicalSizeTestValue = Size(768, 1024);
  await tester.pumpWidget(/* tablet layout */);
});
```

## 📦 Import Strategy

### 🔧 Individual Component Imports (Recommended)
```dart
// Import specific components directly for better tree shaking and explicit dependencies
import 'package:tictactoe_xo_royale/shared/widgets/cards/enhanced_card.dart';
import 'package:tictactoe_xo_royale/shared/widgets/buttons/enhanced_button.dart';
import 'package:tictactoe_xo_royale/shared/widgets/feedback/state_display.dart';
import 'package:tictactoe_xo_royale/shared/widgets/forms/form_input.dart';
import 'package:tictactoe_xo_royale/shared/widgets/layout/positioned_layout.dart';
import 'package:tictactoe_xo_royale/shared/widgets/navigation/app_bar.dart';
import 'package:tictactoe_xo_royale/shared/mixins/responsive_mixins.dart';

// Usage - explicit access to specific components
EnhancedCard(...)         // Card component
EnhancedButton(...)       // Button component
IconText(...)            // Icon + text component
IconToggle(...)          // Animated toggleable icon
IconBadge(...)           // Icon with badge
IconAvatar(...)          // Circular avatar icon
StateDisplay(...)         // Feedback component
FormInput(...)           // Form component
PositionedLayout(...)    // Layout component
SharedAppBar(...)        // Navigation component
// 244+ responsive methods available via mixin extensions
```

### 📂 Multiple Component Imports (For Feature-Specific Use)
```dart
// Import multiple related components for feature-specific use cases
import 'package:tictactoe_xo_royale/shared/widgets/cards/enhanced_card.dart';
import 'package:tictactoe_xo_royale/shared/widgets/cards/animated_card.dart';
import 'package:tictactoe_xo_royale/shared/widgets/buttons/enhanced_button.dart';
import 'package:tictactoe_xo_royale/shared/widgets/buttons/icon_action_button.dart';
import 'package:tictactoe_xo_royale/shared/widgets/icons/icon_text.dart';
import 'package:tictactoe_xo_royale/shared/widgets/icons/icon_toggle.dart';

// Usage - explicit access to specific components
EnhancedCard(...)         // Card component
AnimatedCard(...)         // Animated card component
EnhancedButton(...)       // Button component
IconActionButton(...)     // Icon button component
IconText(...)            // Icon + text component
IconToggle(...)          // Animated toggleable icon
```

### 🎯 Responsive Mixins (Always Available)
```dart
// Responsive mixins are available via extensions on BuildContext
import 'package:tictactoe_xo_royale/shared/mixins/responsive_mixins.dart';

// Usage - responsive extensions available on BuildContext
context.getResponsiveSpacing(phoneSpacing: 16.0, tabletSpacing: 24.0)
context.getResponsiveTextStyle(Theme.of(context).textTheme.titleLarge, phoneSize: 18.0, tabletSize: 22.0)
```

## 🚀 Migration Guidelines

When migrating existing widgets to shared components:

1. **Analyze Current Implementation**: Review existing patterns and identify reusable components
2. **Map to Shared Widgets**: Identify which shared widget best fits the current implementation
3. **Preserve Visual Consistency**: Ensure 100% visual consistency with existing design
4. **Update Imports**: Replace feature-specific imports with shared widget imports
5. **Test Thoroughly**: Validate responsive behavior, accessibility, and performance
6. **Remove Duplicate Code**: Clean up original implementations after migration

### Migration Best Practices

**Step-by-Step Migration Process:**

1. **Identify Duplication**: Search for similar UI patterns across features
2. **Create Shared Component**: Build reusable component with rich API
3. **Gradual Migration**: Replace one feature at a time with comprehensive testing
4. **Visual Validation**: Ensure 100% visual consistency across all breakpoints
5. **Performance Validation**: Confirm no regressions in frame rates or memory usage
6. **Cleanup**: Remove original implementations after successful migration

**Import Migration Pattern:**

```dart
// ❌ Before: Barrel export imports (no longer available)
import 'package:tictactoe_xo_royale/shared/widgets/cards/cards.dart';
import 'package:tictactoe_xo_royale/shared/widgets/buttons/buttons.dart';

// ✅ After: Individual component imports
import 'package:tictactoe_xo_royale/shared/widgets/cards/enhanced_card.dart';
import 'package:tictactoe_xo_royale/shared/widgets/buttons/enhanced_button.dart';
import 'package:tictactoe_xo_royale/shared/widgets/icons/icon_text.dart';
import 'package:tictactoe_xo_royale/shared/widgets/icons/icon_toggle.dart';
```

**Testing Migration Strategy:**

1. **Unit Tests**: Validate component functionality in isolation
2. **Responsive Tests**: Ensure consistent behavior across breakpoints
3. **Integration Tests**: Test component interactions within feature contexts
4. **Performance Tests**: Verify frame rates and memory usage remain optimal
5. **Accessibility Tests**: Confirm ARIA compliance and touch target sizes

**Migration Success Metrics:**

- **60-70% Code Reduction**: Elimination of duplicate UI patterns
- **100% Visual Consistency**: Zero regressions across all breakpoints
- **<10% Performance Overhead**: Maintained responsive calculation efficiency
- **Zero Breaking Changes**: All existing APIs preserved during migration

## 📋 Component Checklist

Before submitting a new shared component:

- [x] **File Naming**: Uses descriptive `snake_case.dart` naming ✅
- [x] **Comprehensive Documentation**: Complete doc comments with usage examples ✅
- [x] **Responsive Integration**: Uses responsive extensions properly ✅
- [x] **Theme Integration**: Follows Material 3 color and typography ✅
- [x] **Accessibility**: Meets 48dp touch targets and semantic requirements ✅
- [x] **Performance**: Uses RepaintBoundary and animation pooling where appropriate ✅
- [x] **Testing**: Comprehensive unit and responsive tests ✅
- [x] **Barrel Export**: Added to appropriate category export file ✅
- [x] **Linting**: Passes all Flutter analyze checks ✅

## 🎯 Component Categories

### 📱 **Cards** (`shared/widgets/cards/cards.dart`)
- **EnhancedCard**: Main card component (elevated, outlined, filled, gradient)
- **AnimatedCard**: Interactive card with hover/press animations

### 🔘 **Buttons** (`shared/widgets/buttons/buttons.dart`)
- **EnhancedButton**: Main button (primary, secondary, outline, ghost)
- **IconActionButton**: Icon-based action button
- **CategoryTab**: Animated pill-shaped tab selector
- **AdWatchButton**: Complex ad watching component

### 🎯 **Icons** (`shared/widgets/icons/icons.dart`)
- **IconText**: Icon + text combinations for consistent layouts (15+ current uses)
- **IconToggle**: Animated toggleable icons for state switching (theme/boolean toggles)
- **IconBadge**: Icons with notification badges for counts/status indicators
- **IconAvatar**: Circular avatar icons for profiles/achievements

### 💬 **Feedback** (`shared/widgets/feedback/feedback.dart`)
- **StateDisplay**: Loading, empty, and error state displays
- **ConfirmationDialog**: Standardized confirmation dialogs
- **CurrencyDisplay**: Gem balance display (compact, prominent, large)
- **ProgressAnimation**: Animated progress indicators

### 📝 **Forms** (`shared/widgets/forms/forms.dart`)
- **FormInput**: Comprehensive form input with validation

### 📐 **Layout** (`shared/widgets/layout/layout.dart`)
- **PositionedLayout**: Responsive positioning logic abstraction
- **AnimatedSection**: Fade and slide animation patterns
- **Section Styling**: Consistent section organization with responsive typography

### 🧭 **Navigation** (`shared/widgets/navigation/navigation.dart`)
- **SharedAppBar**: Consistent navigation bar with responsive sizing and automatic status bar color matching

## 🔄 Maintenance

**Version Control**: Track changes to shared components carefully as they affect multiple features
**Breaking Changes**: Avoid breaking changes; use deprecation warnings when necessary
**Performance Monitoring**: Monitor frame timing and memory usage after changes
**Accessibility Auditing**: Regular accessibility testing across all breakpoints

## 📚 Documentation Features

Every export file now includes comprehensive documentation:

- **📖 Component Overviews**: Detailed descriptions of each component's purpose and features
- **💡 Usage Examples**: Practical code examples showing how to use each component
- **🎨 Design Philosophy**: Explanation of consistency principles and responsive behavior
- **⚡ Performance Notes**: Information about optimization techniques and best practices
- **🔧 Technical Details**: Implementation details and integration requirements

### Example Documentation Structure:
```dart
/// ============================================================================
/// COMPONENT NAME - DETAILED DESCRIPTION
/// ============================================================================
///
/// Comprehensive description of the component's purpose, features, and
/// integration requirements across the TicTacToe XO Royale application.
///
/// **Components:**
/// - **ComponentName**: Main component description
///   - Feature 1: Detailed feature explanation
///   - Feature 2: Additional capability description
///   - Responsive behavior and theme integration
///
/// **Usage:**
/// ```dart
/// import 'package:tictactoe_xo_royale/shared/widgets/component/component.dart';
///
/// ComponentName(
///   // Usage example with parameters
/// )
/// ```
///
/// **Design Features:**
/// - Material 3 design system integration
/// - Responsive sizing across all breakpoints
/// - Accessibility compliance and performance optimization
///
/// ============================================================================

library component_library;

// Component exports with detailed descriptions
export 'component_file.dart'; // ComponentName: feature description
```

## 🎯 Benefits Achieved

✅ **Individual Component Imports**: Each component imported explicitly for better tree shaking
✅ **Explicit Dependencies**: Clear visibility of what components each feature uses
✅ **Better Tree Shaking**: Flutter can better optimize bundle size with explicit imports
✅ **Improved IntelliSense**: IDEs can provide more accurate suggestions and documentation
✅ **Easier Maintenance**: Direct imports eliminate barrel export complexity
✅ **Production Ready**: All components documented for team collaboration

This shared component system ensures consistency, maintainability, and performance across the entire TicTacToe XO Royale application while providing excellent developer experience through comprehensive documentation.
