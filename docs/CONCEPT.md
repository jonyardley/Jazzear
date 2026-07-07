# Changes — a touch-driven jazz ear trainer (working title)

*A functional-first jazz ear training app for iOS with a Crux (Rust) core, designed around commute-length, audio-first sessions. Concept v0.1, 2026-07-07.*

## The one-liner

**Sonofield's pocket-simple UX × Toned Ear's progression training × Coker's jazz progression cells × real spaced repetition** — the app that trains a jazz pianist to hear changes, on the train, with headphones and a thumb.

## Why this app (from the research)

- Pedagogy consensus: functional/contextual hearing + progression *chunks* + singing transfer to real playing; isolated interval drilling doesn't.
- Market: nobody offers jazz harmony training that's hands-free, offline, and SRS-driven. Nearest neighbors each hold one piece.
- The commute constraint isn't a limitation — short daily sessions are *pedagogically optimal* (ears fatigue; 4×5 min beats 1×20 min).

## Design principles

1. **Audio-first — and audio is output-only.** "Audio-first" means the *content* is sound: music plays (cadences, chords, examples) — the app never speaks and never listens. All input is touch on the screen. No TTS, no voice commands, no speech recognition — no voice audio of any kind (the pre-recorded-clip fallback idea was rejected 2026-07-07). *(A screen-optional hands-free mode is a deferred exploration — see principle 9.)*
2. **Functional over intervallic.** Everything is heard against a key center (cadence or drone establishes it). No "name this interval" out of context.
3. **Decomposition over flashcards.** Chord exercises teach the jazz listening method: bass → 3rd → 7th → colors.
4. **Chunks linked to tunes.** Every progression cell is anchored to named standards ("this is the 'Lady Bird' turnaround").
5. **Error-driven (Banacos pattern).** A miss triggers comparison — replay cadence ↔ missed note, or A/B the confused chord qualities — never just "wrong, next."
6. **Honest gamification.** Streak = minutes of real work; rewards weight hard items and production (playing back at the instrument); SRS resurfaces weak items on decay curves.
7. **Jazz texture.** Rootless voicings, shells, swing feel, ride patterns — not root-position block piano.
8. **Sound before sign.** Musical visualizations (mini keyboard diagrams for voicings, guide-tone contour lines, lead-sheet bars in the Tune Workbench) appear only at the answer reveal and in review screens — never during listening/answering, which would invite reading over hearing. No engraved staff notation anywhere in the app.
9. **User-paced — every step is a tap.** Tap to start an item, tap to reveal the answer (the thinking gap is open-ended — no timer), tap to grade; the grade tap doubles as "next". Auto-paced flow (timed reveal, auto-continue, passive shadow mode) and the hands-free pocket variant that depends on it (locked phone, earbud taps, lock-screen controls) are one bundled post-MVP exploration — not in the initial build.

## Core modes / user journeys

### 1. Pocket Session (the flagship session loop)

Phone in hand, headphones in. A **user-paced** audio loop — every step is a
deliberate screen tap; nothing auto-advances and nothing is timed against
you:

1. Session opens with today's SRS queue + current-rung material (10/15/20 min, user-set).
2. Each item: **context** (cadence or drone in a random key) → **question audio** (a note, chord, guide-tone line, or 2–8 bar progression in combo texture) → **thinking gap** (open-ended — the reveal waits for your tap) → **aural reveal**: the answer is communicated in sound and on screen, never in speech — a degree resolves stepwise to the tonic (the Benbassat move; the resolution path names the note), a chord replays as its decomposition arpeggio (bass → 3rd → 7th → color — the very listening method being taught), and the answer appears on screen. No text-to-speech anywhere.
3. Self-report via on-screen tap zones: "got it" vs "missed it" — the grade tap doubles as "next" (manual progression). No voice commands. *(Earbud-tap grading and a fully passive "shadow mode" are deferred post-MVP along with all auto-pacing.)*
4. On a miss: the Banacos loop — alternate the answer with the context, or A/B the two qualities you confuse, before moving on.
5. Session ends with a 30-second recap: what's due tomorrow, what rung progress was made.

### 2. At the Piano (instrument call & response)

The commute trains recognition; this closes the loop to production. The
instrument is the answer channel — **MIDI over Bluetooth/USB first** (precise,
reliable grading), mic-based note detection for acoustic pianos later:

- Call & response: app plays a phrase/voicing, you play it back; graded
  note-for-note over MIDI (timing-tolerant), with the Banacos comparison loop
  on misses.
- Play the 3rd / the 7th / the #9 of a sounded chord.
- Voicing identification and reproduction (rootless A/B, quartal, upper
  structures).
- "Touch real music" session-closer: a tune from your list, play along with
  generated changes.

Singing remains *encouraged* as practice technique (the thinking-gap prompt
says "name it — out loud or in your head"; audiation pedagogy stands) but is
never graded — no voice input, no voice output in the product (decision
2026-07: sung call-and-response and TTS answers dropped; instrument
interactivity replaces voice as the production channel).

### 3. Tune Workbench (the transcription bridge)

