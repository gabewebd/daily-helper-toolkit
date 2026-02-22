import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';
import 'home_screen.dart';

// josh: splash screen — yung drop + bloom animation bago mapasok sa home
class SplashScreen extends StatefulWidget {
  final String pangalanNaPapasa;
  final Color kulayNaPapasa;

  const SplashScreen({
    super.key,
    required this.pangalanNaPapasa,
    required this.kulayNaPapasa,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _orasNgAnimationNatin;

  // dave: isang controller lang ginagamit natin, hinahati lang sa intervals
  late Animation<double> _bagsakNgBola;
  late Animation<double> _paglakiNgKulay;
  late Animation<double> _paglabasNgPangalan;
  late Animation<double> _pagtibokNgTuldok;

  bool _nagVibrateNaba = false;

  @override
  void initState() {
    super.initState();

    // mika: 4500ms — tinry namin 3000 pero parang bitin, 5000 naman matagal
    _orasNgAnimationNatin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    );

    _bagsakNgBola = CurvedAnimation(
      parent: _orasNgAnimationNatin,
      curve: const Interval(0.0, 0.18, curve: Curves.easeInCirc),
    );

    _paglakiNgKulay = CurvedAnimation(
      parent: _orasNgAnimationNatin,
      curve: const Interval(0.18, 0.38, curve: Curves.easeInOutQuart),
    );

    _paglabasNgPangalan = CurvedAnimation(
      parent: _orasNgAnimationNatin,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
    );

    _pagtibokNgTuldok = CurvedAnimation(
      parent: _orasNgAnimationNatin,
      curve: const Interval(0.60, 1.0, curve: Curves.easeInOut),
    );

    // haptic pag natamaan na ng drop yung center — 0.18 yung threshold tinest ko (dave)
    _orasNgAnimationNatin.addListener(() {
      if (_orasNgAnimationNatin.value >= 0.18 && !_nagVibrateNaba) {
        _nagVibrateNaba = true;
        HapticFeedback.heavyImpact();
      }
    });

    _simulanNaAngAnimation();
  }

  Future<void> _simulanNaAngAnimation() async {
    await Future.delayed(const Duration(milliseconds: 250));

    if (mounted) {
      await _orasNgAnimationNatin.forward();

      // ginawan ko logic pag somehow walang displayName, hindi mag-crash — default na lang (josh)
      if (widget.pangalanNaPapasa.trim().isEmpty) {
        debugPrint('no displayName passed, check setup screen');
      }

      _lipatNaSaHomePre();
    }
  }

  void _lipatNaSaHomePre() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, anim, secondaryAnim) => HomeScreen(
          pangalanNiya: widget.pangalanNaPapasa,
          unangKulayNiya: widget.kulayNaPapasa,
        ),
        transitionDuration: const Duration(milliseconds: 1100),
        transitionsBuilder: (context, anim, secondaryAnim, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _orasNgAnimationNatin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size lakiNgCanvasPre = MediaQuery.of(context).size;
    final Offset gitnaMismoDito = Offset(lakiNgCanvasPre.width / 2, lakiNgCanvasPre.height / 2);

    return Scaffold(
      backgroundColor: AcadBalance.paperWhite,
      body: AnimatedBuilder(
        animation: _orasNgAnimationNatin,
        builder: (context, _) {
          return Stack(
            children: [
              CustomPaint(
                size: lakiNgCanvasPre,
                painter: TagapintaNgKulayNatin(
                  bagsakProgress: _bagsakNgBola.value,
                  lakiProgress: _paglakiNgKulay.value,
                  center: gitnaMismoDito,
                  brandColor: widget.kulayNaPapasa,
                ),
              ),

              if (_paglakiNgKulay.value > 0.3)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNameReveal(),

                      const SizedBox(height: 20),

                      Opacity(
                        opacity: _paglabasNgPangalan.value,
                        child: Text(
                          "ESTABLISHING WORKSPACE...",
                          style: GoogleFonts.figtree(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white.withOpacity(0.7),
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),

                      if (_paglabasNgPangalan.value > 0.5)
                        _buildDots(),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // josh: per-letter animation ng "Hi, [name]"
  // dave: elasticOut curve nagbibigay ng slight bounce na gusto namin mapansin sana
  Widget _buildNameReveal() {
    final String label = "Hi, ${widget.pangalanNaPapasa}";
    final characters = label.split('');

    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(characters.length, (i) {
        final double start = 0.32 + (i * 0.025);
        final double end = (start + 0.22).clamp(0.0, 1.0);

        final charAnim = CurvedAnimation(
          parent: _orasNgAnimationNatin,
          curve: Interval(start, end, curve: Curves.elasticOut),
        );

        if (characters[i] == ' ') return const SizedBox(width: 14);

        return FadeTransition(
          opacity: charAnim,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - charAnim.value)),
            child: Text(
              characters[i],
              style: GoogleFonts.figtree(
                fontSize: 52,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -1.5,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final double pulse = Curves.easeInOut.transform(
          (DateTime.now().millisecondsSinceEpoch % 1200 / 1200).toDouble()
        );

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
            color: Colors.white.withOpacity(pulse * 0.8),
          ),
        );
      }),
    );
  }
}

// mika: painter — phase 1 yung drop, phase 2 yung bloom na sumasakop sa buong screen
// requirement yan, shouldRepaint true lang palagi kasi laging may gumagalaw dito sabi ni dave
class TagapintaNgKulayNatin extends CustomPainter {
  final double bagsakProgress;
  final double lakiProgress;
  final Offset center;
  final Color brandColor;

  TagapintaNgKulayNatin({
    required this.bagsakProgress,
    required this.lakiProgress,
    required this.center,
    required this.brandColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint ipangPintaNatin = Paint()
      ..shader = AcadBalance.mapSpectrumToGradient(brandColor).createShader(
          Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    if (lakiProgress == 0.0) {
      final double yPos = -60 + ((center.dy + 60) * bagsakProgress);
      canvas.drawCircle(Offset(center.dx, yPos), 28.0, ipangPintaNatin);
    } else {
      final double scaleFactor = size.longestSide * 1.6;
      canvas.drawCircle(center, scaleFactor * lakiProgress, ipangPintaNatin);
    }
  }

  @override
  bool shouldRepaint(TagapintaNgKulayNatin old) => true;
}