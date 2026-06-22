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

fn assert_close(lhs: Float64, rhs: Float64, eps: Float64 = 1e-9) raises:
    let diff = lhs - rhs
    if diff > eps or diff < -eps:
        raise Error("assert_close failed")

fn main() raises:
    let engine = HKTInferenceEngine[CPU]()
    var score = BayesianScore[FeatureSignal](
        GaussianPrior(mu=0.30, sigma=0.20),
        evidence_weight=0.0,
    )

    score = engine.run_map(score, MAPPath(dampening=0.80), Observation(0.90, 0.50))
    let expected_map = (0.30 + (0.90 * 0.40)) / (1.0 + 0.40)
    assert_close(score.posterior_mean(), expected_map)

    score = engine.run_mh(
        score,
        MHPath(proposal_scale=0.50, prior_pull=0.50, accept_floor=0.75),
        Observation(0.10, 0.80),
    )
    let expected_mh = (0.30 + 0.40) / (1.0 + 0.80)
    assert_close(score.posterior_mean(), expected_mh)

    score = engine.run_smc(score, SMCPath(retention=0.60, min_confidence=0.10), Observation(0.70, 0.40))
    let expected_smc = (0.30 + 0.568) / (1.0 + 1.04)
    assert_close(score.posterior_mean(), expected_smc)

    score = engine.run_vi(score, VIPath(evidence_discount=0.50, posterior_pull=0.70), Observation(0.60, 0.60))
    let expected_vi = 0.44115125698324017
    assert_close(score.posterior_mean(), expected_vi)

    print("ok: test_inference_paths")

