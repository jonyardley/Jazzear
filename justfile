# Changes task runner. `just` lists recipes; `just ci` mirrors CI locally.

default:
    @just --list

# One-time per clone: install git hooks (pre-push runs the fast gates)
setup:
    git config core.hooksPath .githooks
    @echo "hooks installed — pre-push now runs fmt + clippy + test"

fmt:
    cargo fmt

fmt-check:
    cargo fmt --check

clippy:
    cargo clippy --workspace --all-targets -- -D warnings

test:
    cargo test --workspace

deny:
    cargo deny check

links:
    python3 .github/scripts/check_doc_links.py

# Fast gate mirror — the pre-push hook runs this
pre-push: fmt-check clippy test

# Full CI mirror — run before opening a PR
ci: fmt-check clippy test deny links
    @echo "all local gates green"

# ── iOS (lands with M0-iOS; names mirror intrada) ──────────────────────

ios:
    @echo "M0-iOS not scaffolded yet — see docs/specs/mvp-plan.md (M0)" && exit 1

ios-run:
    @echo "M0-iOS not scaffolded yet — see docs/specs/mvp-plan.md (M0)" && exit 1

ios-gen:
    @echo "M0-iOS not scaffolded yet — see docs/specs/mvp-plan.md (M0)" && exit 1

ios-logs:
    @echo "M0-iOS not scaffolded yet — see docs/specs/mvp-plan.md (M0)" && exit 1
