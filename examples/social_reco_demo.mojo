from src.hkt_probprog import GPU, BayesianScore, FeatureSignal, GaussianPrior, HKTInferenceEngine

fn main() raises:
    let engine = HKTInferenceEngine[GPU]()

    # Prior: user may like physics posts with moderate confidence.
    var physics_interest = BayesianScore[FeatureSignal](
        GaussianPrior(mu=0.50, sigma=0.20),
        evidence_weight=0.0,
    )

    # New evidence from engagement events.
    physics_interest = engine.observe(physics_interest, observed=0.95, confidence=0.80)
    physics_interest = engine.observe(physics_interest, observed=0.85, confidence=0.60)
    physics_interest = engine.observe(physics_interest, observed=0.15, confidence=0.20)

    let posterior = physics_interest.posterior_mean()

    print("compile_target:", engine.target_label())
    print("physics_interest_posterior:", posterior)

    if posterior > 0.70:
        print("recommendation: Rank science feed high")
    elif posterior > 0.45:
        print("recommendation: Blend science with broader feed")
    else:
        print("recommendation: Keep science as occasional exploration")

    print(engine.compile_kernel(physics_interest))

