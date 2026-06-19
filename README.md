# Turing

![Status](https://img.shields.io/badge/status-demo-blue)
![Language](https://img.shields.io/badge/language-Mojo-orange)
![License](https://img.shields.io/badge/license-BSD--3--Clause-green)

Inspired by [Turing.jl](https://github.com/TuringLang/Turing.jl), this project explores a simple question:

Can we compile arbitrary Mojo model code into a holistic recommender system that runs across heterogeneous compute targets?

The long-term use case is a monorepo with curated git submodules from contributors across domains, composed into one real recommender system driven by community engagement.

The vision is intentionally ambitious: world-renowned physicists maintaining gravity and temperature modules, chemists maintaining lifespan and barrier modules, biologists maintaining evolution and memory modules, all compiled to a nightly binary with strict higher-kinded-type-style guarantees.

I am actively seeking collaborators, so please do not hesitate to reach out at [jordanrule@gmail.com](mailto:jordanrule@gmail.com).

_____

This repository is a demonstrative Mojo framework for Bayesian probabilistic programming with type-safe composition and a backend seam for CPU/GPU lowering.

## Why HKT-style constraints matter

In Haskell/Scala, higher-kinded types (HKTs) let you express constraints over *type constructors* (for example, "a probability container parameterized by a domain kind") rather than only over concrete types.

Mojo does not currently expose full HKT syntax, so this project models the same intent using generic wrappers and traits:

- `KindTag` marks semantic domains (for example, `FeatureSignal`, `TrustSignal`).
- `BayesianScore[K]` binds a probabilistic score to one domain kind `K`.
- `HKTInferenceEngine[T]` binds inference behavior to a compute target `T` (`CPU` or `GPU`).

This is important because it prevents invalid composition at compile time. For example, if one module outputs a trust-domain posterior and another expects a feature-domain score, the type system can reject that composition before it reaches production ranking.

In probabilistic recommenders, this gives three major benefits:

- **Safer module composition:** independently maintained modules can only connect when kinds are compatible.
- **Stronger Bayesian pipelines:** prior, evidence, and posterior updates stay attached to the correct signal family.
- **Portable execution:** model semantics remain stable while lowering to different compute backends.

## What this demo includes

- `src/hkt_probprog.mojo`: core mini-framework (typed priors, posterior updates, and compute-target abstraction).
- `src/main.mojo`: minimal executable that computes a posterior recommendation score.
- `examples/social_reco_demo.mojo`: social-media flavored ranking demonstration.
- `tests/test_hkt_demo.mojo`: lightweight posterior-update correctness test.
- `CONTRIBUTING.md`: contributor workflow, coding standards, and PR expectations.
- `AGENTS.md`: future design considerations and architecture roadmap.
- `LICENSE`: BSD 3-Clause license.

## Design principles

| Principle | What it means in this repo | Why it matters for recommenders |
| --- | --- | --- |
| Type-safe composition | `BayesianScore[K]` and `KindTag` keep probabilistic signals domain-specific. | Prevents invalid module wiring across independently maintained components. |
| Bayesian-first modeling | Prior + evidence updates produce posterior relevance with explicit uncertainty. | Improves ranking decisions when data is sparse, noisy, or changing. |
| Backend-agnostic execution | `HKTInferenceEngine[T]` and `ComputeTarget` separate model semantics from execution target. | Lets the same model graph run on CPU today and GPU-oriented paths as backends mature. |
| Modular ecosystem design | Core contracts live in `src/`; future domain modules can plug in through stable typed interfaces. | Enables community collaboration without sacrificing compatibility or reproducibility. |

## Sample

```mojo
from src.hkt_probprog import (
    CPU,
    BayesianScore,
    FeatureSignal,
    GaussianPrior,
    HKTInferenceEngine,
)

fn main() raises:
    let engine = HKTInferenceEngine[CPU]()
    var score = BayesianScore[FeatureSignal](
        GaussianPrior(mu=0.45, sigma=0.20),
        evidence_weight=0.0,
    )

    # User engaged with science content above baseline.
    score = engine.observe(score, observed=0.82, confidence=0.75)
    print("Posterior relevance:", score.posterior_mean())
```

The update combines prior belief and observed evidence into a posterior relevance score. In production ranking, higher posterior means a stronger estimate that the user wants similar content next.

## Quick start

```zsh
mojo src/main.mojo
mojo examples/social_reco_demo.mojo
mojo tests/test_hkt_demo.mojo
```

## Project status

- Focused demonstration of core ideas; not yet a production recommender stack.
- The `ComputeTarget` abstraction is the current seam for backend lowering, including GPU-oriented compilation flows.


