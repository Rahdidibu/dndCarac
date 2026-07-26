---
name: flutter-clean-refactor
description: Rules and guidelines to analyze, refactor, and clean up Flutter code to make it highly maintainable, clean, and bug-free, aligned with Riverpod code generation, Drift database, and feature-first architecture.
---

Use this skill whenever the user requests to:
- "refactor", "clean up", "restructure", "beautify", or "improve maintainability" of a Flutter/Dart file.
- Split a large or complex widget into smaller components.
- Convert legacy manual Riverpod providers to the new `@riverpod` code-gen pattern.
- Review a Flutter file for architectural violations or clean code compliance.

---

## 1. Directory Structure & Feature-First Design
Always organize code in a feature-first structure. If a file is placed incorrectly, propose moving it.
- **Path**: `lib/features/<feature_name>/`
  - `/screens/`: Holds full screens/pages that are pushed onto the navigation stack (e.g., [character_creation_wizard.dart](file:///Users/mber/develop/dnd_character_manager/lib/features/character/screens/character_creation_wizard.dart)).
  - `/widgets/`: Reusable components used only within this feature.
  - `/providers/`: Riverpod providers managing the business logic, state, and database repository bridges for this feature.
- **Core Path**: `lib/core/` for shared components, common themes, database configuration, and global providers.

---

## 2. Riverpod State Management Guidelines
This project uses Riverpod with Code Generation.
- **Always use `@riverpod` or `@Riverpod(keepAlive: true)`**: Do not write manual providers (like `StateNotifierProvider` or `ChangeNotifierProvider`).
- **Logic / State Separation**:
  - Keep screens and widgets strictly declarative. They should watch state and call methods.
  - Avoid putting complex logic (such as validation, database updates, network calls) inside `onPressed` or build methods in UI. Trigger a method on the provider instead.
- **Consumer Widgets**:
  - Use `ConsumerWidget` or `ConsumerStatefulWidget` to access `WidgetRef`.
  - Use `ref.watch(provider)` to reactively build UI based on state.
  - Use `ref.read(provider.notifier).method()` in callbacks/event handlers.
- **Asynchronous States**:
  - When watching an asynchronous provider, always handle the state safely using `.when()` or `.maybeWhen()`:
    ```dart
    asyncValue.when(
      data: (data) => TargetWidget(data: data),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ErrorWidget(error),
    )
    ```

---

## 3. UI and Widget Clean Code Rules
- **Avoid Massive Build Methods**: If a build method exceeds 80-100 lines, or contains nested subtrees with deep indentation, it MUST be refactored.
- **Prefer Extracting Widgets as Classes**: 
  - **DO NOT** extract widgets as helper methods like `Widget _buildHeader()`.
  - **DO** extract widgets as private or public classes: `class _Header extends StatelessWidget` or `class _Header extends ConsumerWidget`.
  - *Rationale*: Classes have their own element lifecycle, optimize rebuild performance by allowing the use of `const` constructors, and make the widget tree cleaner to debug.
- **Layout & Theme Consistency**:
  - Avoid hardcoded colors (e.g. `Colors.purple`) and magic numbers for spacing.
  - Use the defined styles in the application theme, usually accessible via `Theme.of(context)` or custom tokens like `AppTheme.neonCyan`.
- **Localization (i18n)**:
  - Do not hardcode user-facing strings.
  - Use localizations via:
    ```dart
    final l10n = AppLocalizations.of(context)!;
    // Use l10n.yourStringKey
    ```

---

## 4. Dart Best Practices
- **Const Constructors**: Always add `const` to constructors and widget instantiations whenever possible to reduce rebuild overhead.
- **Immutable State**: Ensure states are immutable. If the state is custom, define a `copyWith` method or use Drift generated objects.
- **Avoid print statements**: Use `debugPrint()` or the proper logging channel.
- **Imports Sorting**:
  1. Flutter core imports (`package:flutter/...`).
  2. Third-party packages (e.g. `package:flutter_riverpod/...`).
  3. Absolute or relative imports for local project files (e.g., `import '../../../core/...'`).

---

## 5. Refactoring Workflow
When performing a refactor:
1. **Analyze**: Read the target file fully and identify violations of the rules above.
2. **Design**: Plan the extraction of sub-widgets or migration of providers.
3. **Execute Step-by-Step**:
   - Extract widgets to private classes at the bottom of the file (or new files if shared).
   - Migrate manual state code to Riverpod code-gen if applicable.
4. **Regenerate Code**: If providers or databases were modified, run:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
5. **Verify**: Run `flutter test` or analyze the workspace to check for compile errors.
