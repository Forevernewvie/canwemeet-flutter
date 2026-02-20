import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Pencil MCP MVP palette
  static const Color bg = Color(0xFFF4F0E9);
  static const Color card = Color(0xFFFFFDF9);
  static const Color elevatedSurface = Color(0xFFEEE7DC);
  static const Color onAccent = Color(0xFFFFFFFF);
  static const Color chip = Color(0xFFE7E0D2);
  static const Color chipText = Color(0xFF6D6C6A);
  static const Color surfaceMuted = elevatedSurface;
  static const Color text = Color(0xFF1A1918);
  static const Color subText = Color(0xFF6D6C6A);
  static const Color textTertiary = Color(0xFF8A857D);
  static const Color divider = Color(0xFFE6DDCE);
  static const Color borderSoft = divider;
  static const Color accent = Color(0xFF2F8E63);
  static const Color accentWarm = Color(0xFFD88B66);
  static const Color accentSoft = Color(0xFFE3F0EC);
  static const Color badgeAccentBg = chip;
  static const Color badgeAccentText = chipText;
}

class AppSpacing {
  const AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class AppRadius {
  const AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
}

class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> l0 = <BoxShadow>[];
  static const List<BoxShadow> l1 = <BoxShadow>[
    BoxShadow(color: Color(0x1A191714), offset: Offset(0, 1), blurRadius: 4),
  ];
  static const List<BoxShadow> l2 = <BoxShadow>[
    BoxShadow(color: Color(0x24191714), offset: Offset(0, 4), blurRadius: 12),
  ];
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.accent,
      onPrimary: AppColors.onAccent,
      secondary: AppColors.accentWarm,
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
        borderRadius: BorderRadius.circular(AppRadius.lg),
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
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      secondaryLabelStyle: const TextStyle(
        color: AppColors.onAccent,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 4,
      ),
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
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
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
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      headlineLarge: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AppColors.text,
      ),
      headlineMedium: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: AppColors.text,
      ),
      titleLarge: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: AppColors.text,
      ),
      titleMedium: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: AppColors.text,
      ),
      titleSmall: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: AppColors.text,
      ),
      bodyLarge: const TextStyle(
        fontSize: 14,
        height: 1.4,
        color: AppColors.text,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        height: 1.4,
        color: AppColors.text,
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
        height: 1.35,
        color: AppColors.subText,
      ),
      labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        side: const BorderSide(color: AppColors.divider),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(color: AppColors.subText, fontSize: 14),
      filled: true,
      fillColor: AppColors.surfaceMuted,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