Productizes the iReal-Pro-blind-transcription hack:

- Pick a standard → hear its changes rendered in combo texture, *chart hidden*.
- Identify the form, then landmark chords, then cell-by-cell — graded progressively.
- Ladder of texture: clean piano → jazz trio voicings → (later) real-recording excerpts.
- Ties into Pocket Session: cells you missed become SRS items.

## Curriculum (maps to the research ladder)

| Level | Content | Exercise types |
|---|---|---|
| 0 | Tonic orientation | Find/sing Do; resolve note to Do |
| 1 | Diatonic degrees (major) | Cadence → degree ID; sing requested degree (self-checked against the aural reveal — never mic-graded) |
| 2 | Minor + chromatic degrees | All 12 colors; contextual intervals |
| 3 | Melodic phrases | Degree dictation of fragments; echo phrases (self-checked on commute, MIDI-graded at the piano) |
| 4 | Chord qualities | Decomposition drills: bass/3rd/7th; maj7 m7 7 m7b5 dim7; inversions |
| 5 | Guide tones & ii-V-I | 3rd/7th line tracking; major/minor ii-V-I; resolved vs deceptive V |
| 6 | Bass lines & cells | Root tracking; turnarounds, blues variants, rhythm changes, back-door, tritone sub — each linked to standards |
| 7 | Colors & voicings | Extensions/alterations as colors; upper structures; voicing types |
| 8 | Whole tunes | Tune Workbench mastery; form + landmarks in 1–2 listens |

Progression is gated by SRS mastery, not XP. Users can place-test past early rungs.

## Architecture (Crux)

```
┌─────────────────────────────────────────────┐
│ Swift shell (SwiftUI)                       │
│  • Audio render: AVAudioEngine sampler      │
│    (SoundFont piano/bass/ride) from core-   │
│    emitted score events                     │
│  • MIDI in (CoreMIDI, BT/USB) → core events │
│  • Mic capture → buffers to core (acoustic  │
│    instrument detection, later phase)       │
│  • Earbud tap / remote-control events       │
│  • Background-audio session, lock-screen    │
│    controls (Pocket Session ≈ podcast app)  │
└──────────────▲───────────────▼──────────────┘
        effects (Capabilities)   events
┌─────────────────────────────────────────────┐
│ Rust core (crux_core)                       │
│  • Music theory engine: keys, chords,       │
│    voicings, progression-cell grammar,      │
│    voice-leading generator (guide tones)    │
│  • Exercise generator: rung + SRS queue →   │
│    concrete score (notes, timing, key)      │
│  • Session state machine (user-paced        │
│    Pocket flow, Banacos error loop)         │
│  • SRS scheduler (FSRS-style decay model)   │
│  • Played-answer grading (MIDI events;      │
│    later: note detection on mic buffers)    │
│  • Progress store (via KV/storage effect)   │
└─────────────────────────────────────────────┘
```

- Core is pure and platform-free: exercise = deterministic function of (rung, SRS state, RNG seed) → fully testable in Rust, no simulator needed.
- Audio out as an effect: core emits `PlayScore(events)` — shell realizes it with a sampler. Core never touches an audio API.
- The shell's earbud/remote-command and background-audio/lock-screen duties shown above belong to the deferred pocket mode, not the MVP (foreground-first, 2026-07-07).
- Pitch detection in Rust keeps grading logic testable and portable (Android/web shells later get it free).
- Everything offline; no accounts, no server. One-time purchase positioning.

## Alternate concepts considered

- **B. "Changes Gym"** — only Rung 5–6 (progression cells linked to standards), no curriculum below. Sharper wedge, but abandons the beginner ladder and the research says degree-hearing is the prerequisite. → Folded in as Levels 5–6 + Tune Workbench.
- **C. "Sing First"** — voice-input-first call-and-response app. Highest pedagogical transfer but hardest tech risk (pitch tracking UX) and awkward on a crowded train. → Initially folded in as a voice mode; **dropped entirely 2026-07** (voice UX judged not good enough) in favor of instrument call & response via MIDI/audio.

## Build phases

1. **MVP:** Core theory engine + Levels 0–2 + Pocket Session (foreground, tap-paced loop — tap to start / reveal / grade; aural + on-screen reveal) + SRS. *This alone already beats Functional Ear Trainer + Sonofield for a jazz user.*
2. **Harmony:** Levels 4–5 (chord decomposition, guide tones, ii-V-I) with jazz voicing textures.
3. **Cells & tunes:** Level 6 + Tune Workbench (needs a small standards/changes dataset).
4. **Instrument I/O:** MIDI (Bluetooth/USB) call & response and
   play-what-you-hear at the piano; Level 3 phrase echo grading.
5. **Piano companion, expanded:** acoustic-instrument note detection on mic
   buffers; Level 7 voicing identification + reproduction.
6. **Pocket mode (deferred exploration, no committed slot):** the hands-free
   variant — auto-pacing, background audio, lock screen / Now Playing / Live
   Activity, earbud-tap control, shadow mode. Revisit only after the manual
   foreground loop is dogfooded.
