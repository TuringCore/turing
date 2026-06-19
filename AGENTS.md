# AGENTS

This document captures future design considerations for building a modular, community-driven recommender system compiler in Mojo.

## Mission

Enable contributors to build independent probabilistic modules that compose safely and compile to heterogeneous compute targets (CPU/GPU and beyond).

## Core architectural principles

- **Type-safe composition:** keep HKT-style constraints so modules only compose when kinds are compatible.
- **Bayesian-first modeling:** represent uncertainty explicitly and update beliefs via evidence.
- **Backend-agnostic execution:** define model semantics once, lower to multiple targets.
- **Monorepo with curated submodules:** allow external domain modules while preserving reproducibility.
- **Deterministic integration:** pin dependencies and build artifacts for repeatable model graphs.

## Type-system direction (HKT-inspired)

Current pattern:

- `KindTag` marks domain kinds.
- `BayesianScore[K]` binds probability containers to a kind.
- `HKTInferenceEngine[T]` enforces compute-target specialization.

Future direction:

- Introduce typed combinators (`map`, `flat_map`, `zip`) that preserve kind constraints.
- Add phantom-type stage markers (`Prior`, `Posterior`, `Calibrated`) to prevent invalid pipeline ordering.
- Add compile-time checks for cross-module compatibility (signal kind, units, calibration schema).

## Probabilistic programming roadmap

- Add richer distributions (Bernoulli, Beta, Categorical, Multivariate Gaussian).
- Add approximate inference adapters (VI, MCMC-lite, particle updates).
- Add calibration and uncertainty reporting interfaces for downstream ranking.
- Add counterfactual hooks for exploration/exploitation policy simulation.

## Compute and compiler interface roadmap

- Expand `ComputeTarget` to include capability traits (SIMD width, memory model, precision).
- Add IR boundary APIs so probabilistic graphs can lower to target-specific kernels.
- Add batching and streaming interfaces for online recommendation updates.
- Add GPU execution profiles with deterministic fallback to CPU.

## Monorepo and submodule strategy

- Keep core contracts in-repo (`src/`) with strict API versioning.
- Allow domain submodules (physics, biology, trust, graph dynamics) under `modules/` via git submodules.
- Require each submodule to expose:
  - a typed interface contract,
  - at least one integration test,
  - metadata for provenance and maintainer ownership.
- Pin each submodule to reviewed commits; advance pins through explicit PRs.

## Governance and decision-making

- Use lightweight RFCs for major changes (type contracts, inference semantics, backend ABI).
- Require at least one maintainer approval from core plus one domain reviewer when applicable.
- Prefer additive evolution over breaking changes; version contracts when breaks are unavoidable.

## Security and trust considerations

- Treat submodules as third-party code: run static checks and integration tests before pin updates.
- Keep build and inference paths reproducible for auditability.
- Track provenance for model components used in production recommendations.

## Milestones

1. **M1 - Typed foundation:** stabilize kind-safe core APIs and test matrix.
2. **M2 - Backend seam:** formalize compile boundary and target capability traits.
3. **M3 - Module ecosystem:** onboard first external submodules with CI contract checks.
4. **M4 - End-to-end demo:** social-media ranking pipeline with uncertainty-aware serving.
5. **M5 - Production hardening:** observability, profiling, deterministic builds, and governance automation.

