import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';

/// AcadBaseShell — Ang main visual container ng ating Daily Helper.
/// Ginamit natin ang 'Shell' terminology dahil ito ang nagsisilbing 
/// host para sa iba't ibang modules ng team.
class HomeScreen extends StatefulWidget {
  final String userHandle; // Ginamit ang 'handle' para sa personalization
  final Color baseAura;    // Base color mula sa AcadBalance manifest

  const HomeScreen({
    super.key,
    required this.userHandle,
    required this.baseAura,
  });

  @override
  State<HomeScreen> createState() => _AcadBaseShellState();
}

class _AcadBaseShellState extends State<HomeScreen> {
  // === STATE TOKENS ===
  int _activeToolIdx = 0;
  late Color _currentAura;

  // Nilagay natin sa Registry format para madaling i-maintain
  final List<Map<String, dynamic>> _toolkitRegistry = [
    {'label': 'BMI Calculator', 'icon': Icons.monitor_weight_outlined},
    {'label': 'Study Timer', 'icon': Icons.timer_outlined},
    {'label': 'Grade Calculator', 'icon': Icons.school_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _currentAura = widget.baseAura;
  }

  // Helper para makuha ang dynamic gradient base sa active vibe
  LinearGradient get _activeGradient => AcadBalance.mapSpectrumToGradient(_currentAura);

  @override
  Widget build(BuildContext context) {
    // Kinukuha ang personalized theme base sa ating global manifest
    final shellTheme = AcadBalance.forgeHelperTheme(_currentAura);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: shellTheme,
      home: Scaffold(
        backgroundColor: shellTheme.scaffoldBackgroundColor, 
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _forgeHeader(context),
              
              // === MODULE VIEWPORT ===
              // Dito natin "isinasalpak" ang logic ng ating mga MMODULES
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  switchInCurve: Curves.easeOutQuart,
                  switchOutCurve: Curves.easeInQuart,
                  transitionBuilder: (viewportChild, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.02), // Subtle lift effect
                          end: Offset.zero,
                        ).animate(animation),
                        child: viewportChild,
                      ),
                    );
                  },
                  child: _assembleActiveModule(),
                ),
              ),
              
              // Ang ating responsive floating navigation
              _craftResponsiveNav(),
            ],
          ),
        ),
      ),
    );
  }

  /// _assembleActiveModule — Ang logic provider para sa bawat tab.
  /// Kapag tapos na ang modules, i-re-replace natin itong switch.
  Widget _assembleActiveModule() {
    switch (_activeToolIdx) {
      case 0: return Container(key: const ValueKey('bmi_stub')); 
      case 1: return Container(key: const ValueKey('timer_stub'));
      case 2: return Container(key: const ValueKey('grade_stub'));
      default: return const SizedBox.shrink();
    }
  }

  /// _forgeHeader — Binubuo ang organic top-section ng app.
  /// Gumagamit ng 32.0 standard padding para pantay sa lahat ng screens.
  Widget _forgeHeader(BuildContext context) {
    final String timestamp = DateFormat('EEE, MMM d').format(DateTime.now());

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
                    timestamp.toUpperCase(),
                    style: GoogleFonts.figtree(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      color: Colors.black26,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_resolveDailyGreeting()},',
                    style: GoogleFonts.figtree(
                      fontSize: 22,
                      color: Colors.black45,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => _activeGradient.createShader(bounds),
                    child: Text(
                      widget.userHandle,
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

              // THEME TRIGGER (Profile Icon)
              GestureDetector(
                onTap: _igniteVibeSwitcher,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _activeGradient,
                    boxShadow: [
                      BoxShadow(
                        color: _currentAura.withValues(alpha: 0.25),
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
                      widget.userHandle.isNotEmpty ? widget.userHandle[0].toUpperCase() : '?',
                      style: GoogleFonts.figtree(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: _currentAura,
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
            gradient: _activeGradient,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: _currentAura.withValues(alpha: 0.3),
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

  /// _igniteVibeSwitcher — Ang personalized theme picker.
  void _igniteVibeSwitcher() {
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
              Container(width: 45, height: 5, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 32),
              Text(
                'Change your vibe',
                style: GoogleFonts.figtree(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: AcadBalance.currentSpectrumOptions.map((aura) {
                  final bool isSelected = _currentAura == aura;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => _currentAura = aura);
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.all(isSelected ? 5 : 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: aura, width: 2.5) : null,
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: aura,
                        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 30) : null,
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

  /// _craftResponsiveNav — Isang responsive bottom bar na nag-e-stretch sa device 
  /// width pero pinapanatiling compact (hugging) ang mga buttons.
  Widget _craftResponsiveNav() {
    return Container(
      width: double.infinity, // Pinipilit mag-stretch relative sa screen size
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        // 'spaceBetween' ensures distribution across the stretched bar
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: List.generate(_toolkitRegistry.length, (idx) {
          final bool isFocused = _activeToolIdx == idx;
          
          return GestureDetector(
            onTap: () {
              if (_activeToolIdx != idx) {
                HapticFeedback.selectionClick();
                setState(() => _activeToolIdx = idx);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.fastOutSlowIn,
              height: 58,
              // 'Hugging' logic: Ang padding ang nagbibigay ng structure sa pill
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                gradient: isFocused ? _activeGradient : null,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Hugs the internal content tightly
                children: [
                  Icon(
                    _toolkitRegistry[idx]['icon'] as IconData,
                    color: isFocused ? Colors.white : Colors.grey[400],
                    size: 24,
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutBack,
                    child: isFocused 
                      ? Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            _toolkitRegistry[idx]['label'] as String,
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

  /// _resolveDailyGreeting — Nagbabalik ng context-aware greeting base sa oras.
  String _resolveDailyGreeting() {
    final currentHour = DateTime.now().hour;
    if (currentHour < 12) return 'Good morning';
    if (currentHour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}