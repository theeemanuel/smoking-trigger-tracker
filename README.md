# Dephasing - Smoking Trigger Tracker

**Dephasing** is a Flutter app for logging and analyzing smoking triggers. Built to support behavior tracking through awareness, it leverages basic behavioral psychology principles like cue awareness and habit disruption.

## Features

- Log common triggers like Stress, Coffee, After Meal, and Boredom.
- Add custom triggers and optional notes.
- View trigger history in a terminal-style log.
- Visualize top triggers with a bar chart (top 5 shown).
- Data persists locally via `shared_preferences`.
- Clear logs with a tap.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- A device or emulator

### Installation

```bash
git clone https://github.com/theeemanuel/smoking-trigger-tracker.git
cd smoking-trigger-tracker
flutter pub get
flutter run
