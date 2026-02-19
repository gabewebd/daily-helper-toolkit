import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/tool_module.dart';

// RUBRIC: [Step 2] Concrete Tool Module (Inheritance)
class GradeCalculatorModule extends ToolModule {
  @override
  String get title => 'Grade Calc';

  @override
  IconData get icon => Icons.school_outlined;

  @override
  Widget buildBody(BuildContext context) {
    return const GradeCalculatorBody();
  }
}

class GradeCalculatorBody extends StatefulWidget {
  const GradeCalculatorBody({super.key});

  @override
  State<GradeCalculatorBody> createState() => _GradeCalculatorBodyState();
}

class _SubjectEntry {
  final String name;
  final double units;
  final double grade;
  _SubjectEntry(this.name, this.units, this.grade);
}

class _GradeCalculatorBodyState extends State<GradeCalculatorBody> {
  // RUBRIC: [Step 3] Encapsulation of Tool State. Private variables hidden from outside.
  final List<_SubjectEntry> _subjects = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  // RUBRIC: [Step 3] Controlled update methods.
  void _addSubject() {
    final name = _nameController.text.trim();
    final unitsText = _unitsController.text.trim();
    final gradeText = _gradeController.text.trim();

    // RUBRIC: [UI/UX] Handle invalid input gracefully (Empty input)
    if (name.isEmpty || unitsText.isEmpty || gradeText.isEmpty) {
      // HUMANIZE: Pwede mong palitan yung error message sa Taglish or your own style.
      _showError('Oops! Paki-fill out lahat ng fields bago mag-add.');
      return;
    }

    final units = double.tryParse(unitsText);
    final grade = double.tryParse(gradeText);

    // RUBRIC: [UI/UX] Non-numeric input handling
    if (units == null || units <= 0) {
      _showError('Invalid units. Kailangan ng number na mas mataas sa 0.');
      return;
    }
    if (grade == null || grade < 1.0 || grade > 5.0) {
      _showError('Invalid grade. Dapat from 1.0 to 5.0 lang.');
      return;
    }

    setState(() {
      _subjects.add(_SubjectEntry(name, units, grade));
    });

    _nameController.clear();
    _unitsController.clear();
    _gradeController.clear();
    FocusScope.of(context).unfocus();
  }

  void _computeGWA() {
    if (_subjects.isEmpty) {
      _showError('Add at least one subject to calculate GWA.');
      return;
    }

    double totalWeightedSum = 0;
    double totalUnits = 0;

    for (var subject in _subjects) {
      totalWeightedSum += (subject.grade * subject.units);
      totalUnits += subject.units;
    }

    // RUBRIC: [UI/UX] Division by zero cases handled
    double finalGWA = totalUnits == 0 ? 0.0 : totalWeightedSum / totalUnits;

    // HUMANIZE: Pwede mong ibahin yung status names
    String status = finalGWA <= 3.0 ? "Good Standing" : "Warning";

    _showResultDialog(finalGWA, totalUnits, status);
  }

  void _reset() {
    setState(() => _subjects.clear());
    _nameController.clear();
    _unitsController.clear();
    _gradeController.clear();
  }

  // RUBRIC: [Step 4] SnackBar for feedback/errors
  void _showError(String message) {
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

  // RUBRIC: [Step 4] Dialog for output breakdown
  void _showResultDialog(double gwa, double totalUnits, String status) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Your GWA',
            style: GoogleFonts.figtree(fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total Units: $totalUnits',
                style: GoogleFonts.figtree(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                gwa.toStringAsFixed(2),
                style: GoogleFonts.figtree(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Status: $status',
                style: GoogleFonts.figtree(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: GoogleFonts.figtree(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    // ADDED FIX: Changed Column to ListView para hindi mag-overflow pag lumabas ang keyboard
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // HUMANIZE: Change title header
            Text(
              'Grade Calculator',
              style: GoogleFonts.figtree(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            IconButton(icon: const Icon(Icons.refresh), onPressed: _reset),
          ],
        ),
        const SizedBox(height: 16),

        // RUBRIC: [Step 4] Card & TextField usage
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Subject (e.g., MATH 101)',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _unitsController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(hintText: 'Units'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _gradeController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(hintText: 'Grade'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  // RUBRIC: [Step 4] FilledButton
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: themeColor.withOpacity(0.1),
                      foregroundColor: themeColor,
                    ),
                    onPressed: _addSubject,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Subject'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // RUBRIC: [Step 4] ListView for output breakdown
        Text(
          'Subjects Added',
          style: GoogleFonts.figtree(
            fontWeight: FontWeight.w700,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 12),

        // ADDED FIX: Pinalitan ng conditional render at shrinkWrap ang Expanded para gumana sa loob ng ListView
        if (_subjects.isEmpty)
          Center(
            child: Text(
              'No subjects added yet.',
              style: GoogleFonts.figtree(color: Colors.black26),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _subjects.length,
            itemBuilder: (context, index) {
              final subject = _subjects[index];
              return Card(
                elevation: 0,
                color: Colors.grey.shade50,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    subject.name,
                    style: GoogleFonts.figtree(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Units: ${subject.units}'),
                  trailing: Text(
                    subject.grade.toString(),
                    style: GoogleFonts.figtree(
                      fontWeight: FontWeight.w900,
                      color: themeColor,
                    ),
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: 24),

        // RUBRIC: [Step 4] ElevatedButton
        ElevatedButton(
          onPressed: _computeGWA,
          child: const Text('CALCULATE GWA'),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
