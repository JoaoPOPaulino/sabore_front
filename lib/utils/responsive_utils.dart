// lib/utils/responsive_utils.dart
import 'package:flutter/material.dart';

class ResponsiveUtils {
  static double width(BuildContext context) => MediaQuery.of(context).size.width;
  static double height(BuildContext context) => MediaQuery.of(context).size.height;

  // Breakpoints de largura
  static bool isSmallPhone(BuildContext context) => width(context) < 360;
  static bool isMediumPhone(BuildContext context) => width(context) >= 360 && width(context) < 400;
  static bool isLargePhone(BuildContext context) => width(context) >= 400;
  static bool isTablet(BuildContext context) => width(context) >= 600;

  // Breakpoints de altura
  static bool isShortScreen(BuildContext context) => height(context) < 700;
  static bool isMediumScreen(BuildContext context) => height(context) >= 700 && height(context) < 800;
  static bool isTallScreen(BuildContext context) => height(context) >= 800;

  // Font sizes responsivos
  static double fontSize(BuildContext context, double baseSize) {
    if (isSmallPhone(context)) return baseSize * 0.85;
    if (isMediumPhone(context)) return baseSize * 0.92;
    if (isTablet(context)) return baseSize * 1.1;
    return baseSize;
  }

  // Spacing responsivo
  static double spacing(BuildContext context, double baseSpacing) {
    if (isSmallPhone(context)) return baseSpacing * 0.8;
    if (isTablet(context)) return baseSpacing * 1.2;
    return baseSpacing;
  }

  // Padding responsivo
  static EdgeInsets padding(BuildContext context, {
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    double multiplier = 1.0;
    if (isSmallPhone(context)) multiplier = 0.8;
    if (isTablet(context)) multiplier = 1.2;

    return EdgeInsets.only(
      left: (left ?? horizontal ?? all ?? 0) * multiplier,
      right: (right ?? horizontal ?? all ?? 0) * multiplier,
      top: (top ?? vertical ?? all ?? 0) * multiplier,
      bottom: (bottom ?? vertical ?? all ?? 0) * multiplier,
    );
  }

  // Icon size responsivo
  static double iconSize(BuildContext context, double baseSize) {
    if (isSmallPhone(context)) return baseSize * 0.85;
    if (isTablet(context)) return baseSize * 1.15;
    return baseSize;
  }

  // Image height responsivo
  static double imageHeight(BuildContext context, double baseHeight) {
    if (isSmallPhone(context)) return baseHeight * 0.8;
    if (isShortScreen(context)) return baseHeight * 0.85;
    if (isTablet(context)) return baseHeight * 1.2;
    return baseHeight;
  }

  // Card height responsivo
  static double cardHeight(BuildContext context, double baseHeight) {
    if (isSmallPhone(context)) return baseHeight * 0.9;
    if (isTablet(context)) return baseHeight * 1.1;
    return baseHeight;
  }

  // Grid columns responsivo
  static int gridColumns(BuildContext context, {int small = 2, int medium = 3, int large = 4}) {
    if (isSmallPhone(context)) return small;
    if (isTablet(context)) return large;
    return medium;
  }

  // Button height responsivo
  static double buttonHeight(BuildContext context, double baseHeight) {
    if (isSmallPhone(context)) return baseHeight * 0.85;
    return baseHeight;
  }

  // AppBar height responsivo
  static double appBarHeight(BuildContext context, double baseHeight) {
    if (isSmallPhone(context)) return baseHeight * 0.9;
    return baseHeight;
  }
}