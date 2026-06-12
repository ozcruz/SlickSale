# SlickSale

AI sales training web app. Users practice conversations with a

lip-synced AI avatar.

## Stack

Flutter web (CanvasKit), Riverpod, GoRouter, Firebase Auth +

Firestore, Freezed, Rive, Google Fonts (Inter)

## Architecture

- lib/core/ — design system, constants, providers

- lib/features/ — each feature has domain/, data/, presentation/

- lib/routing/ — GoRouter with auth redirect guards

- backend/ — Python FastAPI (separate project, see .claude/rules/)

- modal_service/ — Python Modal TTS + STT (separate project)

## Universal rules

- Riverpod for all state. AsyncValue for async. Freezed for models.

- autoDispose on providers that don't outlive their screen

- const constructors everywhere possible

- No print(). debugPrint() at most.

- effective_dart conventions. dart analyze must be zero warnings.

- All styling from lib/core/theme.dart. No ad-hoc colors, text

  styles, or spacing values anywhere.

- If you hit a design decision not covered here, favor simplicity

  and shippability. Don't add abstraction layers, wrapper classes,

  or architecture that isn't needed yet. Build the minimum that works

  correctly and looks polished.
