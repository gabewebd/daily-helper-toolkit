import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';
import 'home_screen.dart';

// splash screen — yung drop + bloom animation bago mapasok sa home
class SplashScreen extends StatefulWidget {
  final String displayName;
  final Color selectedColor;

  const SplashScreen({
    super.key,
    required this.displayName,
    required this.selectedColor,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _timeline;

  // isang controller lang ginagamit, hinahati lang sa intervals
  late Animation<double> _physicsDrop;
  late Animation<double> _vibeExpansion;
  late Animation<double> _identityReveal;
  late Animation<double> _syncPulse;

  bool _hasTriggeredHaptic = false;

  @override
  void initState() {
    super.initState();

    // 4500ms — tinry namin 3000 pero parang bitin, 5000 naman matagal
    _timeline = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    );

    _physicsDrop = CurvedAnimation(
      parent: _timeline,
      curve: const Interval(0.0, 0.18, curve: Curves.easeInCirc),
    );

    _vibeExpansion = CurvedAnimation(
      parent: _timeline,
      curve: const Interval(0.18, 0.38, curve: Curves.easeInOutQuart),
    );

    _identityReveal = CurvedAnimation(
      parent: _timeline,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
    );

    _syncPulse = CurvedAnimation(
      parent: _timeline,
      curve: const Interval(0.60, 1.0, curve: Curves.easeInOut),
    );

    // haptic pag natamaan na ng drop yung center — 0.18 yung threshold
    _timeline.addListener(() {
      if (_timeline.value >= 0.18 && !_hasTriggeredHaptic) {
        _hasTriggeredHaptic = true;
        HapticFeedback.heavyImpact();
      }
    });

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 250));

    if (mounted) {
      await _timeline.forward();

      // pag somehow walang displayName, hindi mag-crash — default na lang
      if (widget.displayName.trim().isEmpty) {
        debugPrint('no displayName passed, check setup screen');
      }

      _goToHome();
    }
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, anim, secondaryAnim) => HomeScreen(
          userHandle: widget.displayName,
          baseAura: widget.selectedColor,
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
    _timeline.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size canvas = MediaQuery.of(context).size;
    final Offset anchor = Offset(canvas.width / 2, canvas.height / 2);

    return Scaffold(
      backgroundColor: AcadBalance.paperWhite,
      body: AnimatedBuilder(
        animation: _timeline,
        builder: (context, _) {
          return Stack(
            children: [
              CustomPaint(
                size: canvas,
                painter: AcadVibePainter(
                  dropProgress: _physicsDrop.value,
                  bloomProgress: _vibeExpansion.value,
                  center: anchor,
                  brandColor: widget.selectedColor,
                ),
              ),

              if (_vibeExpansion.value > 0.3)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNameReveal(),

                      const SizedBox(height: 20),

                      Opacity(
                        opacity: _identityReveal.value,
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

                      if (_identityReveal.value > 0.5)
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

  // per-letter animation ng "Hi, [name]"
  // elasticOut curve nagbibigay ng slight bounce na gusto namin
  Widget _buildNameReveal() {
    final String label = "Hi, ${widget.displayName}";
    final characters = label.split('');

    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(characters.length, (i) {
        final double start = 0.32 + (i * 0.025);
        final double end = (start + 0.22).clamp(0.0, 1.0);

        final charAnim = CurvedAnimation(
          parent: _timeline,
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

// painter — phase 1 yung drop, phase 2 yung bloom na sumasakop sa buong screen
// shouldRepaint true lang palagi kasi laging may gumagalaw dito
class AcadVibePainter extends CustomPainter {
  final double dropProgress;
  final double bloomProgress;
  final Offset center;
  final Color brandColor;

  AcadVibePainter({
    required this.dropProgress,
    required this.bloomProgress,
    required this.center,
    required this.brandColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint inkPaint = Paint()
      ..shader = AcadBalance.mapSpectrumToGradient(brandColor).createShader(
          Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    if (bloomProgress == 0.0) {
      final double yPos = -60 + ((center.dy + 60) * dropProgress);
      canvas.drawCircle(Offset(center.dx, yPos), 28.0, inkPaint);
    } else {
      final double scaleFactor = size.longestSide * 1.6;
      canvas.drawCircle(center, scaleFactor * bloomProgress, inkPaint);
    }
  }

  @override
  bool shouldRepaint(AcadVibePainter old) => true;
}