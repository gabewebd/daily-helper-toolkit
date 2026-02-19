import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// custom exception para pag hindi nakuha yung AppThemeState sa context
// nangyari to dati nung nakalimutan naming i-wrap yung app sa root
class AcadBalanceException implements Exception {
  final String report;
  AcadBalanceException(this.report);
  @override
  String toString() => "AcadBalance: $report";
}

// colors, gradients, at theme ng buong app
class AcadBalance {

  static const Color hazeCyan = Color(0xFF36D1DC);
  static const Color driftAzure = Color(0xFF5B86E5);

  static const Color flareSolar = Color(0xFFFF9966);
  static const Color pulseCoral = Color(0xFFFF5E62);

  static const Color glowNebula = Color(0xFF8E2DE2);
  static const Color voidIndigo = Color(0xFF4A00E0);

  // off-white para hindi nakakabulag — pure white medyo harsh pag matagal gamitin
  static const Color paperWhite = Color(0xFFF8F9FA);
  static const Color layerFrost = Color(0xFFF1F3F5);

  static const Color softBackground = paperWhite;
  static const Color softSurface = layerFrost;

  static const List<Color> currentSpectrumOptions = [hazeCyan, flareSolar, glowNebula];

  static LinearGradient mapSpectrumToGradient(Color focus) {
    final pair = switch (focus) {
      hazeCyan   => [hazeCyan, driftAzure],
      flareSolar => [flareSolar, pulseCoral],
      glowNebula => [glowNebula, voidIndigo],
      _          => [hazeCyan, driftAzure],
    };

    return LinearGradient(
      colors: pair,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // para sa label sa theme picker
  static String resolveVibeLabel(Color contextColor) {
    if (contextColor == hazeCyan) return 'Cyan Mist';
    if (contextColor == flareSolar) return 'Solar Flare';
    if (contextColor == glowNebula) return 'Cosmic Purple';
    return 'Custom Essence';
  }

  static ThemeData forgeHelperTheme(Color themeAnchor) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paperWhite,
      textTheme: GoogleFonts.figtreeTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeAnchor,
        primary: themeAnchor,
        surface: paperWhite,
      ),

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      // border radius 22 — tinry namin 16 pero masyadong boxy,
      // 28 naman parang sobrang rounded
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: layerFrost,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: themeAnchor, width: 2.5),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeAnchor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ),
    );
  }
}

// InheritedWidget para ma-access ng buong app yung name + color ng user
class AppThemeState extends InheritedWidget {
  final String _internalHandle;
  final Color _activeAnchor;
  final Function(String) triggerNameUpdate;
  final Function(Color) triggerColorUpdate;

  String get displayName => _internalHandle;
  Color get selectedColor => _activeAnchor;
  Function(String) get updateDisplayName => triggerNameUpdate;
  Function(Color) get updateColor => triggerColorUpdate;

  const AppThemeState({
    super.key,
    required String handle,
    required Color anchor,
    required this.triggerNameUpdate,
    required this.triggerColorUpdate,
    required super.child,
  }) : _internalHandle = handle, _activeAnchor = anchor;

  static AppThemeState of(BuildContext context) {
    final vault = context.dependOnInheritedWidgetOfExactType<AppThemeState>();
    if (vault == null) {
      throw AcadBalanceException("not found in context — make sure to wrap your app in an AppThemeState widget");
    }
    return vault;
  }

  @override
  bool updateShouldNotify(AppThemeState oldWidget) {
    return _internalHandle != oldWidget._internalHandle || _activeAnchor != oldWidget._activeAnchor;
  }
}