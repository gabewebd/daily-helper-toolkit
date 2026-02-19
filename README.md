# Daily Helper Toolkit

A Flutter application implementing clean architecture with a modular toolkit approach.

## Group Members

- [ ] Team Member 1
- [ ] Team Member 2
- [ ] Team Member 3
- [ ] Team Member 4
- [ ] Team Member 5

## Chosen Modules

The following utility modules are included in this application:

- [ ] **BMI Calculator** - Calculate Body Mass Index with height and weight inputs
- [ ] **Study Timer** - Track study sessions with timer functionality
- [ ] **Grade Calculator** - Calculate weighted grades for courses

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
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
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

This project follows clean architecture principles:

```
lib/
├── main.dart                 # App entry point
├── core/
│   ├── tool_module.dart     # Abstract ToolModule class
│   └── app_theme.dart       # Theme management
├── screens/
│   ├── setup_screen.dart    # User personalization
│   └── home_screen.dart     # Main screen with modules
└── modules/
    ├── bmi_module.dart      # BMI Calculator
    ├── study_timer_module.dart  # Study Timer
    └── grade_calculator_module.dart  # Grade Calculator
```

## Theme Colors

The app includes 3 preset theme colors:
- **Blue** (#2196F3)
- **Green** (#4CAF50)
- **Purple** (#9C27B0)

Users can select their preferred color during initial setup.

## License

This project is for educational purposes.
