import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';
import 'splash_screen.dart';

// josh: setup screen — pangalan + theme color ng user daw requirement
// dave: left-aligned layout, gusto namin yung feel na hindi puro centered para maiba naman
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> with SingleTickerProviderStateMixin {
  final _kuhananNgPangalan = TextEditingController();
  Color _hinirangNaKulayNiya = AcadBalance.currentSpectrumOptions.first;
  late AnimationController _tagaHawakNgOrasNgAnimation;

  @override
  void initState() {
    super.initState();

    // Mika: 1400ms na lang kasi pag mas mabilis parang nagla-lag
    _tagaHawakNgOrasNgAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _tagaHawakNgOrasNgAnimation.forward());
  }

  @override
  void dispose() {
    _kuhananNgPangalan.dispose();
    _tagaHawakNgOrasNgAnimation.dispose();
    super.dispose();
  }

  // josh: Trigger to once pinindot niya yung start pre
  void _pindotBagoPumuntaMismo() {
    final String naTypeNaPangalan = _kuhananNgPangalan.text.trim();

    // strict requirement, di pwedeng basyo
    if (naTypeNaPangalan.isEmpty) {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Whoops! We need your name to get started.',
            style: GoogleFonts.figtree(fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(24),
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SplashScreen(
          pangalanNaPapasa: naTypeNaPangalan,
          kulayNaPapasa: _hinirangNaKulayNiya,
        ),
        transitionDuration: const Duration(milliseconds: 850),
        transitionsBuilder: (context, anim, secondAnim, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // kinuha natin width height para responsive
    final lakiNgScreenPoNatin = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AcadBalance.paperWhite,
      body: Stack(
        children: [

          // josh: background glow — opacity 0.06 para sobrang soft lang,
          // dave: natuklasan namin na pag 0.1+ medyo harsh na sa mata
          AnimatedPositioned(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCirc,
            top: _hinirangNaKulayNiya == AcadBalance.currentSpectrumOptions[0] ? -80 : -140,
            right: _hinirangNaKulayNiya == AcadBalance.currentSpectrumOptions[1] ? -80 : -180,
            left: _hinirangNaKulayNiya == AcadBalance.currentSpectrumOptions[2] ? -80 : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: lakiNgScreenPoNatin.width * 1.5,
              height: lakiNgScreenPoNatin.width * 1.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hinirangNaKulayNiya.withOpacity(0.06),
              ),
            ),
          ),

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: const SizedBox(),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 40, 32, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),

                  _papasokPaisaIsaNaView(
                    pangIlanNaToPre: 0.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('👋', style: TextStyle(fontSize: 52)),
                        const SizedBox(height: 28),
                        Text(
                          "Configure your space.",
                          style: GoogleFonts.figtree(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: -1.8,
                            height: 0.9,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Establishing base toolkit parameters for your personalized workflow.",
                          style: GoogleFonts.figtree(
                            fontSize: 16,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 64),

                  _papasokPaisaIsaNaView(
                    pangIlanNaToPre: 0.2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WHAT SHOULD WE CALL YOU?',
                          style: GoogleFonts.figtree(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Colors.black26,
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _kuhananNgPangalan,
                          textCapitalization: TextCapitalization.words,
                          cursorColor: _hinirangNaKulayNiya,
                          style: GoogleFonts.figtree(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: _hinirangNaKulayNiya,
                            letterSpacing: -0.8,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter name...',
                            hintStyle: GoogleFonts.figtree(color: Colors.black12),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 4),
                        // mika: ginawan ko ng underline na nag-e-expand habang nagtatype. sana gumana to sa checking
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: 3,
                          width: _kuhananNgPangalan.text.isEmpty ? 40 : lakiNgScreenPoNatin.width,
                          decoration: BoxDecoration(
                            gradient: AcadBalance.mapSpectrumToGradient(_hinirangNaKulayNiya),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 64),

                  _papasokPaisaIsaNaView(
                    pangIlanNaToPre: 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PICK YOUR THEME',
                          style: GoogleFonts.figtree(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Colors.black26,
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: AcadBalance.currentSpectrumOptions.map((tone) {
                            final bool isActive = tone == _hinirangNaKulayNiya;
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _hinirangNaKulayNiya = tone);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  // dave: nag-e-expand yung selected para obvious kung alin yung active sa widget
                                  width: isActive ? 84 : 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: AcadBalance.mapSpectrumToGradient(tone),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: isActive ? [
                                      BoxShadow(
                                        color: tone.withOpacity(0.25),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      )
                                    ] : [],
                                  ),
                                  child: isActive
                                      ? const Icon(Icons.done_all_rounded, color: Colors.white, size: 24)
                                      : null,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),

                  _papasokPaisaIsaNaView(
                    pangIlanNaToPre: 0.6,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _pindotBagoPumuntaMismo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hinirangNaKulayNiya,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 22),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text(
                          'START CREATING',
                          style: GoogleFonts.figtree(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // josh: staggered entrance pambawi natin sa UI part — sequence lang nagbabago per section para g
  Widget _papasokPaisaIsaNaView({required Widget child, required double pangIlanNaToPre}) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _tagaHawakNgOrasNgAnimation,
        curve: Interval(pangIlanNaToPre, pangIlanNaToPre + 0.35, curve: Curves.easeIn),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _tagaHawakNgOrasNgAnimation,
            curve: Interval(pangIlanNaToPre, pangIlanNaToPre + 0.35, curve: Curves.easeOutQuad),
          ),
        ),
        child: child,
      ),
    );
  }
}