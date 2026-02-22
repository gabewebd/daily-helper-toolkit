import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// josh: custom exception para pag hindi nakuha yung AppThemeState sa context
// dave: nangyari to kahapon nung nakalimutan naming i-wrap yung app sa root kainis ahaha
class AcadBalanceException implements Exception {
  final String reportNgError;
  AcadBalanceException(this.reportNgError);
  @override
  String toString() => "AcadBalance: $reportNgError";
}

// mika: colors, gradients, at theme ng buong app nandito lahat
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

  // mika: ginawa ko tong listahan ng kulay para madali sa setup screen natin
  static const List<Color> currentSpectrumOptions = [hazeCyan, flareSolar, glowNebula];

  static LinearGradient mapSpectrumToGradient(Color targetKulay) {
    final paresNgKulay = switch (targetKulay) {
      hazeCyan   => [hazeCyan, driftAzure],
      flareSolar => [flareSolar, pulseCoral],
      glowNebula => [glowNebula, voidIndigo],
      _          => [hazeCyan, driftAzure], // fallback para sure na hindi mag null (dave)
    };

    return LinearGradient(
      colors: paresNgKulay,
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

  // josh: Eto yung parang pinaka-template ng theme natin na tinatawag sa main
  static ThemeData forgeHelperTheme(Color pinakaThemeAnchorNatin) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paperWhite,
      textTheme: GoogleFonts.figtreeTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: pinakaThemeAnchorNatin,
        primary: pinakaThemeAnchorNatin,
        surface: paperWhite,
      ),

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      // dave: border radius 22 — tinry namin 16 pero masyadong boxy tignan eh,
      // 28 naman parang sobrang itlog na rounded hahahha
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
          borderSide: BorderSide(color: pinakaThemeAnchorNatin, width: 2.5),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: pinakaThemeAnchorNatin,
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

// josh: InheritedWidget raw sabi ni sir para ma-access ng buong app yung name + color ng user nang hindi pinapasa ng pinapasa
class AppThemeState extends InheritedWidget {
  final String _barahaPangalan;
  final Color _kulayNaNakakabit;
  final Function(String) triggerNameUpdate;
  final Function(Color) triggerColorUpdate;

  String get displayName => _barahaPangalan;
  Color get selectedColor => _kulayNaNakakabit;
  Function(String) get updateDisplayName => triggerNameUpdate;
  Function(Color) get updateColor => triggerColorUpdate;

  const AppThemeState({
    super.key,
    required String handle,
    required Color anchor,
    required this.triggerNameUpdate,
    required this.triggerColorUpdate,
    required super.child,
  }) : _barahaPangalan = handle, _kulayNaNakakabit = anchor;

  static AppThemeState of(BuildContext context) {
    final imbakanNatin = context.dependOnInheritedWidgetOfExactType<AppThemeState>();
    if (imbakanNatin == null) {
      throw AcadBalanceException("Hala, not found in context — baka nakalimutan i-wrap yung app sa AppThemeState widget (dave tingnan mo to)");
    }
    return imbakanNatin;
  }

  @override
  bool updateShouldNotify(AppThemeState oldWidget) {
    return _barahaPangalan != oldWidget._barahaPangalan || _kulayNaNakakabit != oldWidget._kulayNaNakakabit;
  }
}