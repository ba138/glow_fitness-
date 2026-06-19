# Glow Fitness

A Flutter fitness app with a **glassmorphism** (frosted-glass) UI.

The interface layers translucent, blurred "glass" surfaces over an animated
aurora gradient background for a modern, glowing look. Built with no external
packages — all charts, rings, and glass effects are implemented with Flutter's
`BackdropFilter` and `CustomPainter`.

## Screens

- **Dashboard** — animated Apple-Watch-style activity rings, daily mini-stats
  (heart rate, water, sleep) and today's featured session.
- **Workouts** — filterable list of workout cards (HIIT, Strength, Cardio,
  Mobility) with duration, calories and difficulty.
- **Progress** — animated weekly calorie bar chart, summary tiles and a weekly
  streak tracker.
- **Profile** — body stats and settings, with a floating glass bottom nav bar.

## Architecture

```
lib/
├── main.dart                 # App entry + MaterialApp
├── theme/app_theme.dart      # Colors, gradients, dark theme
├── models/fitness_data.dart  # ActivityRing, Workout, DayStat
├── data/sample_data.dart     # Demo content
├── screens/
│   ├── home_shell.dart       # Scaffold + bottom nav + screen switching
│   ├── dashboard_screen.dart
│   ├── workouts_screen.dart
│   ├── progress_screen.dart
│   └── profile_screen.dart
└── widgets/
    ├── aurora_background.dart # Animated gradient + color blobs
    ├── glass_card.dart        # Reusable frosted-glass surface
    ├── glass_bottom_nav.dart  # Floating glass nav bar
    ├── activity_rings.dart    # CustomPainter progress rings
    └── weekly_bar_chart.dart  # Animated bar chart
```

## Run

```bash
flutter pub get
flutter run            # mobile / desktop
flutter run -d chrome  # web
```

## Test

```bash
flutter test
```
