# Jazzear

A hands-free jazz ear training app for iOS — learn to hear changes on your
commute. Working product title: **"Changes"**.

Jazzear trains functional hearing for jazz musicians (pianists first): notes
against a key center, chord qualities heard by decomposition (bass → 3rd →
7th → colors), guide tones, and progression cells — in short, audio-first
sessions with the phone in your pocket. A spaced-repetition engine decides
what you practice each day.

## Why

No app today combines **jazz harmony training + hands-free audio-first UX +
offline + spaced repetition**. The pedagogy research and competitive
landscape behind that claim: [docs/RESEARCH.md](docs/RESEARCH.md).

## Docs

- [docs/CONCEPT.md](docs/CONCEPT.md) — product concept: modes, curriculum
  ladder, architecture, build phases
- [docs/RESEARCH.md](docs/RESEARCH.md) — pedagogy findings + app landscape
- [docs/DESIGN_BRIEF.md](docs/DESIGN_BRIEF.md) — brief for design exploration
- [docs/roadmap.md](docs/roadmap.md) — what's being built, in what order
- [CLAUDE.md](CLAUDE.md) — development guidelines and architecture
  non-negotiables

## Architecture (planned)

Crux (Rust) core + SwiftUI shell:

- **`jazzear-core`** — all logic: music theory engine, exercise generation,
  session choreography, SRS scheduling, grading. Pure, deterministic,
  testable without a simulator.
- **iOS shell** — a dumb pipe: renders the ViewModel, realizes core-emitted
  score events on an `AVAudioEngine` sampler, speaks answers, persists via
  GRDB, streams mic buffers back to the core.

Offline-first, no accounts, one-time purchase.

## Status

Pre-code. Complete so far: research, concept, design brief, a full Claude
Design pass ([design/](design/README.md) — direction "Blue Hour Console",
including a choreography prototype whose state machine is product spec), and
the implementation plan ([docs/specs/mvp-plan.md](docs/specs/mvp-plan.md)).
Next: milestone M0 (scaffold), then M1 (audio spike — go/no-go gate). See
[docs/roadmap.md](docs/roadmap.md).
