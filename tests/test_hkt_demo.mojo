from src.hkt_probprog import CPU, BayesianScore, FeatureSignal, GaussianPrior, HKTInferenceEngine

fn assert_close(lhs: Float64, rhs: Float64, eps: Float64 = 1e-9) raises:
    let diff = lhs - rhs
    if diff > eps or diff < -eps:
        raise Error("assert_close failed")

fn main() raises:
    let engine = HKTInferenceEngine[CPU]()
    var score = BayesianScore[FeatureSignal](
        GaussianPrior(mu=0.20, sigma=0.30),
        evidence_weight=0.0,
    )

    score = engine.observe(score, observed=0.80, confidence=0.50)
    score = engine.observe(score, observed=0.60, confidence=0.25)

    let expected_mean = (0.20 + (0.80 * 0.50) + (0.60 * 0.25)) / (1.0 + 0.75)
    assert_close(score.posterior_mean(), expected_mean)

    print("ok: test_hkt_demo")

