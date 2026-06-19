# Contributing

Thanks for helping build this project.

## Ways to contribute

- Improve the Mojo probabilistic-programming framework in `src/hkt_probprog.mojo`.
- Add new examples under `examples/`.
- Add tests under `tests/`.
- Improve docs and architecture notes (`README.md`, `AGENTS.md`).

## Local setup

1. Install Mojo from the official Modular toolchain.
2. From the repository root, run the demo and tests:

```zsh
mojo src/main.mojo
mojo examples/social_reco_demo.mojo
mojo tests/test_hkt_demo.mojo
```

If Mojo is not installed, open a draft PR anyway with code/docs; maintainers can help validate runtime behavior.

## Coding guidelines

- Keep code idiomatic Mojo and prefer clear, small abstractions.
- Preserve HKT-style type safety patterns in `BayesianScore[K]` and `HKTInferenceEngine[T]`.
- Keep APIs additive and backward-compatible when possible.
- Use ASCII unless a file already requires Unicode.
- Add brief comments only when logic is non-obvious.

## Tests and validation

- Add or update tests for behavior changes.
- Include at least one positive path example for new model features.
- If changing math, include expected-value checks similar to `tests/test_hkt_demo.mojo`.

## Commit and PR expectations

- Use focused commits with descriptive messages.
- Open a PR with:
  - what changed,
  - why it changed,
  - how to run/verify,
  - known limitations.
- Link related issues when relevant.

## Design process

For substantial architecture changes, open an issue first and reference `AGENTS.md`.

Suggested issue labels:

- `kind/type-system`
- `inference`
- `backend-gpu`
- `docs`
- `good-first-issue`

## Community

Be respectful, constructive, and explicit about assumptions. This project is intentionally collaborative and cross-disciplinary.

