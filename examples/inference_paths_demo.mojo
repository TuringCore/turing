from src.hkt_probprog import (
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
        GaussianPrior(mu=0.30, sigma=0.20),
        evidence_weight=0.0,
    )

    score = engine.run_map(score, MAPPath(dampening=0.80), Observation(0.90, 0.50))
    print("after_map:", score.posterior_mean())

    score = engine.run_mh(score, MHPath(proposal_scale=0.50), Observation(0.10, 0.80))
    print("after_mh:", score.posterior_mean())

    score = engine.run_smc(score, SMCPath(retention=0.60), Observation(0.70, 0.40))
    print("after_smc:", score.posterior_mean())

    score = engine.run_vi(score, VIPath(evidence_discount=0.50, posterior_pull=0.70), Observation(0.60, 0.60))
    print("after_vi:", score.posterior_mean())

    print(engine.compile_kernel(score))

