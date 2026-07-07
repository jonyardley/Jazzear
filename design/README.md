# Handoff: "Changes" — hands-free jazz ear trainer (iOS)

## Overview

Design pass for **Changes**, an iOS app that trains a jazz pianist's ear on the commute: functional-first pedagogy (everything heard against a key center), auto-paced audio sessions usable with the phone in a pocket, spaced repetition, and error-driven comparison loops. This package covers the chosen visual direction ("Blue Hour Console"), the full Pocket Session state set, onboarding/placement, progress surfaces, Tune Workbench (med-fi), Call & Response (concept), and a working choreography prototype with synthesized audio.

Product context lives in the repo docs: `docs/DESIGN_BRIEF.md` (v0.2), `docs/CONCEPT.md` (architecture: SwiftUI shell + Crux/Rust core), `docs/RESEARCH.md` (pedagogy). Read the brief first — its design principles are non-negotiable and this design implements them.

## About the Design Files

The files in this bundle are **design references created in HTML** — prototypes showing intended look and behavior, **not production code**. The task is to recreate these designs in the target environment — per the concept doc that is **SwiftUI (iOS 17+) with a Crux (Rust) core** — using its established patterns (AVAudioEngine sampler for audio, Live Activities for lock screen/Dynamic Island, etc.). Do not port the HTML/JS directly.

- `Changes - Direction Take.dc.html` — the design canvas. Read top-down: **turn 4** (newest) → turn 1. Turn 1 shows the rejected alternate direction (1b) for context only; **1a "Blue Hour Console" is the chosen direction**.
- `Pocket Session Flow.dc.html` — interactive prototype of the flagship loop. Its timing, state machine, and audio behavior are **the product spec**, not an illustration.
- `ios-frame.jsx`, `support.js` — scaffolding so the HTML files render; irrelevant to implementation.

## Fidelity

- **High-fidelity**: Pocket Session (all states), lock screen + Dynamic Island, onboarding + placement, Home hub, Ladder, item detail, visual-language system. Recreate pixel-close using the tokens below.
- **Medium-fidelity**: Tune Workbench (canvas option 3c) — layout and reveal mechanic are decided; polish is not.
- **Concept only**: Call & Response (3d) — direction for the feedback tone, not a final layout.

## Design Tokens (Direction 1a — dark-first; light mode not designed yet)

Colors:
- Background: `#17141C` · deep background / canvas gutter: `#141118` · near-black: `#0E0C10`
- Surface (cards, pills, buttons): `#211D29` · raised surface highlight: `#2B2436`
- Text primary: `#F2EEF7` · secondary: `#9B93AB` · tertiary/faint: `#6F6880` · disabled/locked: `#4A4458`
- Accent (violet): `#A58FE0` · accent borders: `rgba(165,143,224,.45)` · accent glow: `0 0 60px rgba(165,143,224,.28)`
- Hairlines: `rgba(255,255,255,.08)`
- Chord-quality hues: maj7 `#D9A854` (gold) · m7 `#7D99C9` (dusty blue) · dom7 `#CF7A52` (coral) · m7♭5 `#B07FAE` (mauve) · dim7 `#8B8FA3` (slate)
- Tension hues (temperature shifts on the dominant): ♭9 `#A84C42` · ♯9 `#C25A8A` · ♯11 `#5AA3A0` · ♭13 `#B8813F` · 13 `#D99B4E`
- Mastery ramp: new = hollow `#4A4458` outline · learning `#4A3F63` · solid `#7A68B3` · mastered `#A58FE0` + glow `0 0 12px rgba(165,143,224,.8)`
- Lead-sheet ink (Workbench chart + keyboard diagram keys): cream `#ECE4D3`, key ivory `#E9E5F0`

Typography (Google Fonts in the prototype; use closest available or bundle):
- **Space Grotesk** — all UI: labels, numbers, buttons. Weights 400–700. Overline labels: 12–14px, letter-spacing .10–.12em, uppercase, color secondary.
- **Newsreader italic** — musical content ONLY: chord symbols, keys, quality names, encouragement lines. Chord symbol at reveal: 84–96px/1.0, letter-spacing −0.02em; extensions colored by tension hue.
- Never mix roles: the machine speaks grotesque, the music speaks serif.

