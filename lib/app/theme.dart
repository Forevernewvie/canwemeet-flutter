import 'package:flutter/material.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.bg,
    required this.card,
    required this.elevatedSurface,
    required this.onAccent,
    required this.chip,
    required this.chipText,
    required this.surfaceMuted,
    required this.text,
    required this.subText,
    required this.textTertiary,
    required this.divider,
    required this.borderSoft,
    required this.accent,
    required this.accentWarm,
    required this.accentSoft,
    required this.badgeAccentBg,
    required this.badgeAccentText,
  });

  final Color bg;
  final Color card;
  final Color elevatedSurface;
  final Color onAccent;
  final Color chip;
  final Color chipText;
  final Color surfaceMuted;
  final Color text;
  final Color subText;
  final Color textTertiary;
  final Color divider;
  final Color borderSoft;
  final Color accent;
  final Color accentWarm;
  final Color accentSoft;
  final Color badgeAccentBg;
  final Color badgeAccentText;

  @override
  AppPalette copyWith({
    Color? bg,
    Color? card,
    Color? elevatedSurface,
    Color? onAccent,
    Color? chip,
    Color? chipText,
    Color? surfaceMuted,
    Color? text,
    Color? subText,
    Color? textTertiary,
    Color? divider,
    Color? borderSoft,
    Color? accent,
    Color? accentWarm,
    Color? accentSoft,
    Color? badgeAccentBg,
    Color? badgeAccentText,
  }) {
    return AppPalette(
      bg: bg ?? this.bg,
      card: card ?? this.card,
      elevatedSurface: elevatedSurface ?? this.elevatedSurface,
      onAccent: onAccent ?? this.onAccent,
      chip: chip ?? this.chip,
      chipText: chipText ?? this.chipText,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      text: text ?? this.text,
      subText: subText ?? this.subText,
      textTertiary: textTertiary ?? this.textTertiary,
      divider: divider ?? this.divider,
      borderSoft: borderSoft ?? this.borderSoft,
      accent: accent ?? this.accent,
      accentWarm: accentWarm ?? this.accentWarm,
      accentSoft: accentSoft ?? this.accentSoft,
      badgeAccentBg: badgeAccentBg ?? this.badgeAccentBg,
      badgeAccentText: badgeAccentText ?? this.badgeAccentText,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      bg: Color.lerp(bg, other.bg, t) ?? bg,
      card: Color.lerp(card, other.card, t) ?? card,
      elevatedSurface:
          Color.lerp(elevatedSurface, other.elevatedSurface, t) ??
          elevatedSurface,
      onAccent: Color.lerp(onAccent, other.onAccent, t) ?? onAccent,
      chip: Color.lerp(chip, other.chip, t) ?? chip,
      chipText: Color.lerp(chipText, other.chipText, t) ?? chipText,
      surfaceMuted:
          Color.lerp(surfaceMuted, other.surfaceMuted, t) ?? surfaceMuted,
      text: Color.lerp(text, other.text, t) ?? text,
      subText: Color.lerp(subText, other.subText, t) ?? subText,
      textTertiary:
          Color.lerp(textTertiary, other.textTertiary, t) ?? textTertiary,
      divider: Color.lerp(divider, other.divider, t) ?? divider,
      borderSoft: Color.lerp(borderSoft, other.borderSoft, t) ?? borderSoft,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      accentWarm: Color.lerp(accentWarm, other.accentWarm, t) ?? accentWarm,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t) ?? accentSoft,
      badgeAccentBg:
          Color.lerp(badgeAccentBg, other.badgeAccentBg, t) ?? badgeAccentBg,
      badgeAccentText:
          Color.lerp(badgeAccentText, other.badgeAccentText, t) ??
          badgeAccentText,
    );
  }
}

class AppColors {
  const AppColors._();

