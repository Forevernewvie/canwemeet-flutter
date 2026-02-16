import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color bg = Color(0xFFF8FAFC);
  static const Color card = Color(0xFFFFFFFF);
  static const Color elevatedSurface = Color(0xFFF1F5F9);
  static const Color onAccent = Color(0xFFFFFFFF);
  static const Color chip = Color(0xFFEEF2FF);
  static const Color chipText = Color(0xFF334155);
  static const Color surfaceMuted = elevatedSurface;
  static const Color text = Color(0xFF0F172A);
  static const Color subText = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color divider = Color(0xFFE2E8F0);
  static const Color borderSoft = Color(0xFFE2E8F0);
  static const Color accent = Color(0xFF334155);
  static const Color accentSoft = Color(0xFFE2E8F0);
  static const Color badgeAccentBg = Color(0xFFF1F5F9);
  static const Color badgeAccentText = Color(0xFF334155);
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.accent,
      onPrimary: AppColors.onAccent,
      secondary: AppColors.chip,
      surface: AppColors.card,
      onSurface: AppColors.text,
      onSurfaceVariant: AppColors.subText,
      outlineVariant: AppColors.divider,
    ),
    scaffoldBackgroundColor: AppColors.bg,
    dividerColor: AppColors.divider,
  );

  return base.copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      foregroundColor: AppColors.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.borderSoft),
      ),
      margin: EdgeInsets.zero,
    ),
    chipTheme: base.chipTheme.copyWith(
      selectedColor: AppColors.accent,
      backgroundColor: AppColors.chip,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      labelStyle: const TextStyle(
        color: AppColors.chipText,
        fontWeight: FontWeight.w700,
      ),
      secondaryLabelStyle: const TextStyle(
        color: AppColors.onAccent,
        fontWeight: FontWeight.w700,
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
    listTileTheme: const ListTileThemeData(
      dense: false,
      horizontalTitleGap: 10,
      minLeadingWidth: 20,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.card,
      indicatorColor: AppColors.accentSoft,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          color: selected ? AppColors.accent : AppColors.subText,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 12,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? AppColors.accent : AppColors.subText,
          size: selected ? 23 : 21,
        );
      }),
      height: 68,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),
    textTheme: base.textTheme.copyWith(
      displaySmall: const TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      ),
      headlineLarge: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        height: 1.2,
        color: AppColors.text,
      ),
      headlineMedium: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        height: 1.25,
        color: AppColors.text,
      ),
      titleLarge: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: AppColors.text,
      ),
      titleMedium: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: AppColors.text,
      ),
      titleSmall: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: AppColors.text,
      ),
      bodyLarge: const TextStyle(
        fontSize: 15.5,
        height: 1.4,
        color: AppColors.text,
      ),
      bodyMedium: const TextStyle(
        fontSize: 15,
        height: 1.4,
        color: AppColors.text,
      ),
      bodySmall: const TextStyle(
        fontSize: 13.5,
        height: 1.35,
        color: AppColors.subText,
      ),
      labelLarge: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      labelMedium: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        side: const BorderSide(color: AppColors.divider),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(color: AppColors.subText, fontSize: 15),
      filled: true,
      fillColor: AppColors.surfaceMuted,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    ),
  );
}
