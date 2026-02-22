import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/tool_module.dart';

// Nakabase ito sa AngBaseNgMgaModules para masunod yung OOP inheritance (Step 2 sa rubric)
// dave: yung BMI part naka-assign kay josh
class BmiModule extends ToolModule {
  @override
  String get title => 'BMI Check';

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
  // dave: naka-private yung controllers natin kasi requirement din ni sir for Encapsulation (Step 3 ha)
  final TextEditingController _kiloTimbangInput = TextEditingController();
  final TextEditingController _tangkadCmInput = TextEditingController();

  double? _nacomputeNaBmiDito;
  String _anongResultStatusBmi = "";
  Color _kulayParaSaResulta = Colors.grey;

  // josh: Eto yung magko-compute pag pinindot yung button. Controlled update din daw sabi ni sir
  void _pindotComputeBmiNiya() {
    final String weightStr = _kiloTimbangInput.text.trim();
    final String heightStr = _tangkadCmInput.text.trim();

    // Mika: wag nyo tanggalin tong validation, magc-crash pag empty daw e
    if (weightStr.isEmpty || heightStr.isEmpty) {
      _labasanNgErrorBoxWarning("Oops! Paki-lagay muna yung weight at height mo ha.");
      return;
    }

    final double? weight = double.tryParse(weightStr);
    final double? heightCm = double.tryParse(heightStr);

    // josh: tinry ko lagyan letter yung input ko kahapon nag error kaya dinagdag ko tryParse na logic
    if (weight == null || heightCm == null || weight <= 0 || heightCm <= 0) {
      _labasanNgErrorBoxWarning("Hala, mali yata input mo. Valid numbers lang po dapat.");
      return;
    }

    // kailangan meters pala sa formula, nagugulat ako 0.something BMI ko nung una lol
    double heightMeters = heightCm / 100;

    // Edge-case: pano kung zero yung height? Mag-error to (Division by zero warning ni sir)
    if (heightMeters == 0) return;

    double bmi = weight / (heightMeters * heightMeters);

    setState(() {
      _nacomputeNaBmiDito = bmi;

      // mika: dinagdagan ko mga kulay base sa status para hindi plain tignan
      if (bmi < 18.5) {
        _anongResultStatusBmi = "Underweight ka po";
        _kulayParaSaResulta = Colors.blue;
      } else if (bmi >= 18.5 && bmi <= 24.9) {
        _anongResultStatusBmi = "Wow Normal!";
        _kulayParaSaResulta = Colors.green;
      } else if (bmi >= 25 && bmi <= 29.9) {
        _anongResultStatusBmi = "Medyo Overweight";
        _kulayParaSaResulta = Colors.orange;
      } else {
        _anongResultStatusBmi = "Obese na 'to";
        _kulayParaSaResulta = Colors.red;
      }
    });

    // dave: pampatago ng screen keyboard para di nakaharang sa result
    FocusScope.of(context).unfocus();
  }

  // Eto yung SnackBar function na requirement ha
  void _labasanNgErrorBoxWarning(String mensaheMoSakin) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensaheMoSakin,
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
            Text(
              ' BMI Checker!',
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
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
            // TextField requirement, wag tanggalin ah
                  TextField(
                    controller: _kiloTimbangInput,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: GoogleFonts.figtree(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Weight (kg)',
                      hintStyle: GoogleFonts.figtree(
                        color: Colors.grey.shade400,
                      ),
                      prefixIcon: Icon(
                        Icons.scale,
                        color: Colors.grey.shade400,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _tangkadCmInput,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: GoogleFonts.figtree(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Height (cm)',
                      hintStyle: GoogleFonts.figtree(
                        color: Colors.grey.shade400,
                      ),
                      prefixIcon: Icon(
                        Icons.height,
                        color: Colors.grey.shade400,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    // Trigger eto papunta sa logic natin sa itaas
                    child: FilledButton(
                      onPressed: _pindotComputeBmiNiya,
                      style: FilledButton.styleFrom(
                        backgroundColor: themeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'CALCULATE',
                        style: GoogleFonts.figtree(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_nacomputeNaBmiDito != null) ...[
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: _kulayParaSaResulta.withOpacity(0.05),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: _kulayParaSaResulta.withOpacity(0.4),
                    width: 2,
                  ),
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
                      _nacomputeNaBmiDito!.toStringAsFixed(1),
                      style: GoogleFonts.figtree(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        color: _kulayParaSaResulta,
                        height: 1.1,
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _kulayParaSaResulta.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _anongResultStatusBmi.toUpperCase(),
                        style: GoogleFonts.figtree(
                          fontWeight: FontWeight.w900,
                          color: _kulayParaSaResulta,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
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
