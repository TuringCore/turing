from src.hkt_probprog import CPU, BayesianScore, FeatureSignal, GaussianPrior, HKTInferenceEngine

fn main() raises:
    let engine = HKTInferenceEngine[CPU]()

    # Start from a conservative prior for a generic feature signal.
    var score = BayesianScore[FeatureSignal](
        GaussianPrior(mu=0.50, sigma=0.20),
        evidence_weight=0.0,
    )

    # Apply a small sequence of confidence-weighted observations.
    score = engine.observe(score, observed=0.70, confidence=0.60)
    score = engine.observe(score, observed=0.40, confidence=0.30)

    print("target:", engine.target_label())
    print("posterior_mean:", score.posterior_mean())
    print("posterior_variance:", score.posterior_variance())

    # Demonstrates where Mojo compilation can lower typed model logic.
    print(engine.compile_kernel(score))
