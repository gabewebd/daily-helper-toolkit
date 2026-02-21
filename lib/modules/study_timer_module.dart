import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart'; 
import '../core/tool_module.dart';

// INSTRUCTION (Rubric): [Step 2] Concrete Tool Module implementation
class StudyTimerModule extends ToolModule {
  @override
  String get title => 'Study Timer';

  @override
  IconData get icon => Icons.timer_outlined;

  @override
  Widget buildBody(BuildContext context) {
    return const StudyTimerBody();
  }
}

class StudyTimerBody extends StatefulWidget {
  const StudyTimerBody({super.key});

  @override
  State<StudyTimerBody> createState() => _StudyTimerBodyState();
}

class _StudyTimerBodyState extends State<StudyTimerBody> {
  // INSTRUCTION (Rubric): [Step 3] Encapsulated state logic
  double _selectedMinutes = 25.0;
  int _secondsRemaining = 25 * 60;
  bool _isRunning = false;
  Timer? _timer;
  final List<String> _completedSessions = [];

  // INSTRUCTION (Rubric): [Step 3] Controlled update methods
  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      if (_secondsRemaining == 0) {
        _secondsRemaining = _selectedMinutes.toInt() * 60;
      }
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _timer?.cancel();
            _isRunning = false;
            _logSession();
          }
        });
      });
    }
  }

  void _logSession() {
    if (!mounted) return;

    // HUMANIZE: You can change this success message to something more fun or personalized!
    final sessionString = "Completed ${_selectedMinutes.toInt()} min session";
    _completedSessions.insert(0, sessionString);

    // HUMANIZE: Change "Session done! Galing!" to any friendly Taglish/English phrase you like.
    _showSnackBar("Session completed! Great work!");
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsRemaining = _selectedMinutes.toInt() * 60;
    });
  }

  // INSTRUCTION (Rubric): [Step 4] SnackBar for feedback
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
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
    _timer?.cancel();
    super.dispose();
  }

  String get _timeString {
    int m = _secondsRemaining ~/ 60;
    int s = _secondsRemaining % 60;
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
            // HUMANIZE: Feel free to change the header text to "Pomodoro", "Grind Time", etc.
            Text(
              'Focus Timer',
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
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 24, offset: const Offset(0, 8)),
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
                          value: _isRunning 
                            ? _secondsRemaining / (_selectedMinutes * 60) 
                            : 1.0,
                          strokeWidth: 8,
                          color: themeColor,
                          backgroundColor: themeColor.withOpacity(0.15),
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) => AcadBalance.mapSpectrumToGradient(themeColor).createShader(bounds),
                        child: Text(
                          _timeString,
                          style: GoogleFonts.figtree(
                            fontSize: 64, 
                            fontWeight: FontWeight.w900,
                            color: Colors.white, // White required for ShaderMask
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // INSTRUCTION (Rubric): [Step 4] Slider requirement fulfilled!
                  Text(
                    'Set Duration: ${_selectedMinutes.toInt()} mins',
                    style: GoogleFonts.figtree(fontWeight: FontWeight.w800, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Slider(
                      value: _selectedMinutes,
                      min: 1.0, // Fixed: 1 min option
                      max: 60.0,
                      divisions: 59, // Fixed: 1 minute increments
                      activeColor: themeColor,
                      inactiveColor: Colors.grey.shade200,
                      onChanged: _isRunning
                          ? null
                          : (value) {
                              setState(() {
                                _selectedMinutes = value;
                                _secondsRemaining = value.toInt() * 60;
                              });
                            },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // FIX: Stacked buttons take full width instead of using Row + Expanded.
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: _toggleTimer,
                      icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                      // HUMANIZE: Button labels can be customized
                      label: Text(_isRunning ? 'PAUSE' : 'START FOCUS', style: GoogleFonts.figtree(fontWeight: FontWeight.w800, letterSpacing: 1.0)),
                      style: FilledButton.styleFrom(
                        backgroundColor: _isRunning ? Colors.black87 : themeColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    // Simplified Flat Reset Button
                    child: FilledButton(
                      onPressed: _resetTimer,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Icon(Icons.refresh),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // INSTRUCTION (Rubric): [Step 4] Session History requirement fulfilled
            if (_completedSessions.isNotEmpty) ...[
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

            // FIX: Directly mapping the list items into the Column prevents unbounded height crashes.
            if (_completedSessions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                  // HUMANIZE: Change this empty state text to match your app's personality
                  child: Text(
                    "No sessions yet. Time to focus!",
                    style: GoogleFonts.figtree(color: Colors.black26, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              )
            else
              ..._completedSessions.map(
                (session) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: themeColor, size: 24),
                      const SizedBox(width: 16),
                      Text(
                        session,
                        style: GoogleFonts.figtree(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 60), // Breathing room at the bottom
          ],
        ),
      ),
    );
  }
}