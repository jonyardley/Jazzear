# MVP Implementation Plan — Pocket Session (Phases 0–1)

*Tier 3 spec. Turns `design/` (Claude Design handoff, 2026-07) + `docs/CONCEPT.md`
into a build order. Last reviewed: 2026-07-07.*

## Problem

We have validated research, a concept, and a high-fidelity design with a
working choreography prototype. Nothing is built. The riskiest assumptions are
technical (glitch-free, sample-accurate audio on iOS), not product. Build in
an order that retires risk first and turns the design's state machine into
the shippable MVP: **Pocket Session, curriculum Levels 0–2, SRS —
foreground, touch-driven, user-paced (tap to start, tap to reveal, tap to
grade).**

## Design ↔ MVP reconciliation (read this first)

The design's hero content is Rung 4 (chord qualities, keyboard diagram at
reveal) because it shows the visual language best. **The MVP ships Rungs 0–2
(scale degrees) in the exact same session frame.** Nothing in the design
changes — the reveal simply shows a degree ("♭3 — resolves down to… do")
instead of a chord symbol, and the keyboard diagram / quality glyphs arrive
with Phase 2 content. Build the frame once; content types plug in.

## Key decisions

1. **Miss-comparison treatment: 2b two-cards** (not 2c pendulum). Maps 1:1 to
   the audio A/B alternation, simpler to build, identical interaction
   behaviour. Pendulum stays on the canvas as a possible later delight pass.
   *(Open decision 1 from the design handoff — recommended, cheap to revisit.)*
2. **Tension palette: the system sheet (canvas 2a/4a) is canonical**, per the
   handoff's own recommendation. The prototype's coral-♭9 is a bug.
3. **Superseded (2026-07-07): the lock-screen layer is deferred.** Now
   Playing / `MPRemoteCommandCenter`, the Live Activity / Dynamic Island
   layer, and earbud remote commands all belong to the deferred pocket mode
   (decision 10). The MVP has no lock-screen surface.
4. **Superseded (2026-07-07): earbud answer input is deferred** with the
   pocket mode (decision 10). The phase-contextual mapping documented in the
   design handoff (reveal: play/pause → `GotIt`, next-track → `MissedIt`;
   compare: play/pause → `ExitCompare`) is the starting point when that mode
   is picked up. MVP input is on-screen touch only.
5. **No voice, in either direction (stakeholder decision, 2026-07).** No
   text-to-speech answers, no sung-answer grading, no voice commands or
   speech recognition — the design handoff's spoken-answer references are
   superseded. Audio is output-only music; every input is an on-screen
   touch. The reveal is **aural plus on-screen**: a degree resolves stepwise
   to the tonic (the resolution path names it — the Benbassat move); a chord
   replays as its decomposition arpeggio (bass → 3rd → 7th → color), with
   the answer shown on screen. If M2 dogfooding shows the aural reveal is
   ambiguous for some item types, the fix is better per-type reveal design —
   **never voice audio of any kind**; the earlier pre-recorded-human-clip
   fallback idea is rejected (stakeholder decision, 2026-07-07).
6. **SRS: FSRS-style scheduler in `changes-core`.** Evaluate `fsrs-rs` (the
   Anki implementation) first — **check its license fits a paid closed-source
   app before adopting**; otherwise implement SM-2 behind the same trait so
   the scheduler can be swapped without touching callers.
7. **Fonts: bundle Space Grotesk + Newsreader** (both SIL OFL — bundling in a
   paid app is fine, keep the OFL notices). "Machine speaks grotesque, music
   speaks serif" is a token-level rule: `ChangesFont.ui*` vs
   `ChangesFont.music*`.
8. **Timings are config data, not constants in code.** The prototype's values
   (context 3.6s, question 2.6s, gap 2–8s default 4s, auto-continue 5.2s,
   compare alternation 1.7s) live in one core `SessionTiming` struct so
   tuning-by-ear doesn't mean hunting magic numbers.
9. **Manual pacing only in MVP (stakeholder decision, 2026-07-07).** Every
   step is a deliberate on-screen tap: a tap starts an item, the thinking
   gap is open-ended and **the reveal waits for a tap**, the self-grade tap
   doubles as "next", and compare exits on a tap. Do NOT implement a timed
   reveal, auto-continue, or the passive "shadow mode" — auto-paced flow is
   a post-MVP exploration, revisited only after dogfooding the manual loop.
   The gap (2–8s) and auto-continue (5.2s) values in decision 8 are recorded
   for that future mode, not wired to anything.
10. **Foreground-first MVP (stakeholder decision, 2026-07-07).** The MVP is
   used screen in hand; there is no background/lock-screen layer. Background
   audio entitlement, Now Playing + remote commands, earbud-tap input, and
   Live Activity are one bundled deferral with auto-pacing ("pocket mode") —
   hands-free only makes sense once pacing is automatic, so they ship (or
   die) together.

## Milestones (each ≈ one PR-sized chunk; sequential unless noted)

