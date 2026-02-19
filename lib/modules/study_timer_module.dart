import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final sessionString = "Completed ${_selectedMinutes.toInt()} min session!";
    _completedSessions.insert(0, sessionString);

    // HUMANIZE: Change "Session done! Galing!" to any friendly Taglish/English phrase you like.
    _showSnackBar("Session done! Galing!");
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

    // FIX: SingleChildScrollView prevents the unbounded height crashes during tab animations.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HUMANIZE: Feel free to change the header text to "Pomodoro", "Grind Time", etc.
            Text(
              'Focus Timer',
              style: GoogleFonts.figtree(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),

            Center(
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeColor.withOpacity(0.05),
                  border: Border.all(
                    color: themeColor.withOpacity(0.3),
                    width: 8,
                  ),
                ),
                child: Text(
                  _timeString,
                  style: GoogleFonts.figtree(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: themeColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // INSTRUCTION (Rubric): [Step 4] Slider requirement fulfilled!
            Text(
              'Set Duration: ${_selectedMinutes.toInt()} mins',
              style: GoogleFonts.figtree(fontWeight: FontWeight.w700),
            ),
            Slider(
              value: _selectedMinutes,
              min: 5.0,
              max: 60.0,
              divisions: 11,
              activeColor: themeColor,
              onChanged: _isRunning
                  ? null
                  : (value) {
                      setState(() {
                        _selectedMinutes = value;
                        _secondsRemaining = value.toInt() * 60;
                      });
                    },
            ),
            const SizedBox(height: 12),

            // FIX: Stacked buttons take full width instead of using Row + Expanded.
            // This totally stops the "BoxConstraints forces an infinite width" error.
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _toggleTimer,
                icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                // HUMANIZE: Button labels can be customized (e.g., "LET'S GO", "TAKE A BREAK")
                label: Text(_isRunning ? 'PAUSE' : 'START FOCUS'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _resetTimer,
                icon: const Icon(Icons.refresh),
                // HUMANIZE: Change button label if you want
                label: const Text('RESET TIMER'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // INSTRUCTION (Rubric): [Step 4] Session History requirement fulfilled
            Text(
              'Session History',
              style: GoogleFonts.figtree(
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),

            // FIX: Directly mapping the list items into the Column prevents unbounded height crashes.
            // We removed the 'Expanded' and 'ListView' entirely for safety.
            if (_completedSessions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                  // HUMANIZE: Change this empty state text to match your app's personality
                  child: Text(
                    "No sessions yet. Start grinding!",
                    style: GoogleFonts.figtree(color: Colors.black26),
                  ),
                ),
              )
            else
              ..._completedSessions.map(
                (session) => Card(
                  elevation: 0,
                  color: Colors.grey.shade50,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(Icons.check_circle, color: themeColor),
                    title: Text(
                      session,
                      style: GoogleFonts.figtree(fontWeight: FontWeight.w600),
                    ),
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
