from turing import (
    CPU,
    BayesianScore,
    FeatureSignal,
    GaussianPrior,
    HKTInferenceEngine,
    MAPPath,
    MHPath,
    Observation,
    SMCPath,
    VIPath,
)

fn main() raises:
    let engine = HKTInferenceEngine[CPU]()
    var score = BayesianScore[FeatureSignal](
        GaussianPrior(mu=0.40, sigma=0.25),
        evidence_weight=0.0,
    )

    score = engine.run_map(score, MAPPath(dampening=0.85), Observation(0.90, 0.70))
    score = engine.run_mh(score, MHPath(), Observation(0.35, 0.40))
    score = engine.run_smc(score, SMCPath(retention=0.50), Observation(0.80, 0.30))
    score = engine.run_vi(score, VIPath(evidence_discount=0.60), Observation(0.55, 0.35))

    print("target:", engine.target_label())
    print("posterior_mean:", score.posterior_mean())
    print("posterior_variance:", score.posterior_variance())
    print(engine.compile_kernel(score))

