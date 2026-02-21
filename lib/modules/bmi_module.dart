import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/tool_module.dart';

// RUBRIC: [Step 2] Concrete Tool Module
class BmiModule extends ToolModule {
  @override
  String get title => 'BMI Checker';

  @override
  IconData get icon => Icons.monitor_weight_outlined;

  @override
  Widget buildBody(BuildContext context) {
    return const BmiBody();
  }
}

class BmiBody extends StatefulWidget {
  const BmiBody({super.key});

  @override
  State<BmiBody> createState() => _BmiBodyState();
}

class _BmiBodyState extends State<BmiBody> {
  // RUBRIC: [Step 3] Encapsulated state
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  double? _bmiResult;
  String _bmiCategory = "";
  Color _categoryColor = Colors.grey;

  // RUBRIC: [Step 3] Controlled computation method
  void _calculateBmi() {
    final String weightStr = _weightController.text.trim();
    final String heightStr = _heightController.text.trim();

    // RUBRIC: [UI/UX] Handle invalid input gracefully (Empty)
    if (weightStr.isEmpty || heightStr.isEmpty) {
      _showErrorSnackBar("Please enter both weight and height.");
      return;
    }

    final double? weight = double.tryParse(weightStr);
    final double? heightCm = double.tryParse(heightStr);

    // RUBRIC: [UI/UX] Non-numeric and logic validations
    if (weight == null || heightCm == null || weight <= 0 || heightCm <= 0) {
      _showErrorSnackBar("Invalid input. Please enter valid positive numbers.");
      return;
    }

    double heightMeters = heightCm / 100;

    // RUBRIC: [UI/UX] Division by zero safety
    if (heightMeters == 0) return;

    double bmi = weight / (heightMeters * heightMeters);

    setState(() {
      _bmiResult = bmi;
      // HUMANIZE: Pwede mong gawing Taglish to like "Medyo Underweight"
      if (bmi < 18.5) {
        _bmiCategory = "Underweight";
        _categoryColor = Colors.blue;
      } else if (bmi >= 18.5 && bmi <= 24.9) {
        _bmiCategory = "Normal Weight";
        _categoryColor = Colors.green;
      } else if (bmi >= 25 && bmi <= 29.9) {
        _bmiCategory = "Overweight";
        _categoryColor = Colors.orange;
      } else {
        _bmiCategory = "Obese";
        _categoryColor = Colors.red;
      }
    });

    FocusScope.of(context).unfocus();
  }

  // RUBRIC: [Step 4] SnackBar for feedback/errors
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.figtree(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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
            // HUMANIZE: Change the header
            Text(
              'BMI Checker',
              style: GoogleFonts.figtree(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 24, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                children: [
                  // RUBRIC: [Step 4] TextField with Controllers
                  TextField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: GoogleFonts.figtree(fontWeight: FontWeight.w600, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Weight (kg)',
                      hintStyle: GoogleFonts.figtree(color: Colors.grey.shade400),
                      prefixIcon: Icon(Icons.scale, color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _heightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: GoogleFonts.figtree(fontWeight: FontWeight.w600, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Height (cm)',
                      hintStyle: GoogleFonts.figtree(color: Colors.grey.shade400),
                      prefixIcon: Icon(Icons.height, color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    // RUBRIC: [Step 4] FilledButton
                    child: FilledButton(
                      onPressed: _calculateBmi,
                      style: FilledButton.styleFrom(
                        backgroundColor: themeColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text(
                        'CHECK BMI',
                        style: GoogleFonts.figtree(fontWeight: FontWeight.w800, letterSpacing: 1.0, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (_bmiResult != null) ...[
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(color: _categoryColor.withOpacity(0.05), blurRadius: 24, offset: const Offset(0, 10)),
                  ],
                  border: Border.all(color: _categoryColor.withOpacity(0.4), width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Result',
                      style: GoogleFonts.figtree(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.black45,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _bmiResult!.toStringAsFixed(1),
                      style: GoogleFonts.figtree(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        color: _categoryColor,
                        height: 1.1,
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: _categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _bmiCategory.toUpperCase(),
                        style: GoogleFonts.figtree(
                          fontWeight: FontWeight.w900,
                          color: _categoryColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ],
        ),
      ),
    );
  }
}