# Project Reflection

## What Was Hard

Document the challenges faced during development:

- [ ] **Challenge 1:** Implementing Polymorphic UI
- [ ] **Challenge 2:** State Encapsulation within Modules
- [ ] **Challenge 3:** Input Validation & Edge Cases

### Details

- **Polymorphic UI**: Initially, it was challenging to pass BuildContext through an abstract method like buildBody so sub-modules could still access theme data. We solved this by making sure the abstract method’s signature exactly matched Flutter’s standard build pattern.

- **Encapsulation**: We also had difficulty keeping result variables private, such as _bmi, while still updating the UI. This was resolved by using StatefulWidgets in the concrete classes and calling setState() only within private logic methods like _computeBMI().

- **Validation**: Empty TextFields or a value of 0 in the Expense Splitter caused crashes during early testing. We addressed this by adding try-parse logic and validation checks, which trigger SnackBars instead of allowing the app to crash.

## Lessons Learned

Key takeaways from this project:

1. **Abstraction is Power**: Using ToolModule allowed us to add new features without touching the MainScaffold code.
2. **The "Private" underscore (_) matters**: We learned that true encapsulation in Dart means keeping variables private so the logic can't be accidentally tampered with from other files.
3. **Widget Selection**: We learned when to use a Slider (for better UX in setting goals) versus a TextField (for precise data like weight).
4. **Theme Consistency**: We learned how to pass a primaryColor throughout the app to ensure the "Personalization" requirement felt professional.
5. **Team Synchronization**: Using a shared contract (the abstract class) allowed three people to code three different modules simultaneously without merge conflicts.

---

## Role Distribution

Team member responsibilities and contributions:

| Team Member | Role | Responsibilities |
|-------------|------|------------------|
| [Aguiluz, Josh Andrei] | Lead Developer | [Defined the ToolModule abstract class; implemented the Polymorphic navigation logic and state management.] |
| [Camus, Mark Dave] | Module Developer | Built the concrete classes for BMI, Expense, and Water modules; implemented the specific business logic for each tool. |
| [Velasquez, Gabrielle Ainshley] | UI/UX Designer | Created the custom theme system (3 colors); designed the setup, home, and splash screes with consistent spacing/padding across modules. |
| [Yamaguchi, Mikaella Gabrielle] | Tester/QA & Documentation | Conducted edge-case testing, managed README, screenshots, and the finalized report. |
| [Yamzon, Jan] | File Reviewer | Rechecked all files, ensuring accuracy and consistency across documentation. |

---

## Technical Insights

Notes on the technical implementation:

- **Architecture & Rationale:** The app is built around an abstract ToolModule class in core/tool_module.dart. Each tool implements its own title and buildBody(BuildContext) method. This polymorphic setup drives the navigation logic in main.dart and home_screen.dart and allowed our team of three to work on separate modules at the same time without merge conflicts. The MainScaffold and routing only deal with ToolModule references, keeping everything loosely connected and easy to maintain.

- **Design Patterns:** The main pattern we used is polymorphism through the abstract base class. We also applied a simple Factory-like approach to create the list of available modules. Each module manages its own state privately using setState() inside its StatefulWidget, which keeps global state minimal and localized.

- **State Management:** For this small app, Flutter’s built-in setState() was enough. It worked well for our few independent tools, but we noted that if the app grows, something more scalable like Provider, Riverpod, or Bloc would be better.

- **Theme & UI:** The custom theme is defined in core/app_theme.dart and passed down via ThemeData in main.dart. All screens share the same colors and text styles, and passing BuildContext through buildBody lets sub-modules access Theme.of(context) smoothly.

- **Validation & Error Handling:** Each module parses inputs using int.tryParse() or double.tryParse() with if checks. Invalid entries show a SnackBar instead of crashing the app. There’s a little duplicated validation across modules, so creating shared helper functions could simplify this.

- **Technical Debt / Improvement Areas:**
  - No automated tests are present; unit/widget tests would increase reliability.
  - Results and user preferences aren’t saved, so the app resets on restart.
  - Validation logic is duplicated and could be refactored into helpers.
  - Accessibility labels and localization are not implemented.
  - All modules are in one package; separating them or using a modular architecture would make reuse easier.

---

---

## Future Improvements

Ideas for enhancing the application:

- [ ] **Persistent Storage:** Save the last results, user settings (like theme color), and module history using shared_preferences or a local database.
- [ ] **State Management Upgrade:** Use Provider, Riverpod, or another state management solution to handle shared data and make adding new modules easier.
- [ ] **Additional Modules:** Complete the grade calculator and study timer modules, and consider adding tools like a habit tracker or expense history.
- [ ] **Testing:** Add unit tests for computation logic and widget tests for each module screen to catch regressions.
- [ ] **Localization & Accessibility:** Support multiple languages and add semantic labels for screen readers.
- [ ] **Dark Mode & Theme Switching:** Allow users to switch between light/dark modes or choose from more color palettes.
- [ ] **Refactor Validation:** Centralize input validation and error messaging in a shared helper class.
- [ ] **Animations & UX polish:** Add smooth transitions between modules and subtle animations for feedback.

---

---

## Conclusion

The Daily Helper Toolkit project was a great way to practice modular design, teamwork, and real Flutter development. Using the ToolModule abstraction let our team work on different features at the same time without interfering with each other’s code. Challenges like passing BuildContext through abstract methods, keeping state private, and validating input helped us make better design choices and understand Flutter’s widget lifecycle more deeply.

Even though the app is still simple, it runs smoothly across platforms and meets all the original requirements. The project reinforced the importance of planning, clear roles, and incremental testing, even when done mostly manually. There’s still room to grow, adding persistence, tests, and more modules will make the app more maintainable and flexible.

Overall, we ended up with a solid codebase, new skills, and confidence that we can quickly build and improve features in the future. It also showed how abstraction and encapsulation really help when working in a team.
