import 'package:devil/src/shared/colors.dart';
import 'package:flutter/material.dart';

final themeLight = ThemeData(
  colorScheme: ColorScheme.light(
    primary: primary,
    onPrimary: onPrimary,
    secondary: secondary,
    onSecondary: onSecondary,
    background: background,
    onBackground: onBackground,
    surface: surface,
    onSurface: onSurface
  ),
);

final themeDark = ThemeData();