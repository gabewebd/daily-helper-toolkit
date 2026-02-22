# Daily Helper Toolkit

A Flutter application implementing clean architecture with a modular toolkit approach.

## Group Members

- [ ] Aguiluz, Josh Andrei
- [ ] Camus, Mark Dave
- [ ] Velasquez, Gabrielle Ainshley
- [ ] Yamaguchi, Mikaella Gabrielle 
- [ ] Yamzon, Jan

## Chosen Modules

The following utility modules are implemented in this repository and are located under `lib/modules/`:

- **BMI Calculator** (`bmi_module.dart`) – computes BMI from height and weight.
- **Study Timer** (`study_timer_module.dart`) – simple countdown/stopwatch for study sessions.
- **Grade Calculator** (`grade_calculator_module.dart`) – weighted grade computation for courses.

(Additional tools such as an expense splitter or water tracker were discussed during development but are not part of the current codebase.)

## Development Checklist

- [ ] Project setup and configuration
- [ ] Core architecture (ToolModule abstract class)
- [ ] Theme system implementation (3 preset colors)
- [ ] Setup screen (personalization)
- [ ] Home screen with BottomNavigationBar
- [ ] BMI Module implementation
- [ ] Study Timer Module implementation
- [ ] Grade Calculator Module implementation
- [ ] Testing and bug fixing
- [ ] UI/UX polish

## Getting Started

### Prerequisites

- Flutter SDK (latest version recommended)
- Dart SDK (bundled with Flutter)
- Android Studio / VS Code with Flutter plugins

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/gabewebd/daily-helper-toolkit.git
   ```

2. Navigate to the project directory:
   ```bash
   cd daily_helper_toolkit
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the Application

1. Start a virtual device or connect a physical device
2. Run the app:
   ```bash
   flutter run
   ```

### Build for Release

```bash
flutter build apk --release
```

## Architecture

This project uses a lightweight modular structure with an abstract base class enabling polymorphic navigation. Key components:

lib/
├── main.dart                  # App entry point, wraps AppThemeState and handles initial navigation
├── core/
│   ├── tool_module.dart       # Abstract base class for each utility module
│   └── app_theme.dart         # Theme colors, gradients, and AppThemeState
├── screens/
│   ├── splash_screen.dart     # Displays a loading animation during app startup (optional)
│   ├── setup_screen.dart      # Initial personalization (name + color)
│   └── home_screen.dart       # BottomNavigationBar and module router
└── modules/
    ├── bmi_module.dart        # BMI calculator implementation
    ├── study_timer_module.dart# Study timer implementation
    └── grade_calculator_module.dart # Grade calculator implementation

Each module implements `Widget buildBody(BuildContext)` so that `BuildContext` and theme data flow naturally. State is managed locally with `StatefulWidget` and `setState()`. The app uses `google_fonts` and other packages declared in `pubspec.yaml`.

## Theme Colors

Colors are defined in `lib/core/app_theme.dart` and accessed through the `AcadBalance` helper class. On the setup screen, users can choose from three preset palettes:

- **Cyan Mist** (`AcadBalance.hazeCyan` / gradient to `driftAzure`)
- **Solar Flare** (`AcadBalance.flareSolar` / gradient to `pulseCoral`)
- **Cosmic Purple** (`AcadBalance.glowNebula` / gradient to `voidIndigo`)

During the initial setup, users choose a primary color and a display name. These choices are shared across the app using a custom `InheritedWidget` called `AppThemeState`.

## License

This project is for educational purposes.

## Google Drive (Demo Link)

https://drive.google.com/drive/folders/134jT2IH74vutEDKzX-eVyzZPzXfxVJuw?usp=drive_link