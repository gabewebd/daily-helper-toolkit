import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/tool_module.dart';

// josh: grade calculator gawa ni mika yan
class GradeCalculatorModule extends ToolModule {
  @override
  String get title => 'GWA Calc';

  @override
  IconData get icon => Icons.calculate_rounded;

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

// Dito naka-store per item natin pag nag-add subject, gawa ko internal na lang
class _ItemNaSubjectEntry {
  final String panaglanan;
  final double yunitNiya;
  final double nakuhangGrado;
  _ItemNaSubjectEntry(this.panaglanan, this.yunitNiya, this.nakuhangGrado);
}

class _GradeCalculatorBodyState extends State<GradeCalculatorBody> {
  // mika: strict sabi ni sir, wag daw lalabas yung state, kaya private to (_)
  final List<_ItemNaSubjectEntry> _listNgSubjectsNatin = [];
  final TextEditingController _inputParaSaNameControl = TextEditingController();
  final TextEditingController _inputParaSaUnitsControl = TextEditingController();
  final TextEditingController _inputParaSaGradesControl = TextEditingController();

  // Controlled update function: Dave tinawag ko si sir dito, okay daw yung ganitong add flow
  void _pindotAddNangSubj() {
    final name = _inputParaSaNameControl.text.trim();
    final unitsText = _inputParaSaUnitsControl.text.trim();
    final gradeText = _inputParaSaGradesControl.text.trim();

    // Check kung may nakalimutan, bawal blank yun ha
    if (name.isEmpty || unitsText.isEmpty || gradeText.isEmpty) {
      _pakitaErrorNgBata('Huy! Paki-fill up lahat muna bago mag-add ng subject dyan');
      return;
    }

    final units = double.tryParse(unitsText);
    final grade = double.tryParse(gradeText);

    // Fallback kung maling format nilagay (letters imbis na number huhu)
    if (units == null || units <= 0) {
      _pakitaErrorNgBata('Ano ba yan, invalid units. Dapat lagpas 0 yan!');
      return;
    }
    if (grade == null || grade < 1.0 || grade > 5.0) {
      _pakitaErrorNgBata('Wag imbento ng grade! Dapat from 1.0 hanggang 5.0 lang sis.');
      return;
    }
    setState(() {
      _listNgSubjectsNatin.add(_ItemNaSubjectEntry(name, units, grade));
    });

    _inputParaSaNameControl.clear();
    _inputParaSaUnitsControl.clear();
    _inputParaSaGradesControl.clear();
    FocusScope.of(context).unfocus();
  }

  // josh: logic natin sa bottom compute button
  void _pindotParaMagComputeNaGwaNatin() {
    if (_listNgSubjectsNatin.isEmpty) {
      _pakitaErrorNgBata('Luh, wala ka pa ngang subject na nilalagay eh pano yan.');
      return;
    }

    double totalWeightedIsko = 0;
    double panlahatNaUnitsNito = 0;

    for (var sub in _listNgSubjectsNatin) {
      totalWeightedIsko += (sub.nakuhangGrado * sub.yunitNiya);
      panlahatNaUnitsNito += sub.yunitNiya;
    }

    // Bug prevention: division by zero na babangga pag 0 lahat ng units, lagpas bagsak na yon ah
    double finalGwaNiyaMismo = panlahatNaUnitsNito == 0 ? 0.0 : totalWeightedIsko / panlahatNaUnitsNito;
    String statusRemarksNgaRaw = finalGwaNiyaMismo <= 3.0 ? "Good Standing!" : "Warning pre, delikado!";

    _papakitaanResultNgDialogPo(finalGwaNiyaMismo, panlahatNaUnitsNito, statusRemarksNgaRaw);
  }

  void _linisinLahatNangNakita() {
    setState(() => _listNgSubjectsNatin.clear());
    _inputParaSaNameControl.clear();
    _inputParaSaUnitsControl.clear();
    _inputParaSaGradesControl.clear();
  }

  // Ginawa ko custom dialog sncakbar dito, pwede natin pagyabang na maganda UI
  void _pakitaErrorNgBata(String angMessagePoSana) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          angMessagePoSana,
          style: GoogleFonts.figtree(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Popup modal window for computation breakdown
  void _papakitaanResultNgDialogPo(double nilabasNgGwa, double kabuuangUnitsTol, String angAtingStatusAyan) {
    final themeColor = Theme.of(context).primaryColor;
    final statusColor = nilabasNgGwa <= 3.0 ? Colors.green : Colors.redAccent;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
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
                  'Your GWA!',
                  style: GoogleFonts.figtree(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.black45,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  nilabasNgGwa.toStringAsFixed(2),
                  style: GoogleFonts.figtree(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                    letterSpacing: -2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Total Units: ${kabuuangUnitsTol.toInt()}',
                  style: GoogleFonts.figtree(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),

                // Outlined Status Container
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.05),
                    border: Border.all(
                      color: statusColor.withOpacity(0.5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Result: $angAtingStatusAyan',
                    style: GoogleFonts.figtree(
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                    ),
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
                        color: themeColor,
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
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Grade Calculator!',
              style: GoogleFonts.figtree(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.grey.shade400),
              onPressed: _linisinLahatNangNakita,
              tooltip: 'Clear All',
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Container card para mas magandang background framing sa textfields
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
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
              TextField(
                controller: _inputParaSaNameControl,
                style: GoogleFonts.figtree(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Subject (e.g., MATH 101)',
                  hintStyle: GoogleFonts.figtree(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputParaSaUnitsControl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: GoogleFonts.figtree(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Units',
                        hintStyle: GoogleFonts.figtree(
                          color: Colors.grey.shade400,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _inputParaSaGradesControl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: GoogleFonts.figtree(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Grade',
                        hintStyle: GoogleFonts.figtree(
                          color: Colors.grey.shade400,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                // Ins: Step 4 FilledButton
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: themeColor.withOpacity(0.1),
                    foregroundColor: themeColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _pindotAddNangSubj,
                  icon: const Icon(Icons.add),
                  label: Text(
                    'ADD SUBJECT',
                    style: GoogleFonts.figtree(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Dave: ListView natin to oh, wag baguhin! Kasama to sa minimum requirements
        if (_listNgSubjectsNatin.isNotEmpty) ...[
          Text(
            'Inputted Subjects',
            style: GoogleFonts.figtree(
              fontWeight: FontWeight.w800,
              color: Colors.black45,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
        ],

        if (_listNgSubjectsNatin.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Text(
                'No subjects yet! Please input above',
                style: GoogleFonts.figtree(
                  color: Colors.black26,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _listNgSubjectsNatin.length,
            itemBuilder: (context, index) {
              final subject = _listNgSubjectsNatin[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject.panaglanan,
                          style: GoogleFonts.figtree(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Units: ${subject.yunitNiya.toInt()}',
                          style: GoogleFonts.figtree(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      subject.nakuhangGrado.toStringAsFixed(2),
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

        if (_listNgSubjectsNatin.isNotEmpty) ...[
          const SizedBox(height: 32),
          // Final computation button natin (ElevatedButton type requirements)
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: _pindotParaMagComputeNaGwaNatin,
              child: Text(
                'COMPUTE GWA',
                style: GoogleFonts.figtree(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ],
    );
  }
}
