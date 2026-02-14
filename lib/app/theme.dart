import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  // Keep it simple for now; we can tune typography/colors after UX parity work.
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8A65)),
  );
}
