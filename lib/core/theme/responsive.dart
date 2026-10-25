import 'package:flutter/material.dart';

/// Centralized responsive layout utility leveraging Flutter [MediaQuery].
/// Provides screen breakpoints, responsive column calculations, and layout containers
/// optimized for Mobile (<650px), Tablet (650px-1100px), and Desktop (>1100px).
class Responsive {
  static const double mobileBreakpoint = 650.0;
  static const double tabletBreakpoint = 1100.0;
  static const double maxContentWidth = 1200.0;

  /// Returns true if the screen width is less than 650px (phones / narrow viewports).
  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < mobileBreakpoint;
  }

  /// Returns true if the screen width is between 650px and 1100px (tablets / foldables).
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Returns true if the screen width is 1100px or larger (laptops / desktops).
  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= tabletBreakpoint;
  }

  /// Current screen width via MediaQuery.
  static double width(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  /// Current screen height via MediaQuery.
  static double height(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  /// Dynamic horizontal padding based on screen size.
  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < mobileBreakpoint) return 16.0;
    if (w < tabletBreakpoint) return 28.0;
    return 40.0;
  }

  /// Dynamic grid column count for card grids.
  static int gridColumns(BuildContext context, {int mobile = 1, int tablet = 2, int desktop = 3}) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  /// Dynamic banner aspect ratio.
  static double bannerAspectRatio(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= tabletBreakpoint) return 21 / 9;
    if (w >= mobileBreakpoint) return 18 / 9;
    return 16 / 9;
  }
}

/// Convenience extensions on [BuildContext] for responsive queries.
extension ResponsiveContext on BuildContext {
  bool get isMobile => Responsive.isMobile(this);
  bool get isTablet => Responsive.isTablet(this);
  bool get isDesktop => Responsive.isDesktop(this);
  double get screenWidth => Responsive.width(this);
  double get screenHeight => Responsive.height(this);
  double get responsivePadding => Responsive.horizontalPadding(this);
}

/// Wrapper widget that constrains content to [maxContentWidth] and centers it
/// on widescreen desktop and tablet viewports while preserving fluid mobile widths.
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = Responsive.maxContentWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(horizontal: context.responsivePadding),
          child: child,
        ),
      ),
    );
  }
}