Shape & spacing:
- Screen padding: 28px horizontal. Cards/tap-zones radius 20–22px; pills fully rounded (99px). Answer tap zones: full-width halves, 104px tall (comfortably > 44px min target). Progress bars 3–4px, radius 2px.
- The one glowing object rule: at most one glow-accented element per screen (play button, current rung, active card).

## Visual Language for Musical Content (canvas 2a + 4a)

1. **Quality = hue + shape**: maj7 gold circle · m7 blue rounded square · 7 coral diamond · m7♭5 mauve hollow diamond · dim7 slate split diamond. Used at reveal, in Ladder skills, item detail, recaps.
2. **Tension = temperature shift** of the base hue (see tokens). The extension text in a chord symbol takes the tension hue (`G7` white + `♭9` in `#A84C42`... in the prototype the dominant coral is used for ♭9 at reveal; canvas 2a/4a shows the full tension palette — treat the tension palette as canonical).
3. **Mastery = light**, never XP: the 4-step ramp above. Streaks are minutes-of-work.
4. **"Sound before sign" (brief principle 7)**: musical visuals (symbols, keyboard diagrams, contours) appear **only at answer reveal and in review/progress surfaces** — never while listening or answering. During listening: level-meter bars only (no pitch info). During thinking gap: countdown ring only. **No engraved staff notation anywhere.**
5. **Mini keyboard diagram** (canvas 4a/4b; live in flow prototype): 2–3 octave keyboard, ivory keys `#E9E5F0` on `#0E0C10`, sounding notes marked with dots in the quality hue (dots on black keys = filled bottom segment). Appears ~400ms after the chord symbol at reveal. Caption style: "rootless, left hand — the shape you'd grab".
6. **Guide-tone contour** (canvas 4a/4c): two voices (3rd & 7th) as dots across chord columns; static lines `#4A4458`, half-step resolutions highlighted `#A58FE0` with "½ step" annotation; chord names in Newsreader italic below. Used at progression reveals, item detail, Workbench review.

## Screens / Views

All are on the canvas file; labels below match `data-screen-label` attributes.

### Journey 1 — Pocket Session (flagship)
- **Pre-session / Home** (turn 1, 1a): wordmark CHANGES (13px, .22em), date; "TODAY / 18 min · Rung 4 / Chord qualities · 12 reviews due" (serif italic accent line); 190px circular play button (radial `#2B2436→#211D29`, violet border + glow); duration pills 10/18/25 + divider + "shadow" toggle; footer stats row (minutes this week, weakest pair) above hairline.
- **Context/listening**: key badge pill top-left ("in E♭" with gold dot), counter "7 / 22 · 11:24 left", pause button; center: LISTEN overline + 7 violet level bars + "establishing E♭ major" (serif). Answer zones visible but 25% opacity.
- **Question**: "QUALITY OF THIS CHORD" overline; 150px circle outline with serif violet "?" pulsing.
- **Thinking gap**: "NAME IT — OUT LOUD OR IN YOUR HEAD"; 150px SVG countdown ring (track `#211D29`, arc `#A58FE0`, 5px, round cap) draining clockwise.
- **Answer reveal** (turn 4, 4b is canonical): "IT WAS" overline → chord symbol 84px Newsreader italic → quality dot + name → **mini keyboard diagram** → caption. Answer zones at full opacity: "Got it / TAP EARBUD ×1" and "Missed it / TAP EARBUD ×2".
- **Miss / comparison** — two treatments mocked, **pick one with the user**: 2b two cards A/B-ing (active card gets violet border + hue glow, PLAYING/NEXT labels) or 2c pendulum (two chord names vertically, oscillating arc between). Both: teaching line in serif violet ("hear the seventh drop a half step"), exit button "I hear it — continue". Hands-free: names spoken before each playback, earbud tap ×1 exits.
- **Paused**: "take your time — E♭ will still be here" (serif), Resume button, "PROGRESS SAVED · SESSION RESUMES MID-ITEM".
- **Interrupted**: auto-hold when other audio detected (route announcements, Siri): amber-bordered banner "Other audio detected — holding", "resuming when it's quiet · replays the item". No item is ever lost to an interruption.
- **Session complete**: "SESSION COMPLETE · 18:12" + "Nice ears tonight." (serif, 32px); ledger rows (reviewed, newly mastered w/ glow dots, weakest pair, due tomorrow, rung progress bar 68%); "TONIGHT AT THE PIANO" card (violet-bordered) bridging to instrument practice.
- **Progression reveal, Rung 5** (4c): ii–V–I reveal with guide-tone contour.

