import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';

// Dito natin i-rerely at inimport yung inheritance classes na ginawa natin as modules
import '../core/tool_module.dart';
import '../modules/bmi_module.dart';
import '../modules/study_timer_module.dart';
import '../modules/grade_calculator_module.dart';

// Eto yung main container natin ha. Wag nyo buburahin ulit tulad nung isang araw.
// Ginamit natin ang 'Shell' terminology dahil ito ang nagsisilbing host
class HomeScreen extends StatefulWidget {
  final String pangalanNiya; // Dave: pinasa galing setup screen
  final Color unangKulayNiya; // Base color mula sa AcadBalance manifest

  const HomeScreen({
    super.key,
    required this.pangalanNiya,
    required this.unangKulayNiya,
  });

  @override
  State<HomeScreen> createState() => _ItsuraNgHomeNatinState();
}

class _ItsuraNgHomeNatinState extends State<HomeScreen> {
  // === STATE TOKENS ===
  // Eto yung magttrack kung asan current active index ng bottom bars
  int _anongTabAngNakaOpen = 0;
  late Color _kulayNgAppNatinNgayon;

  // Pinasok sa isang list structure to showcase yung polymorphism, 
  // isang loop lang mamaya sa UI para safe at malinis (Step 5 requirement).
  final List<AngBaseNgMgaModules> _listahanNgMgaPahinaNatin = [
    BmiModule(),
    StudyTimerModule(),
    GradeCalculatorModule(),
  ];

  @override
  void initState() {
    super.initState();
    _kulayNgAppNatinNgayon = widget.unangKulayNiya;
  }

  // Helper para makuha ang dynamic gradient base sa active vibe
  LinearGradient get _gradientNaGamitNgayon =>
      AcadBalance.mapSpectrumToGradient(_kulayNgAppNatinNgayon);

  @override
  Widget build(BuildContext context) {
    // Kinukuha ang personalized theme base sa ating global manifest
    final themeNangBuongHome = AcadBalance.forgeHelperTheme(_kulayNgAppNatinNgayon);

    // nagkanda-leche tayo dito dati kasi nakalimutan i-wrap, wag nyo na tanggalin
    return AppThemeState(
      handle: widget.pangalanNiya,
      anchor: _kulayNgAppNatinNgayon,
      triggerNameUpdate: (_) {}, // No-op sabi ni sir since we don't update name from home
      triggerColorUpdate: (newColor) {
        setState(() {
          _kulayNgAppNatinNgayon = newColor;
        });
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeNangBuongHome,
        home: Scaffold(
          backgroundColor: themeNangBuongHome.scaffoldBackgroundColor,
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _gawaTayoNgHeader(context),

                // === MODULE VIEWPORT ===
                // Dito lilitaw at magba-bago ung active page module sa screen UI
                // Ginawang IndexedStack para kahit palipat-lipat tabs hindi mawi-wipe in-input natin
                Expanded(
                  child: IndexedStack(
                    index: _anongTabAngNakaOpen,
                    children: _listahanNgMgaPahinaNatin.map((module) => module.papakitaSaScreen(context)).toList(),
                  ),
                ),

                // Ang ating responsive floating navigation
                _yungBottomBarNatinNaGumagalaw(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // josh: Eto yung header section, ginamitan ko ng 32.0 padding para pantay sa screens
  Widget _gawaTayoNgHeader(BuildContext context) {
    final String orasNgayon = DateFormat('EEE, MMM d').format(DateTime.now());

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orasNgayon.toUpperCase(),
                    style: GoogleFonts.figtree(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      color: Colors.black26,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_batehinSyaBaseSaOras()},',
                    style: GoogleFonts.figtree(
                      fontSize: 22,
                      color: Colors.black45,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        _gradientNaGamitNgayon.createShader(bounds),
                    child: Text(
                      widget.pangalanNiya,
                      style: GoogleFonts.figtree(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ),
                ],
              ),

              // THEME TRIGGER (Profile Icon na pabilog)
              GestureDetector(
                onTap: _palitanNatinYungKulayBottomSheet,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _gradientNaGamitNgayon,
                    boxShadow: [
                      BoxShadow(
                        color: _kulayNgAppNatinNgayon.withOpacity(0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(2.5), // Gradient stroke
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Text(
                      widget.pangalanNiya.isNotEmpty
                          ? widget.pangalanNiya[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.figtree(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: _kulayNgAppNatinNgayon,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ACCENT ANCHOR LINE
        // Pantay na sa padding na 32 para seamless ang alignment sa text
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          height: 3.5,
          decoration: BoxDecoration(
            gradient: _gradientNaGamitNgayon,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: _kulayNgAppNatinNgayon.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // josh: nag modal bottom sheet tayo dito para mas maganda tignan
  void _palitanNatinYungKulayBottomSheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(35),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Change your vibe',
                style: GoogleFonts.figtree(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: AcadBalance.currentSpectrumOptions.map((aura) {
                  final bool isSelected = _kulayNgAppNatinNgayon == aura;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => _kulayNgAppNatinNgayon = aura);
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.all(isSelected ? 5 : 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: aura, width: 2.5)
                            : null,
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: aura,
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 30,
                              )
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  // dave: Isang responsive bottom bar na nag-e-stretch sa device
  // width pero pinapanatiling compact (hugging) ang mga buttons.
  Widget _yungBottomBarNatinNaGumagalaw() {
    return Container(
      width: double.infinity, // Pinipilit mag-stretch relative sa screen size
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        // spaceBetween para automatic nya mag pantay pantay alignment depende device
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_listahanNgMgaPahinaNatin.length, (idx) {
          // Dynamic loop ng generation instead of hard code pag design
          final bool itoBaYungPinindotNiya = _anongTabAngNakaOpen == idx;

          return GestureDetector(
            onTap: () {
              if (_anongTabAngNakaOpen != idx) {
                HapticFeedback.selectionClick();
                setState(() => _anongTabAngNakaOpen = idx);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.fastOutSlowIn,
              height: 58,
              // 'Hugging' logic: Ang padding ang nagbibigay ng structure sa pill
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                gradient: itoBaYungPinindotNiya ? _gradientNaGamitNgayon : null,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize:
                    MainAxisSize.min, // Hugs the internal content tightly
                children: [
                  Icon(
                    _listahanNgMgaPahinaNatin[idx].anongIconGagamitin, // Magic ng polymorphism: auto read abstract value
                    color: itoBaYungPinindotNiya ? Colors.white : Colors.grey[400],
                    size: 24,
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutBack,
                    child: itoBaYungPinindotNiya
                        ? Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              _listahanNgMgaPahinaNatin[idx]
                                  .anongPangalanNito, // Same sa icon, dynamically fetched ang title gamit abstract class
                              style: GoogleFonts.figtree(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // josh: Nagbabalik ng context-aware greeting base sa oras pra di lang hi hello
  String _batehinSyaBaseSaOras() {
    final currentHour = DateTime.now().hour;
    if (currentHour < 12) return 'Good morning';
    if (currentHour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}