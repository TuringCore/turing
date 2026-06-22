# Demonstrative probabilistic-programming kernel with HKT-style constraints.

trait KindTag:
    pass

trait ComputeTarget:
    fn label() -> String

struct CPU(ComputeTarget):
    fn label() -> String:
        return "cpu"

struct GPU(ComputeTarget):
    fn label() -> String:
        return "gpu"

# Domain kinds act like type constructors in Haskell/Scala.
struct FeatureSignal(KindTag):
    pass

struct TrustSignal(KindTag):
    pass

struct GaussianPrior:
    var mu: Float64
    var sigma: Float64

    fn __init__(inout self, mu: Float64, sigma: Float64):
        self.mu = mu
        self.sigma = sigma

fn abs64(value: Float64) -> Float64:
    if value < 0.0:
        return -value
    return value

fn clamp01(value: Float64) -> Float64:
    if value < 0.0:
        return 0.0
    if value > 1.0:
        return 1.0
    return value

struct Observation:
    var observed: Float64
    var confidence: Float64

    fn __init__(inout self, observed: Float64, confidence: Float64):
        self.observed = clamp01(observed)
        self.confidence = clamp01(confidence)

# MAP-style deterministic update path.
struct MAPPath:
    var dampening: Float64

    fn __init__(inout self, dampening: Float64 = 1.0):
        self.dampening = clamp01(dampening)

# Lightweight MH-style path with deterministic acceptance policy.
struct MHPath:
    var proposal_scale: Float64
    var prior_pull: Float64
    var accept_floor: Float64

    fn __init__(
        inout self,
        proposal_scale: Float64 = 0.5,
        prior_pull: Float64 = 0.5,
        accept_floor: Float64 = 0.70,
    ):
        self.proposal_scale = clamp01(proposal_scale)
        self.prior_pull = clamp01(prior_pull)
        self.accept_floor = clamp01(accept_floor)

# Particle-style path for streaming updates.
struct SMCPath:
    var retention: Float64
    var min_confidence: Float64

    fn __init__(inout self, retention: Float64 = 0.6, min_confidence: Float64 = 0.10):
        self.retention = clamp01(retention)
        self.min_confidence = clamp01(min_confidence)

# Mean-field VI-style path for stable serving-time updates.
struct VIPath:
    var evidence_discount: Float64
    var posterior_pull: Float64

    fn __init__(inout self, evidence_discount: Float64 = 0.5, posterior_pull: Float64 = 0.7):
        self.evidence_discount = clamp01(evidence_discount)
        self.posterior_pull = clamp01(posterior_pull)

struct BayesianScore[K: KindTag]:
    var prior: GaussianPrior
    var evidence_weight: Float64
    var observed_sum: Float64

    fn __init__(
        inout self,
        prior: GaussianPrior,
        evidence_weight: Float64,
        observed_sum: Float64 = 0.0,
    ):
        self.prior = prior
        self.evidence_weight = evidence_weight
        self.observed_sum = observed_sum

    fn posterior_mean(self) -> Float64:
        let denom = 1.0 + self.evidence_weight
        return (self.prior.mu + self.observed_sum) / denom

    fn posterior_variance(self) -> Float64:
        let shrink = 1.0 + self.evidence_weight
        return (self.prior.sigma * self.prior.sigma) / shrink

struct HKTInferenceEngine[T: ComputeTarget]:
    fn target_label(self) -> String:
        return T.label()

    # Enforces same kind K in and out, preventing accidental cross-domain composition.
    fn observe[K: KindTag](
        self,
        score: BayesianScore[K],
        observed: Float64,
        confidence: Float64,
    ) -> BayesianScore[K]:
        var updated = score
        let bounded_observed = clamp01(observed)
        let bounded_confidence = clamp01(confidence)
        updated.evidence_weight = score.evidence_weight + bounded_confidence
        updated.observed_sum = score.observed_sum + (bounded_observed * bounded_confidence)
        return updated

    fn run_map[K: KindTag](
        self,
        score: BayesianScore[K],
        path: MAPPath,
        observation: Observation,
    ) -> BayesianScore[K]:
        let scaled_confidence = clamp01(observation.confidence * path.dampening)
        return self.observe(
            score,
            observed=observation.observed,
            confidence=scaled_confidence,
        )

    fn run_mh[K: KindTag](
        self,
        score: BayesianScore[K],
        path: MHPath,
        proposal: Observation,
    ) -> BayesianScore[K]:
        let scaled_confidence = clamp01(proposal.confidence * path.proposal_scale)
        let candidate = self.observe(
            score,
            observed=proposal.observed,
            confidence=scaled_confidence,
        )

        let current_error = abs64(score.posterior_mean() - score.prior.mu)
        let candidate_error = abs64(candidate.posterior_mean() - score.prior.mu)
        let acceptance_proxy = clamp01(1.0 - (candidate_error * path.prior_pull))

        if candidate_error <= current_error or acceptance_proxy >= path.accept_floor:
            return candidate
        return score

    fn run_smc[K: KindTag](
        self,
        score: BayesianScore[K],
        path: SMCPath,
        observation: Observation,
    ) -> BayesianScore[K]:
        var effective_confidence = observation.confidence * path.retention
        if effective_confidence < path.min_confidence:
            effective_confidence = path.min_confidence
        return self.observe(
            score,
            observed=observation.observed,
            confidence=effective_confidence,
        )

    fn run_vi[K: KindTag](
        self,
        score: BayesianScore[K],
        path: VIPath,
        observation: Observation,
    ) -> BayesianScore[K]:
        let discounted_confidence = clamp01(observation.confidence * path.evidence_discount)
        let updated = self.observe(
            score,
            observed=observation.observed,
            confidence=discounted_confidence,
        )

        let blended_mean = (
            updated.posterior_mean() * path.posterior_pull
            + score.posterior_mean() * (1.0 - path.posterior_pull)
        )
        let reconstructed_sum = (blended_mean * (1.0 + updated.evidence_weight)) - score.prior.mu
        return BayesianScore[K](
            score.prior,
            evidence_weight=updated.evidence_weight,
            observed_sum=reconstructed_sum,
        )

    fn compile_kernel[K: KindTag](self, score: BayesianScore[K]) -> String:
        _ = score
        return "Compiled probabilistic kernel for " + self.target_label()

