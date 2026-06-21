# Turing

![Status](https://img.shields.io/badge/status-demo-blue)
![Language](https://img.shields.io/badge/language-Mojo-orange)
![License](https://img.shields.io/badge/license-BSD--3--Clause-green)

`/turing` is a focused Mojo library for conservative Bayesian probabilistic programming.

The goal is to keep large-system inference manageable when multiple contributors add model insights over time. The library intentionally stays small: typed score containers, safe update semantics, and a compile seam that makes execution targets explicit.

## Why this library is conservative by design

- Large probabilistic systems become fragile when teams mix incompatible signals.
- `KindTag` and `BayesianScore[K]` keep signal families separated at compile time.
- `HKTInferenceEngine[T]` makes compute target selection explicit (`CPU`, `GPU`) without changing model math.
- The API limits moving parts so contributors can add evidence updates without rewriting infrastructure.

## Type system and Mojo compile system

This project relies on both language-level typing and Mojo's compilation model:

- **Type constraints:** `KindTag` and `BayesianScore[K]` prevent accidental cross-domain composition.
- **Target specialization:** `HKTInferenceEngine[T]` binds behavior to a `ComputeTarget` at compile time.
- **Compile seam:** `compile_kernel(...)` marks where typed probabilistic logic can lower to target-specific kernels.

Together, these controls reduce integration risk in multi-contributor model repos.

## Practical applications

The same pattern applies across domains where uncertainty-aware scoring matters:

- **Finance:** risk scoring, fraud suspicion priors, and confidence-weighted market signals.
- **Healthcare:** triage prioritization, readmission risk estimates, and noisy-signal fusion.
- **Operations:** demand forecasting, incident likelihood updates, and resource balancing.
- **Recommendations:** feed ranking, candidate reweighting, and exploration/exploitation control.

## Repository contents

- `src/hkt_probprog.mojo`: core library types and inference engine.
- `src/main.mojo`: minimal smoke demo for local verification.
- `examples/social_reco_demo.mojo`: well-documented library usage example.
- `tests/test_hkt_demo.mojo`: posterior update correctness test.

## Example

```mojo
from src.hkt_probprog import CPU, BayesianScore, FeatureSignal, GaussianPrior, HKTInferenceEngine

fn main() raises:
    let engine = HKTInferenceEngine[CPU]()
    var score = BayesianScore[FeatureSignal](
        GaussianPrior(mu=0.45, sigma=0.20),
        evidence_weight=0.0,
    )

    score = engine.observe(score, observed=0.82, confidence=0.75)
    print("target:", engine.target_label())
    print("posterior relevance:", score.posterior_mean())
    print(engine.compile_kernel(score))
```

## Quick start

```zsh
mojo src/main.mojo
mojo examples/social_reco_demo.mojo
mojo tests/test_hkt_demo.mojo
```

## Bluesky demo integration

A separate application demo is provided in `/bluesky` to show how an app imports this library and applies it to a social-media recommendation scenario.