  static const AppPalette light = AppPalette(
    bg: Color(0xFFF4F0E9),
    card: Color(0xFFFFFDF9),
    elevatedSurface: Color(0xFFEEE7DC),
    onAccent: Color(0xFFFFFFFF),
    chip: Color(0xFFE7E0D2),
    chipText: Color(0xFF6D6C6A),
    surfaceMuted: Color(0xFFEEE7DC),
    text: Color(0xFF1A1918),
    subText: Color(0xFF6D6C6A),
    textTertiary: Color(0xFF8A857D),
    divider: Color(0xFFE6DDCE),
    borderSoft: Color(0xFFE6DDCE),
    accent: Color(0xFF2F8E63),
    accentWarm: Color(0xFFD88B66),
    accentSoft: Color(0xFFE3F0EC),
    badgeAccentBg: Color(0xFFE7E0D2),
    badgeAccentText: Color(0xFF6D6C6A),
  );

  static const AppPalette dark = AppPalette(
    bg: Color(0xFF141311),
    card: Color(0xFF1A1815),
    elevatedSurface: Color(0xFF25211B),
    onAccent: Color(0xFFFFFFFF),
    chip: Color(0xFF312B24),
    chipText: Color(0xFFA8A298),
    surfaceMuted: Color(0xFF29241F),
    text: Color(0xFFF2EDE6),
    subText: Color(0xFFB0AAA2),
    textTertiary: Color(0xFF9F978D),
    divider: Color(0xFF3A362F),
    borderSoft: Color(0xFF3A362F),
    accent: Color(0xFF49A97C),
    accentWarm: Color(0xFFE3A17F),
    accentSoft: Color(0xFF22342C),
    badgeAccentBg: Color(0xFF312B24),
    badgeAccentText: Color(0xFFA8A298),
  );
}

extension AppThemeContextX on BuildContext {
  AppPalette get appPalette {
    return Theme.of(this).extension<AppPalette>() ?? AppColors.light;
  }
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
  return _buildTheme(palette: AppColors.light, brightness: Brightness.light);
}

ThemeData buildAppDarkTheme() {
  return _buildTheme(palette: AppColors.dark, brightness: Brightness.dark);
}

ThemeData _buildTheme({
  required AppPalette palette,
  required Brightness brightness,
}) {
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme:
        (brightness == Brightness.dark
                ? const ColorScheme.dark()
                : const ColorScheme.light())
            .copyWith(
              primary: palette.accent,
              onPrimary: palette.onAccent,
              secondary: palette.accentWarm,
              onSecondary: palette.text,
              surface: palette.card,
              onSurface: palette.text,
              onSurfaceVariant: palette.subText,
              outline: palette.borderSoft,
              outlineVariant: palette.divider,
              surfaceTint: Colors.transparent,
            ),
    scaffoldBackgroundColor: palette.bg,
    dividerColor: palette.divider,
    extensions: <ThemeExtension<dynamic>>[palette],
  );

  return base.copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: palette.bg,
      foregroundColor: palette.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: palette.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: palette.borderSoft),
      ),
      margin: EdgeInsets.zero,
    ),
    chipTheme: base.chipTheme.copyWith(
      selectedColor: palette.accent,
      backgroundColor: palette.chip,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      labelStyle: TextStyle(
        color: palette.chipText,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      secondaryLabelStyle: TextStyle(
        color: palette.onAccent,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 4,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: palette.divider,
      thickness: 1,
      space: 1,
    ),
    listTileTheme: const ListTileThemeData(
      dense: false,
      horizontalTitleGap: 10,
      minLeadingWidth: 20,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: palette.card,
      indicatorColor: palette.accentSoft,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          color: selected ? palette.accent : palette.subText,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 12,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? palette.accent : palette.subText,
          size: selected ? 23 : 21,
        );
      }),
      height: 68,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),
    textTheme: base.textTheme.copyWith(
      displaySmall: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w600,
        color: palette.text,
      ),
      headlineLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: palette.text,
      ),
      headlineMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: palette.text,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: palette.text,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: palette.text,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: palette.text,
      ),
      bodyLarge: TextStyle(fontSize: 14, height: 1.4, color: palette.text),
      bodyMedium: TextStyle(fontSize: 14, height: 1.4, color: palette.text),
      bodySmall: TextStyle(fontSize: 12, height: 1.35, color: palette.subText),
      labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: palette.accent,
        foregroundColor: palette.onAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: palette.text,
        side: BorderSide(color: palette.divider),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: palette.subText, fontSize: 14),
      filled: true,
      fillColor: palette.surfaceMuted,
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
        borderSide: BorderSide(color: palette.accent, width: 1.2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
