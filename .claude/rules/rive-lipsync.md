Loads only when editing simulation code.

---

globs:

  - "lib/features/simulation/**"

---

# Rive Lip Sync Rules

## Avatar setup

- File: assets/avatar.riv

- Renderer: Factory.rive (NOT Factory.flutter — this matters)

- State machine has a single integer input: visemeID

## Viseme values

0=REST, 1=AA, 2=EE, 3=MM, 4=FF, 5=OO, 6=LL, 7=SS

## Critical: change-gate writes

Only write to visemeID when the value CHANGES. Writing every tick

re-evaluates the state machine and micro-resets the Breath layer

playhead, causing visible chest vibration.

Track last-written value. Skip duplicate writes.

## Architecture

- VisemeScheduler handles all timing (Timer/Future.delayed per viseme)

- RiveAvatarWidget exposes setViseme(String id) — converts to int

- AudioPlaybackManager signals sentence start → scheduler begins

- Calibration offset constant: start at 80ms, tune by eye