### Lock screen & Dynamic Island (turn 2, 2e) — primary UI, not chrome
- Lock screen Live Activity: app icon (♭ glyph on dark tile, violet border), "Chord qualities — in E♭", "Changes · item 7 of 22", time left, progress bar, podcast-style transport (back = replay item, forward = skip). Media-key semantics match podcasts; play/pause never remapped.
- Island compact: 3 violet waveform bars + "7/22". Island expanded: icon, "in E♭ · quality of this chord?", phase status ("thinking gap · 3s"), pause, progress. **The answer is never shown on the island during the gap.**

### Journey 2 — Onboarding & placement (turn 3, 3a)
Welcome ("Learn to hear changes." 52px serif; promise copy; violet Begin; "one-time purchase · offline · no account") → context capture (instrument / self-assessment / session length as big pill selectors, one-handed) → placement test (Pocket Session look, "5 / 12 · ~2 min left", reassurance copy "we're finding your rung, not scoring you", Got it / Not sure) → **"you're here" moment**: 9-rung ladder bottom-up, rungs 0–2 struck-through "PLACED OUT", rung 4 card glowing with description, CTA "Start Rung 4 tomorrow morning".

### Journey 3 — Progress (turn 3, 3b)
- **Home hub**: today card (small glowing play + session summary), THIS WEEK bar chart (7 day bars, today violet + glow; total "142 min"), "NEEDS YOUR EAR" weakest-item rows (shape glyph + serif name + % + play affordance), current-rung progress footer.
- **The Ladder**: all 9 rungs bottom-up (0 Tonic orientation → 8 Whole tunes), per-rung skill dots in mastery ramp, current rung enlarged + glowing with sub-line "bass → 3rd → 7th → colors · 68%", locked rungs faint with "unlocks at 80%". Footer: "mastery is SRS-measured — dots are skills within a rung, lit when they stay remembered."
- **Item detail**: back to Rung 4; tension dot + "Dominant ♭9" (58px serif, ♭9 in tension hue) + poetic descriptor; 83% mastery ring ("SOLID"); rows: often confused with ♯9 (5 of last 6 misses), next review Thursday, last-10 dot history (misses in `#A84C42`); actions "▶ Hear it" / "A/B vs ♯9".

### Journey 4 — Tune Workbench, med-fi (turn 3, 3c)
- **Tune list**: "Transcribe blind. The chart earns itself." Cards per standard: revealed-bars count, per-bar mini strip (earned `#7A68B3`, current `#A58FE0`, missed `#A84C42`, unknown `#2B2436`), status line (form ✓ · landmarks ✓ · cell-by-cell). Texture ladder note: clean piano → jazz trio → real recordings.
- **Revealing lead sheet**: real-book-style 4-column bar grid, cream hairlines `rgba(236,228,211,.3)`; earned cells = cream chord symbols (serif), unknown = faint "— —", current cell violet-tinted with inset border + "?", missed cells red with "MISSED ×2" tag; legend; footer card "Play bars 5–8 again / missed cells flow into tomorrow's Pocket Session".

### Journey 5 — Call & Response, concept (turn 3, 3d)
"SING THE 3RD / any octave you like"; tuner arc FLAT–THERE–SHARP filling toward "there" (needle dot on arc, no numeric cents); coaching copy in serif ("a hair under — lean up into it"); small live level bars; "LISTENING · SAY 'SKIP' TO PASS". Principle: **never a red X — the needle is information, the words are the teacher.** Tolerance widens when walking (motion detected).

