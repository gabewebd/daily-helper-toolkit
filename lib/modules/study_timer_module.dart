import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';
import '../core/tool_module.dart';

// Pangalawa nating module base sa OOP inheritance (Polymorphic ready)
// mika: study timer ito yung inassign kay dave diba
class StudyTimerModule extends AngBaseNgMgaModules {
  @override
  String get anongPangalanNito => 'Pomodoro';

  @override
  IconData get anongIconGagamitin => Icons.timer_outlined;

  @override
  Widget papakitaSaScreen(BuildContext context) {
    return const StudyTimerBody();
  }
}

class StudyTimerBody extends StatefulWidget {
  const StudyTimerBody({super.key});

  @override
  State<StudyTimerBody> createState() => _StudyTimerBodyState();
}

class _StudyTimerBodyState extends State<StudyTimerBody> {
  // Encapsulated / private lahat ng timer logic natin para safe sa accidental external edits
  double _minutongPiniliNamin = 25.0;
  int _ilangSegundoNaLang = 25 * 60;
  bool _tumatakboBaYungOras = false;
  Timer? _orasanNatinTicking;
  final List<String> _listahanNgNataposNaSesyon = [];

  // Controlled functions para i-update yung timer values state
  void _pindotParaMagStartOStop() {
    if (_tumatakboBaYungOras) {
      _orasanNatinTicking?.cancel();
      setState(() => _tumatakboBaYungOras = false);
    } else {
      if (_ilangSegundoNaLang == 0) {
        // josh: in-adjust ko to sumunod sa slider kapag inulit
        _ilangSegundoNaLang = _minutongPiniliNamin.toInt() * 60;
      }
      setState(() => _tumatakboBaYungOras = true);
      _orasanNatinTicking = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          if (_ilangSegundoNaLang > 0) {
            _ilangSegundoNaLang--;
          } else {
            // Pag tapos na yung oras
            _orasanNatinTicking?.cancel();
            _tumatakboBaYungOras = false;
            _ilistaNatinYungNatapos();
          }
        });
      });
    }
  }

  // Pag natapos ni user, add natin sa history nya
  void _ilistaNatinYungNatapos() {
    if (!mounted) return;
    int mins = _minutongPiniliNamin.toInt();
    String minLabel = mins == 1 ? "minute" : "minutes";
    final sessionString = "Natapos mo! $mins $minLabel Focus";
    _listahanNgNataposNaSesyon.insert(0, sessionString);
    _maglabasNgBabalaSnackbar("Natapos mo rin yung timer! Yay!");
  }

  // Logic button pa-reset na babalik sa simula yung naka-set natin 
  void _ulitinLahatSaSimula() {
    _orasanNatinTicking?.cancel();
    setState(() {
      _tumatakboBaYungOras = false;
      _ilangSegundoNaLang = _minutongPiniliNamin.toInt() * 60;
    });
  }

  // SnackBar dialog notification kapag tapos na
  void _maglabasNgBabalaSnackbar(String itongMessagePo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          itongMessagePo,
          style: GoogleFonts.figtree(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _orasanNatinTicking?.cancel();
    super.dispose();
  }

  String get _timeString {
    int m = _ilangSegundoNaLang ~/ 60;
    int s = _ilangSegundoNaLang % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              'Pomodoro',
              style: GoogleFonts.figtree(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 48.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Dynamic Circular Timer Indicator
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 220,
                        height: 220,
                        child: CircularProgressIndicator(
                          value: _tumatakboBaYungOras
                              ? _ilangSegundoNaLang / (_minutongPiniliNamin * 60)
                              : 1.0,
                          strokeWidth: 8,
                          color: themeColor,
                          backgroundColor: themeColor.withOpacity(0.15),
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AcadBalance.mapSpectrumToGradient(
                              themeColor,
                            ).createShader(bounds),
                        child: Text(
                          _timeString,
                          style: GoogleFonts.figtree(
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // Ginamitan natin Slider as input method pang adjust ng oras
                  Text(
                    'Set Duration: ${_minutongPiniliNamin.toInt()} mins',
                    style: GoogleFonts.figtree(
                      fontWeight: FontWeight.w800,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Slider(
                      value: _minutongPiniliNamin,
                      min: 1.0,
                      max: 60.0,
                      divisions: 59,
                      activeColor: themeColor,
                      inactiveColor: Colors.grey.shade200,
                      onChanged: _tumatakboBaYungOras
                          ? null
                          : (value) {
                              setState(() {
                                _minutongPiniliNamin = value;
                                _ilangSegundoNaLang = value.toInt() * 60;
                              });
                            },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Mga Action Buttons
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: _pindotParaMagStartOStop,
                      icon: Icon(_tumatakboBaYungOras ? Icons.pause : Icons.play_arrow),
                      label: Text(
                        _tumatakboBaYungOras ? 'TEKA PAUSE' : 'START FOCUS',
                        style: GoogleFonts.figtree(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: _tumatakboBaYungOras
                            ? Colors.black87
                            : themeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 56,
                    //  Flat Reset Button
                    child: FilledButton(
                      onPressed: _ulitinLahatSaSimula,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Icon(Icons.refresh),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Iro-render natin history logs base sa widget requirement
            if (_listahanNgNataposNaSesyon.isNotEmpty) ...[
              Text(
                'Session History',
                style: GoogleFonts.figtree(
                  fontWeight: FontWeight.w800,
                  color: Colors.black45,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Loop muna, tapos default view kung wala pang na-complete yung bata
            if (_listahanNgNataposNaSesyon.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                  child: Text(
                    "Wala pa eh. Mag-focus ka na muna dyan!",
                    style: GoogleFonts.figtree(
                      color: Colors.black26,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            else
              ..._listahanNgNataposNaSesyon.map(
                (session) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: themeColor, size: 24),
                      const SizedBox(width: 16),
                      Text(
                        session,
                        style: GoogleFonts.figtree(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
