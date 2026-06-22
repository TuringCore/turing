from src.hkt_probprog import (
    CPU,
    BayesianScore,
    FeatureSignal,
    GaussianPrior,
    HKTInferenceEngine,
    MAPPath,
    Observation,
    SMCPath,
)

fn main() raises:
    let engine = HKTInferenceEngine[CPU]()

    # Start from a baseline prior for a generic feature signal.
    var score = BayesianScore[FeatureSignal](
        GaussianPrior(mu=0.50, sigma=0.20),
        evidence_weight=0.0,
    )

    # Apply practical execution paths used by ranking systems.
    score = engine.run_map(score, MAPPath(dampening=0.90), Observation(0.70, 0.60))
    score = engine.run_smc(score, SMCPath(retention=0.70), Observation(0.40, 0.30))

    print("target:", engine.target_label())
    print("posterior_mean:", score.posterior_mean())
    print("posterior_variance:", score.posterior_variance())

    # Demonstrates where Mojo compilation can lower typed model logic.
    print(engine.compile_kernel(score))
