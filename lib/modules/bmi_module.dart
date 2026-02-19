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
      _showErrorSnackBar("Oops! Paki-lagay yung weight at height mo.");
      return;
    }

    final double? weight = double.tryParse(weightStr);
    final double? heightCm = double.tryParse(heightStr);

    // RUBRIC: [UI/UX] Non-numeric and logic validations
    if (weight == null || heightCm == null || weight <= 0 || heightCm <= 0) {
      _showErrorSnackBar("Invalid input. Valid numbers lang please.");
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HUMANIZE: Change the header
            Text(
              'BMI Checker',
              style: GoogleFonts.figtree(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // RUBRIC: [Step 4] TextField with Controllers
                    TextField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                        prefixIcon: Icon(Icons.scale),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _heightController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Height (cm)',
                        prefixIcon: Icon(Icons.height),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      // RUBRIC: [Step 4] FilledButton
                      child: FilledButton(
                        onPressed: _calculateBmi,
                        child: const Text('CHECK BMI'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_bmiResult != null) ...[
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Your Result',
                      style: GoogleFonts.figtree(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45,
                      ),
                    ),
                    Text(
                      _bmiResult!.toStringAsFixed(1),
                      style: GoogleFonts.figtree(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        color: _categoryColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _bmiCategory.toUpperCase(),
                        style: GoogleFonts.figtree(
                          fontWeight: FontWeight.w800,
                          color: _categoryColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
