# Turing

Influenced by [Turing.jl](https://github.com/TuringLang/Turing.jl), I would like to answer the question: what if we could produce a library that compiled arbitrary Mojo code into a holistic recommender system that could run on arbitrary compute. The use case I have in mind is producing a monorepo, populated with git submodules from contributors around the internet, compiled into a real recommender system driven via community engagement.

Imagine world-renowned physicists maintaining gravity and temperature, chemists managing lifespans and barriers, biologists maintaing evolution and memory, all in a system that compiles down to a nighly binary, with enforced higher-kinded types. That's the vision.

I am actively seeking collaborators, so please don't hestitate to reach out ([jordanrule@gmail.com](mailto:jordanrule@gmail.com)).

_____

This repository provides a demonstrative Mojo framework for Bayesian probabilistic programming with **higher-kinded-type-style constraints**. Mojo does not currently expose full Haskell-style HKTs directly, so this project models them using typed wrappers and compile-time traits.

## What this demo includes

- `src/hkt_probprog.mojo`: core mini-framework (model context, typed priors, posterior update, and target abstraction for CPU/GPU compilation).
- `src/main.mojo`: tiny executable that builds and runs a recommendation posterior update.
- `examples/social_reco_demo.mojo`: social-media flavored demonstration using the same framework.
- `tests/test_hkt_demo.mojo`: lightweight correctness check for posterior updates.
- `LICENSE`: BSD 3-Clause license.
- `CONTRIBUTING.md`: contributor workflow, coding standards, and PR expectations.
- `AGENTS.md`: future design considerations and architecture roadmap.

## Layman explanation

Think of this as a recommendation engine where each behavior (likes, follows, dwell time) is a probabilistic signal rather than a hard fact.

- We start with a prior belief: "this user probably likes science posts."
- New evidence arrives: they liked 7 physics posts and skipped 2 entertainment posts.
- Bayesian inference updates confidence.
- The type system ensures that we only combine compatible probability containers and model stages.
- The same model graph can be lowered to different compile targets (`CPU`, `GPU`) through a shared interface.

In a real social-media recommender, this would let contributors add independent model modules (for interests, freshness, trust, etc.) while preserving strict type-level compatibility when composing them.

## Sample

```mojo
from src.hkt_probprog import (
    CPU,
    BayesianScore,
    FeatureSignal,
    GaussianPrior,
    HKTInferenceEngine,
)

def main() raises:
    let engine = HKTInferenceEngine[CPU]()
    var score = BayesianScore[FeatureSignal](
        GaussianPrior(mu=0.45, sigma=0.20),
        evidence_weight=0.0,
    )

    # User engaged with science content above baseline.
    score = engine.observe(score, observed=0.82, confidence=0.75)
    print("Posterior relevance:", score.posterior_mean())
```

The update combines prior belief and observed signal into a posterior relevance score. In production, that posterior can feed ranking: higher posterior means more likely the user wants similar content next.

## Quick start

```zsh
mojo src/main.mojo
mojo examples/social_reco_demo.mojo
mojo tests/test_hkt_demo.mojo
```

## Notes

- This is a focused demonstration, not a full production framework.
- The `ComputeTarget` abstraction is intentionally small, but it is designed as the seam where backend lowering (including GPU) plugs in.


