from hkt_probprog import CPU, BayesianScore, FeatureSignal, GaussianPrior, HKTInferenceEngine

fn main() raises:
    let engine = HKTInferenceEngine[CPU]()
    var score = BayesianScore[FeatureSignal](
        GaussianPrior(mu=0.40, sigma=0.25),
        evidence_weight=0.0,
    )

    score = engine.observe(score, observed=0.90, confidence=0.70)
    score = engine.observe(score, observed=0.30, confidence=0.20)

    print("target:", engine.target_label())
    print("posterior_mean:", score.posterior_mean())
    print("posterior_variance:", score.posterior_variance())
    print(engine.compile_kernel(score))