## Interactions & Behavior — the Pocket Session state machine

This is the product. From `Pocket Session Flow.dc.html` (timings validated by ear in the prototype):

States: `pre → [per item: context → question → gap → reveal → (compare)] → recap`, plus `paused` overlay from any in-session state.

- **context** (~3.6s): ii–V–I cadence establishes the key (in the prototype: Fm7 0.95s → B♭7 0.95s → E♭maj7 1.5s, slight roll). Level bars animate. No pitch visuals.
- **question** (~2.6s): the item's chord plays once (~2.2s sustain), "?" pulses.
- **gap** (default 4s, **user-configurable 2–8s**): silence on purpose; countdown ring drains; no visual hints.
- **reveal**: chord plays again (~1.6s); symbol appears, keyboard diagram follows ~400ms later. In the real app the answer is **also spoken** (core to eyes-free use) — the HTML demo omits the voice by explicit stakeholder request (annoying in a demo loop), do not read that as a product decision; spoken-answer on/off should be a setting.
  - **Auto-continue OFF (default)**: session waits indefinitely for self-report (screen tap or earbud tap ×1 got / ×2 missed).
  - **Auto-continue ON (pro setting, also on pre-session screen)**: advances ~5.2s after reveal, treating no-report as "got it".
- **compare (Banacos loop)**, on miss: alternates the missed sound with its confusable twin every ~1.7s (audio + visual highlight sync), teaching line explains the moving tone; user exits when ready (button / earbud tap). Then next item's context.
- **pause**: suspends audio + timers exactly where they are; resume replays the current phase's audio (gap restarts). Auto-pause on external audio (interrupted state) behaves the same and auto-resumes, replaying the item.
- **recap**: summary + "tonight at the piano" nudge.
- Progress bar advances per item (width transition .5s). Zones fade 25%↔100% opacity (.3s) with phase.

Transitions elsewhere: toggle knob .2s; glows are static (no pulsing except the question "?" at 1.6s ease-in-out soft pulse).

## State Management (app-level, maps to Crux core)

- Session: `screen`, `phase`, `itemIdx`, `paused`, per-item result, gap progress, compare-side flag — all owned by the core's session state machine per `docs/CONCEPT.md`; the SwiftUI shell renders and forwards earbud/remote events.
- Settings surfaced in this design: session length (10/18/25), shadow mode (listen-only, no grading), auto-continue (default off), thinking-gap length (2–8s), spoken answers.
- SRS drives: today's queue size/duration, mastery %s, weakest pairs, next-review dates, ladder gating (80% to unlock next rung).

## Audio (reference only)

The prototype synthesizes chords with WebAudio (triangle + sine octave, lowpass ~2.4kHz, 35ms note roll) — a placeholder. Production per concept doc: SoundFont piano/bass/ride via AVAudioEngine, rootless/shell jazz voicings, swing textures. The *sequencing* (what plays when, for how long) is the spec; the *timbre* is not.

## Assets

No image assets. Fonts: Space Grotesk + Newsreader (Google Fonts). The ♭/♯/° glyphs are plain Unicode text. Everything else is drawn UI.

## Files

- `Changes - Direction Take.dc.html` — canvas: turns 4 (newest) → 1; option ids referenced above (1a, 2a–2e, 3a–3d, 4a–4c)
- `Pocket Session Flow.dc.html` — live flow prototype (open in a browser, sound on)
- `ios-frame.jsx`, `support.js` — rendering scaffolding for the above; not part of the design

## Open decisions (ask the stakeholder)

1. Miss-comparison treatment: 2b two-cards vs 2c pendulum.
2. Light mode (brief: secondary) — not designed.
3. Exact tension-hue usage at reveal: prototype colors ♭9 with the dominant coral; the system sheet defines a distinct ♭9 red. Recommend the system sheet's tension palette.
