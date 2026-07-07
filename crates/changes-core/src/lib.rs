//! Pure Crux core for Changes: theory engine, exercise generation, session
//! state machine, SRS scheduling, grading. No I/O — shells fulfil effects.

pub mod app;

pub use app::{Changes, Effect, Event, Model, ViewModel};
