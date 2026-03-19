import 'package:flutter/material.dart';

const Color accentColor = Colors.red;

final ButtonThemeData buttonThemeData = ButtonThemeData(
  splashColor: accentColor,
  highlightColor: accentColor,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);

final CardThemeData cardTheme = CardThemeData(
  elevation: 8,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
);

final DialogThemeData dialogTheme = DialogThemeData(
  backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    side: const BorderSide(style: BorderStyle.solid, color: accentColor),
  ),
);

ThemeData lightTheme = ThemeData(
  primaryColor: Colors.white,
  primaryColorLight: Colors.white,
  primaryColorDark: const Color(0xffefefef),
  scaffoldBackgroundColor: Colors.white,
  buttonTheme: buttonThemeData,
  cardTheme: cardTheme,
  dialogTheme: dialogTheme,
  colorScheme: ColorScheme.fromSwatch(brightness: Brightness.light)
      .copyWith(secondary: accentColor),
  checkboxTheme: CheckboxThemeData(
    fillColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return accentColor;
      }
      return null;
    }),
  ),
  radioTheme: RadioThemeData(
    fillColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return accentColor;
      }
      return null;
    }),
  ),
  switchTheme: SwitchThemeData(
    thumbColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return accentColor;
      }
      return null;
    }),
    trackColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return accentColor;
      }
      return null;
    }),
  ),
);

ThemeData darkTheme = ThemeData(
  primaryColor: Colors.black,
  primaryColorLight: const Color(0xFF0f0f0f),
  primaryColorDark: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  buttonTheme: buttonThemeData,
  cardTheme: cardTheme.copyWith(color: const Color(0xFF0f0f0f)),
  dialogTheme: dialogTheme.copyWith(backgroundColor: const Color(0xFF0f0f0f)),
  colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
      .copyWith(secondary: accentColor),
  checkboxTheme: CheckboxThemeData(
    fillColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return accentColor;
      }
      return null;
    }),
  ),
  radioTheme: RadioThemeData(
    fillColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return accentColor;
      }
      return null;
    }),
  ),
  switchTheme: SwitchThemeData(
    thumbColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return accentColor;
      }
      return null;
    }),
    trackColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return accentColor;
      }
      return null;
    }),
  ),
);
