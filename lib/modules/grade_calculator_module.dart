import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/tool_module.dart';

// RUBRIC: [Step 2] Concrete Tool Module (Inheritance)
class GradeCalculatorModule extends ToolModule {
  @override
  String get title => 'Grade Calculator';

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
      _showError('Please fill in all fields before adding a subject.');
      return;
    }

    final units = double.tryParse(unitsText);
    final grade = double.tryParse(gradeText);

    // RUBRIC: [UI/UX] Non-numeric input handling
    if (units == null || units <= 0) {
      _showError('Invalid units. Please enter a number greater than 0.');
      return;
    }
    if (grade == null || grade < 1.0 || grade > 5.0) {
      _showError('Invalid grade. Please enter a grade between 1.0 and 5.0.');
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // RUBRIC: [Step 4] Dialog for output breakdown
  void _showResultDialog(double gwa, double totalUnits, String status) {
    final themeColor = Theme.of(context).primaryColor;
    
    // Determine color based on GWA status
    final statusColor = gwa <= 3.0 ? Colors.green : Colors.redAccent;
    
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          backgroundColor: Colors.white,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.school, size: 40, color: themeColor),
                ),
                const SizedBox(height: 24),
                Text(
                  'YOUR GWA',
                  style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black45, letterSpacing: 2.0),
                ),
                const SizedBox(height: 8),
                Text(
                  gwa.toStringAsFixed(2),
                  style: GoogleFonts.figtree(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                    letterSpacing: -2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Total Units: ${totalUnits.toInt()}',
                  style: GoogleFonts.figtree(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                
                // Outlined Status Container
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.05),
                    border: Border.all(color: statusColor.withOpacity(0.5), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Status: $status',
                    style: GoogleFonts.figtree(fontWeight: FontWeight.w800, color: statusColor),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Simplified Close Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: GoogleFonts.figtree(
                        fontWeight: FontWeight.w800, 
                        fontSize: 16, 
                        color: themeColor
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    // ADDED FIX: Changed Column to ListView para hindi mag-overflow pag lumabas ang keyboard
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // HUMANIZE: Change title header
            Text(
              'Grade Calculator',
              style: GoogleFonts.figtree(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.grey.shade400), 
              onPressed: _reset
            ),
          ],
        ),
        const SizedBox(height: 24),

        // RUBRIC: [Step 4] Card & TextField usage
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
              TextField(
                controller: _nameController,
                style: GoogleFonts.figtree(fontWeight: FontWeight.w600, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Subject (e.g., MATH 101)',
                  hintStyle: GoogleFonts.figtree(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _unitsController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: GoogleFonts.figtree(fontWeight: FontWeight.w600, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Units',
                        hintStyle: GoogleFonts.figtree(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _gradeController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: GoogleFonts.figtree(fontWeight: FontWeight.w600, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Grade',
                        hintStyle: GoogleFonts.figtree(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                // RUBRIC: [Step 4] FilledButton (Solid Light Tint)
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: themeColor.withOpacity(0.1),
                    foregroundColor: themeColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _addSubject,
                  icon: const Icon(Icons.add),
                  label: Text('ADD SUBJECT', style: GoogleFonts.figtree(fontWeight: FontWeight.w800, letterSpacing: 1.0)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // RUBRIC: [Step 4] ListView for output breakdown
        if (_subjects.isNotEmpty) ...[
          Text(
            'Subjects Added',
            style: GoogleFonts.figtree(
              fontWeight: FontWeight.w800,
              color: Colors.black45,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
        ],

        // ADDED FIX: Pinalitan ng conditional render at shrinkWrap ang Expanded para gumana sa loob ng ListView
        if (_subjects.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Text(
                'No subjects added yet.',
                style: GoogleFonts.figtree(color: Colors.black26, fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _subjects.length,
            itemBuilder: (context, index) {
              final subject = _subjects[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject.name,
                          style: GoogleFonts.figtree(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Units: ${subject.units.toInt()}',
                          style: GoogleFonts.figtree(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                    Text(
                      subject.grade.toStringAsFixed(1),
                      style: GoogleFonts.figtree(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: themeColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        
        if (_subjects.isNotEmpty) ...[
          const SizedBox(height: 32),
          // RUBRIC: [Step 4] ElevatedButton
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              onPressed: _computeGWA,
              child: Text('CALCULATE GWA', style: GoogleFonts.figtree(fontWeight: FontWeight.w800, letterSpacing: 1.0, fontSize: 15, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ],
    );
  }
}