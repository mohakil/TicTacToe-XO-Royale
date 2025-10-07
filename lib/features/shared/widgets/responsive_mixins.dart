import 'package:flutter/material.dart';
import 'package:tictactoe_xo_royale/core/extensions/responsive_extensions.dart';

/// Mixin for responsive card widgets
mixin ResponsiveCard on StatelessWidget {
  /// Builds a responsive card with consistent styling
  Widget buildResponsiveCard({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? elevation,
    ShapeBorder? shape,
    Color? color,
  }) {
    return Card(
      elevation:
          elevation ??
          context.getResponsiveCardElevation(
            phoneElevation: 2.0,
            tabletElevation: 4.0,
          ),
      margin:
          margin ??
          context.getResponsivePadding(phonePadding: 8.0, tabletPadding: 12.0),
      shape:
          shape ??
          RoundedRectangleBorder(
            borderRadius: context.getResponsiveBorderRadius(
              phoneRadius: 12.0,
              tabletRadius: 16.0,
            ),
          ),
      color: color,
      child: Container(
        padding:
            padding ??
            context.getResponsivePadding(
              phonePadding: 16.0,
              tabletPadding: 20.0,
            ),
        child: child,
      ),
    );
  }

  /// Builds a responsive card with fixed dimensions
  Widget buildResponsiveCardWithSize({
    required BuildContext context,
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    return SizedBox(
      width: width ?? context.scale(200.0),
      height: height,
      child: buildResponsiveCard(
        context: context,
        child: child,
        margin: margin,
        padding: padding,
      ),
    );
  }
}

/// Mixin for responsive button widgets
mixin ResponsiveButton on StatelessWidget {
  /// Builds a responsive elevated button
  Widget buildResponsiveElevatedButton({
    required BuildContext context,
    required VoidCallback? onPressed,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double? minimumSize,
    ButtonStyle? style,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: (style ?? ElevatedButton.styleFrom()).copyWith(
        padding: WidgetStateProperty.all(
          padding ??
              context.getResponsivePadding(
                phonePadding: 16.0,
                tabletPadding: 20.0,
              ),
        ),
        minimumSize: WidgetStateProperty.all(
          Size(
            minimumSize ?? context.scale(120.0),
            context.getResponsiveButtonHeight(
              phoneHeight: 48.0,
              tabletHeight: 56.0,
            ),
          ),
        ),
      ),
      child: child,
    );
  }

  /// Builds a responsive outlined button
  Widget buildResponsiveOutlinedButton({
    required BuildContext context,
    required VoidCallback? onPressed,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double? minimumSize,
    ButtonStyle? style,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: (style ?? OutlinedButton.styleFrom()).copyWith(
        padding: WidgetStateProperty.all(
          padding ??
              context.getResponsivePadding(
                phonePadding: 16.0,
                tabletPadding: 20.0,
              ),
        ),
        minimumSize: WidgetStateProperty.all(
          Size(
            minimumSize ?? context.scale(120.0),
            context.getResponsiveButtonHeight(
              phoneHeight: 48.0,
              tabletHeight: 56.0,
            ),
          ),
        ),
      ),
      child: child,
    );
  }

  /// Builds a responsive text button
  Widget buildResponsiveTextButton({
    required BuildContext context,
    required VoidCallback? onPressed,
    required Widget child,
    ButtonStyle? style,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: (style ?? TextButton.styleFrom()).copyWith(
        padding: WidgetStateProperty.all(
          context.getResponsivePadding(phonePadding: 12.0, tabletPadding: 16.0),
        ),
        minimumSize: WidgetStateProperty.all(
          Size(
            context.scale(80.0),
            context.getResponsiveButtonHeight(
              phoneHeight: 36.0,
              tabletHeight: 40.0,
            ),
          ),
        ),
      ),
      child: child,
    );
  }
}

/// Mixin for responsive spacing patterns
mixin ResponsiveSpacing on StatelessWidget {
  /// Creates responsive vertical spacing
  Widget buildResponsiveVerticalSpacing({
    required BuildContext context,
    double phoneSpacing = 16.0,
    double tabletSpacing = 20.0,
  }) {
    return SizedBox(
      height: context.getResponsiveSpacing(
        phoneSpacing: phoneSpacing,
        tabletSpacing: tabletSpacing,
      ),
    );
  }

  /// Creates responsive horizontal spacing
  Widget buildResponsiveHorizontalSpacing({
    required BuildContext context,
    double phoneSpacing = 16.0,
    double tabletSpacing = 20.0,
  }) {
    return SizedBox(
      width: context.getResponsiveSpacing(
        phoneSpacing: phoneSpacing,
        tabletSpacing: tabletSpacing,
      ),
    );
  }

  /// Creates responsive padding widget
  Widget buildResponsivePadding({
    required BuildContext context,
    required Widget child,
    double phonePadding = 16.0,
    double tabletPadding = 20.0,
  }) {
    return Padding(
      padding: context.getResponsivePadding(
        phonePadding: phonePadding,
        tabletPadding: tabletPadding,
      ),
      child: child,
    );
  }

  /// Creates responsive margin widget
  Widget buildResponsiveMargin({
    required BuildContext context,
    required Widget child,
    double phoneMargin = 16.0,
    double tabletMargin = 20.0,
  }) {
    return Container(
      margin: context.getResponsivePadding(
        phonePadding: phoneMargin,
        tabletPadding: tabletMargin,
      ),
      child: child,
    );
  }
}

/// Mixin for responsive layout patterns
mixin ResponsiveLayout on StatelessWidget {
  /// Creates a responsive column/row layout based on screen size
  Widget buildResponsiveLayout({
    required BuildContext context,
    required List<Widget> children,
    Axis phoneDirection = Axis.vertical,
    Axis tabletDirection = Axis.horizontal,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  }) {
    return context.isPhone
        ? Column(
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: mainAxisAlignment,
            children: children,
          )
        : Row(
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: mainAxisAlignment,
            children: children,
          );
  }

  /// Creates a responsive grid layout
  Widget buildResponsiveGrid({
    required BuildContext context,
    required List<Widget> children,
    int phoneCrossAxisCount = 1,
    int tabletCrossAxisCount = 2,
    double phoneChildAspectRatio = 1.0,
    double tabletChildAspectRatio = 1.0,
    double phoneSpacing = 16.0,
    double tabletSpacing = 20.0,
  }) {
    return GridView.count(
      crossAxisCount: context.getGridCrossAxisCount(
        phoneCount: phoneCrossAxisCount,
        tabletCount: tabletCrossAxisCount,
      ),
      childAspectRatio: context.isPhone
          ? phoneChildAspectRatio
          : tabletChildAspectRatio,
      crossAxisSpacing: context.getResponsiveSpacing(
        phoneSpacing: phoneSpacing,
        tabletSpacing: tabletSpacing,
      ),
      mainAxisSpacing: context.getResponsiveSpacing(
        phoneSpacing: phoneSpacing,
        tabletSpacing: tabletSpacing,
      ),
      children: children,
    );
  }

  /// Creates a responsive list layout with adaptive item heights
  Widget buildResponsiveList({
    required BuildContext context,
    required List<Widget> children,
    double phoneItemHeight = 56.0,
    double tabletItemHeight = 64.0,
    EdgeInsetsGeometry? padding,
  }) {
    return ListView(
      padding: padding,
      children: children.map((child) {
        return SizedBox(
          height: context.getResponsiveListItemHeight(
            phoneHeight: phoneItemHeight,
            tabletHeight: tabletItemHeight,
          ),
          child: child,
        );
      }).toList(),
    );
  }
}

/// Mixin for responsive text styling
mixin ResponsiveText on StatelessWidget {
  /// Creates responsive text with adaptive font sizes
  Widget buildResponsiveText({
    required BuildContext context,
    required String text,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double phoneSize = 14.0,
    double tabletSize = 16.0,
  }) {
    return Text(
      text,
      style: context.getResponsiveTextStyle(
        style ?? const TextStyle(),
        phoneSize: phoneSize,
        tabletSize: tabletSize,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Creates responsive headline text
  Widget buildResponsiveHeadline({
    required BuildContext context,
    required String text,
    TextStyle? style,
    double phoneSize = 24.0,
    double tabletSize = 28.0,
  }) {
    return buildResponsiveText(
      context: context,
      text: text,
      style: (style ?? const TextStyle()).copyWith(fontWeight: FontWeight.bold),
      phoneSize: phoneSize,
      tabletSize: tabletSize,
    );
  }

  /// Creates responsive subtitle text
  Widget buildResponsiveSubtitle({
    required BuildContext context,
    required String text,
    TextStyle? style,
    double phoneSize = 14.0,
    double tabletSize = 16.0,
  }) {
    return buildResponsiveText(
      context: context,
      text: text,
      style: (style ?? const TextStyle()).copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      phoneSize: phoneSize,
      tabletSize: tabletSize,
    );
  }
}

/// Mixin for responsive icon widgets
mixin ResponsiveIcon on StatelessWidget {
  /// Creates a responsive icon with adaptive sizing
  Widget buildResponsiveIcon({
    required BuildContext context,
    required IconData icon,
    Color? color,
    double phoneSize = 24.0,
    double tabletSize = 28.0,
  }) {
    return Icon(
      icon,
      color: color,
      size: context.getResponsiveIconSize(
        phoneSize: phoneSize,
        tabletSize: tabletSize,
      ),
    );
  }

  /// Creates a responsive icon button
  Widget buildResponsiveIconButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onPressed,
    Color? color,
    double phoneSize = 24.0,
    double tabletSize = 28.0,
    String? tooltip,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: context.getResponsiveIconSize(
          phoneSize: phoneSize,
          tabletSize: tabletSize,
        ),
      ),
      color: color,
      tooltip: tooltip,
    );
  }
}

/// Mixin for responsive container widgets
mixin ResponsiveContainer on StatelessWidget {
  /// Creates a responsive container with adaptive dimensions
  Widget buildResponsiveContainer({
    required BuildContext context,
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
    BoxDecoration? decoration,
  }) {
    return Container(
      width: width != null ? context.scale(width) : null,
      height: height != null ? context.scale(height) : null,
      padding: padding != null
          ? context.getResponsivePadding(phonePadding: 8.0, tabletPadding: 12.0)
          : null,
      margin: margin,
      alignment: alignment,
      decoration: decoration,
      child: child,
    );
  }

  /// Creates a responsive sized box with adaptive dimensions
  Widget buildResponsiveSizedBox({
    required BuildContext context,
    double? width,
    double? height,
    Widget? child,
  }) {
    return SizedBox(
      width: width != null ? context.scale(width) : null,
      height: height != null ? context.scale(height) : null,
      child: child,
    );
  }
}

/// Mixin for responsive app bar widgets
mixin ResponsiveAppBar on StatelessWidget {
  /// Creates a responsive app bar with adaptive heights
  PreferredSizeWidget buildResponsiveAppBar({
    required BuildContext context,
    Widget? title,
    List<Widget>? actions,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return AppBar(
      title: title,
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation:
          elevation ??
          context.getResponsiveCardElevation(
            phoneElevation: 0.0,
            tabletElevation: 1.0,
          ),
      shape: shape,
      toolbarHeight: context.getResponsiveAppBarHeight(
        phoneHeight: 56.0,
        tabletHeight: 64.0,
      ),
    );
  }
}
