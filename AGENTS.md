# AGENTS

This file captures practical maintenance guidance for `turing` as a conservative probabilistic-programming library.

## Mission

Keep Bayesian inference building blocks simple, type-safe, and easy for multiple contributors to evolve without breaking compatibility.

## Current boundaries

- Library contracts live in `src/hkt_probprog.mojo`.
- Examples live in `examples/` and should stay short and educational.
- Tests live in `tests/` and should focus on deterministic math checks.
- Application behavior belongs in downstream repos that import `turing`.

## Stability principles

- **Type safety first:** preserve `KindTag`, `BayesianScore[K]`, and `HKTInferenceEngine[T]` semantics.
- **Conservative API evolution:** prefer additive changes and clear defaults.
- **Predictable compilation:** keep `ComputeTarget` behavior explicit and documented.
- **Small review surface:** choose simple abstractions over deep framework layering.

## Contributor workflow

1. Propose changes with a short problem statement and expected behavior.
2. Add or update tests before extending APIs.
3. Document any compile-target implications in `README.md`.
4. Keep examples aligned with supported public APIs.

## Near-term roadmap

1. Expand distribution support with bounded, test-driven additions.
2. Add stricter validation helpers for confidence/evidence inputs.
3. Improve compile-kernel metadata for downstream observability.
4. Keep integrations in separate app repos (for example `/bluesky`).
