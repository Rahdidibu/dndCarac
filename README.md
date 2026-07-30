# Le codex de l'aventurier

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.8%2B-blue)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2)](https://dart.dev)

![Le codex de l'aventurier banner](assets/readme_banner.svg)

Le codex de l'aventurier is a Flutter application designed to help players create, manage, and evolve their D&D characters from a single place. The app includes a guided character creation flow, character sheets, level-up progression, spell management, equipment tracking, and themed experiences such as Batman-inspired character flows.

## Overview

This project is built with Flutter and Dart, with local persistence and optional Supabase integration for authentication and cloud-backed features. It is aimed at players who want a lightweight, modern tool for tracking their characters.

## Features

- Guided character creation wizard
- Character sheets with core stats and progression
- Level-up support
- Spell management and spell details
- Equipment and resource tracking
- The Forge and Batman-related character flows
- French and English localization
- Optional Supabase authentication and data integration

## Features by module

| Module | Description |
| --- | --- |
| Character management | Create, edit, and track your characters from creation to level-up. |
| Spellbook | Browse spells, view details, and manage spell preparation. |
| Inventory and resources | Manage equipment, currency, and class resources. |
| The Forge | Access special character-building flows and progression tools. |
| Batman theme | Enjoy themed character experiences and dedicated flows. |
| Account and sync | Sign in with Supabase-enabled features for a connected experience. |

## How it works

1. Start by creating a character through the guided wizard.
2. The app stores your character data locally and can optionally sync through Supabase.
3. Use the character sheet to view stats, manage spells, equipment, and progression.
4. Advance your character with level-up flows and additional content modules.
5. Export or share your character information as needed.

## Screenshots

Here are a few screenshots of the app experience:

![Homepage](assets/screenshots/homepage.png)

![Main page](assets/screenshots/mainPage.png)

![Forge experience](assets/screenshots/forge.png)

> These captures come from the live web app at [URL].

## Tech Stack

- Flutter
- Dart
- Riverpod for state management
- Drift for local database storage
- Supabase for optional backend services

## Prerequisites

Make sure you have the following installed:

- Flutter SDK 3.8 or newer
- Dart SDK
- An emulator, simulator, or a browser for running the app

## Getting Started

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd dndCarac
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate localization files if needed:
   ```bash
   flutter gen-l10n
   ```

4. Run the application:
   ```bash
   flutter run
   ```

   For web development, you can also use:
   ```bash
   flutter run -d chrome
   ```

## Configuration

The application can optionally use Supabase. If you want to enable it, provide the following environment variables:

```bash
SUPABASE_URL=your-supabase-url
SUPABASE_ANON_KEY=your-supabase-anon-key
```

You can pass them at runtime with Dart defines:

```bash
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

## Roadmap

Planned improvements include:

- Better character import/export options
- Enhanced spellbook and combat tools
- Improved mobile and tablet UX
- More thematic content packs
- Expanded cloud sync and backup features

## Contributing

Contributions are welcome. If you want to improve the project:

1. Fork the repository
2. Create a feature branch
3. Make your changes and test them locally
4. Open a pull request with a clear description

## Project Structure

- lib/: main application code
- assets/: game data, translations, and resources
- test/: unit and widget tests
- supabase/: database migrations and schema files

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
