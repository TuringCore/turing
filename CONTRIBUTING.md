# Contributing

Thanks for helping improve `turing`.

## Scope of this repository

`/turing` is a library-first repository. Prioritize:

- Safe, typed probabilistic abstractions in `src/turing/hkt_probprog.mojo` (exported via `src/turing/__init__.mojo`).
- Small, clear examples in `examples/`.
- Deterministic behavior checks in `tests/`.
- Practical documentation updates in `README.md`.

Avoid broad application-specific logic here; put app behavior in consumer repos (for example `/bluesky`).

## Local setup

1. Install Mojo from the official Modular toolchain.
2. From this repository root, run:

```zsh
mojo -I src src/main.mojo
mojo -I src examples/social_reco_demo.mojo
mojo -I src tests/test_hkt_demo.mojo
```

If Mojo is not installed, open a draft PR with code/docs and call out unverified runtime behavior.

## Coding guidelines

- Keep APIs stable and additive.
- Preserve type-safety patterns in `KindTag`, `BayesianScore[K]`, and `HKTInferenceEngine[T]`.
- Keep compile-target semantics explicit via `ComputeTarget`.
- Use ASCII unless a file already requires Unicode.
- Add brief comments only when logic is non-obvious.

## Tests and validation

- Add or update tests for behavior changes.
- If changing math, include explicit expected-value checks.
- Prefer small, deterministic inputs over opaque random tests.

## Commit and PR expectations

- Use focused commits with descriptive messages.
- In PRs, include:
  - what changed,
  - why it changed,
  - how to run and verify,
  - known limitations.

## Community

Be respectful, precise, and explicit about assumptions so multiple contributors can collaborate safely.
