import 'package:flutter/material.dart';

// base ng tatlong modules namin
// BmiModule, GradeCalculatorModule, StudyTimerModule
//
// ginawa namin tong abstract kasi kahapon magkakahiwalay yung ginagawa
// ni josh (bmi) at ni dave (study timer), nagkalayo yung structure.
// para maayos, iisa na lang pinagbasehan namin.
//
// yung buildBody() yung tinatawag ng HomeScreen pag nagswitch ng tab:
//   modules[currentIndex].buildBody(context)
abstract class ToolModule {

  String get title;
  IconData get icon;
  String get description => "tool";


  Widget buildBody(BuildContext context);

  // TODO: i-call to sa initState ng homescreen (mika)
  // kailangan ng GradeCalculatorModule kasi maraming controllers dun
  void initModule() {}

  // pag hindi to tinawag sa dispose(), yung bmi fields nagre-retain ng value pag nag-switch ng tab
  void disposeModule() {}

}