### M0 — Scaffold
Workspace (`changes-core`, `changes-ffi`), xcodegen iOS project, justfile
(`just ios`, `ios-run`, `ios-gen`, `ios-logs` mirroring intrada), CI
(fmt/clippy/test + iOS build), `Theme.swift` with the full handoff token sheet
(`ChangesColor` incl. quality/tension/mastery ramps, `ChangesFont`,
`ChangesSpacing` 28px screen pad / 20–22 radius / 99 pill, glow styles),
bundled fonts. Bindings pipeline proven with a walking-skeleton
`Event::Ping → ViewModel`.

### M1 — Audio spike (make-or-break; go/no-go gate)
Core emits `PlayScore` (abstract score: notes/voicings, onsets, durations,
tempo) → shell realizes on `AVAudioEngine` + SoundFont sampler. `.playback`
session category (sessions must sound with the silent switch on). **Exit
criteria, on a real device:** headphones on, app in the foreground →
tap-driven cadence → chord → reveal items play back-to-back for 5+ minutes
with no glitches, dropouts, or drift; scheduling stays sample-accurate
across items; interruption (Siri/call) and route change (headphones
unplugged) pause and resume correctly. If this fails, the product concept
needs rework — nothing else gets built first. (Background audio, Now
Playing, and earbud commands are deferred with pocket mode, decision 10 —
not part of this gate.)

### M2 — Core session engine
Session state machine exactly per the design spec (`design/README.md`
"Interactions & Behavior"): `pre → [context → question → gap → reveal →
(compare)]* → recap`, pause/interrupted overlays; **manual pacing only** —
no timed reveal, no auto-continue, no shadow mode (decision 9); the gap →
reveal transition and each `→` between items wait for a tap. Exercise generator for Rungs 0–2 (cadence + degree
items, major → minor → chromatic), deterministic from (curriculum, SRS state,
seed). **Aural-reveal score generation** (resolution paths for degrees;
decomposition arpeggios for chords — decision 5). SRS scheduler + daily
queue. GRDB storage effects + migration v1 (`updated_at`/`deleted_at` from
day one). Effect-level tests assert the emitted `PlayScore`/timer sequences —
the choreography is tested without audio.

### M3 — Pocket Session UI
All canvas states, pixel-close to 1a/2b/4b: pre-session, context/listening
(level bars only), question ("?" pulse), gap ("tap to reveal" affordance —
the countdown ring is deferred with auto-pacing), reveal (degree/symbol on
screen + aural reveal playback; answer zones 25%↔100%), compare (2b
two-cards), paused, interrupted (amber banner), complete (ledger + "tonight
at the piano"). Omit the pre-session shadow-mode toggle from the canvases —
deferred with auto-pacing (decision 9). Snapshot test + VoiceOver + Dynamic
Type per screen. (The screen-off pass returns with pocket mode, decision
10.)

### M4 — Interruption robustness + settings
Route-change handling (headphones unplugged = pause, never speaker);
interruption auto-hold with replay-item semantics ("no item is ever lost
to an interruption"); settings surface (session length only — thinking-gap,
auto-continue, and shadow-mode settings ship with the deferred auto-paced
pocket mode, decisions 9–10).

### M5 — Surrounding surfaces
Home hub (today card, week bars, "needs your ear"), Ladder (9 rungs, mastery
dots, 80% gating), item detail, session recap wiring, onboarding + placement
test (3a: welcome → context capture → mini-session placement → "you're here"
ladder moment).

### M6 — Ship prep
App icon (♭ glyph tile), TestFlight lane (fastlane match, mirroring
intrada's setup), OFL notices, one-time purchase wiring deferred until
public TestFlight feedback. (The Live Activity + Dynamic Island layer moved
into the deferred pocket-mode bundle, decision 10.)

## Testing strategy

- Core: state-machine transition tests; property checks on the generator
  ("every item's answer is derivable from its score"); seeded replay.
- Bridge: real-bridge round-trip test for every `Event`/`Effect`/`ViewModel`
  payload **before** it's wired to a screen (intrada #846 lesson).
- Storage: upgrade-path test per migration (populated-at-previous-version).
- UI: snapshot per state; manual device pass for audio feel each milestone.

## Risks & open questions

| Risk | Mitigation |
|---|---|
| Audio gaps/drift over long sessions | M1 gate on real device; sampler pre-scheduled, not per-note dispatched |
| SoundFont quality (jazz piano feel) | Timbre is explicitly not the spec; pick a decent free SF2 now, revisit later |
| `fsrs-rs` license incompatible | SM-2 behind the same trait (decision 6) |
| Aural reveal ambiguous for some item types (can the user *tell* the answer from the resolution/decomposition alone?) | Dogfood in M2; per-type reveal design + the on-screen answer; voice audio is never the fallback (decision 5) |
| Earbud remote-command behaviour varies by vendor; Live Activity update cadence limits | Both deferred with pocket mode (decision 10); revisit if/when that bundle is picked up |

Open with stakeholder: none blocking. Decisions 1–2 above are recommendations
Jon can veto cheaply before M3 (visual) lands; decisions 3–4 are superseded
by the pocket-mode deferral (decision 10) and 5, 9, 10 are settled
stakeholder calls (2026-07-07).
