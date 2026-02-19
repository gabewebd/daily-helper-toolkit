import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';
import 'splash_screen.dart';

// setup screen — pangalan + theme color ng user
// left-aligned layout, gusto namin yung feel na hindi puro centered
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> with SingleTickerProviderStateMixin {
  final _aliasInput = TextEditingController();
  Color _vibeChoice = AcadBalance.currentSpectrumOptions.first;
  late AnimationController _sequenceManager;

  @override
  void initState() {
    super.initState();

    _sequenceManager = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _sequenceManager.forward());
  }

  @override
  void dispose() {
    _aliasInput.dispose();
    _sequenceManager.dispose();
    super.dispose();
  }

  void _proceed() {
    final String userHandle = _aliasInput.text.trim();

    if (userHandle.isEmpty) {
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
          displayName: userHandle,
          selectedColor: _vibeChoice,
        ),
        transitionDuration: const Duration(milliseconds: 850),
        transitionsBuilder: (context, anim, secondAnim, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AcadBalance.paperWhite,
      body: Stack(
        children: [

          // background glow — opacity 0.06 para sobrang soft lang,
          // natuklasan namin na pag 0.1+ medyo harsh na
          AnimatedPositioned(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCirc,
            top: _vibeChoice == AcadBalance.currentSpectrumOptions[0] ? -80 : -140,
            right: _vibeChoice == AcadBalance.currentSpectrumOptions[1] ? -80 : -180,
            left: _vibeChoice == AcadBalance.currentSpectrumOptions[2] ? -80 : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: viewport.width * 1.5,
              height: viewport.width * 1.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _vibeChoice.withOpacity(0.06),
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

                  _staggerIn(
                    sequence: 0.0,
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

                  _staggerIn(
                    sequence: 0.2,
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
                          controller: _aliasInput,
                          textCapitalization: TextCapitalization.words,
                          cursorColor: _vibeChoice,
                          style: GoogleFonts.figtree(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: _vibeChoice,
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
                        // underline nag-e-expand habang nagtatype
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: 3,
                          width: _aliasInput.text.isEmpty ? 40 : viewport.width,
                          decoration: BoxDecoration(
                            gradient: AcadBalance.mapSpectrumToGradient(_vibeChoice),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 64),

                  _staggerIn(
                    sequence: 0.4,
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
                            final bool isActive = tone == _vibeChoice;
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _vibeChoice = tone);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  // nag-e-expand yung selected para obvious kung alin yung active
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

                  _staggerIn(
                    sequence: 0.6,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _proceed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _vibeChoice,
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

  // staggered entrance — sequence lang nagbabago per section
  Widget _staggerIn({required Widget child, required double sequence}) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _sequenceManager,
        curve: Interval(sequence, sequence + 0.35, curve: Curves.easeIn),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _sequenceManager,
            curve: Interval(sequence, sequence + 0.35, curve: Curves.easeOutQuad),
          ),
        ),
        child: child,
      ),
    );
  }
}