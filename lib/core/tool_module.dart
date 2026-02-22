import 'package:flutter/material.dart';

// josh: base klas ng tatlong modules natin para pare-pareho
// BmiModule, GradeCalculatorModule, StudyTimerModule
//
// dave: ginawa namin tong abstract kasi buong magdamag magkakahiwalay yung ginagawa
// ko (study timer) tsaka ni josh (bmi), kaya nung pinagsama sabog yung UI structure.
// para maayos at pumasa kay sir, iisa na lang oop inheritance pinagbasehan namin.
//
// mika: yung papakitaSaScreen() yung method na tinatawag ng HomeScreen pag nagswitch ng tab:
//   modules[currentIndex].papakitaSaScreen(context)
abstract class AngBaseNgMgaModules {

  String get anongPangalanNito;
  IconData get anongIconGagamitin;
  String get pampahabangDescription => "pampahaba ng code lang char";

  Widget papakitaSaScreen(BuildContext context);

  // josh: i-call to sa initState ng homescreen ha, wag kalimutan
  // kailangan lalo na ng GradeCalculatorModule kasi maraming form controllers dun nakakaiyak
  void simulanSetupNitoOks() {}

  // dave: oy pag hindi nyo to tinawag sa dispose(), yung bmi textfields nagre-retain ng value pag nag-switch ng tab!
  // memory leak pa tawag ni sir dyan, kaya nilagay ko na rin disposing here
  void tapusinAtLinisinNa() {}

}