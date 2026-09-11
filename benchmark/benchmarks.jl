using CommonSolve, BenchmarkTools

const SUITE = BenchmarkGroup()

# A toy fixed-point solver implemented via the CommonSolve protocol
struct BenchProblem
    target::Float64
end

struct BenchSolver
    maxiters::Int
end

mutable struct BenchIterator
    x::Float64
    iters::Int
    maxiters::Int
end

CommonSolve.init(prob::BenchProblem, alg::BenchSolver) =
    BenchIterator(prob.target / 2, 0, alg.maxiters)

function CommonSolve.step!(it::BenchIterator)
    it.x = sqrt(it.x^2 + it.x)
    it.iters += 1
    return it
end

function CommonSolve.solve(prob::BenchProblem, alg::BenchSolver)
    it = CommonSolve.init(prob, alg)
    while it.iters < it.maxiters
        CommonSolve.step!(it)
    end
    return it.x
end

prob = BenchProblem(4.0)
alg = BenchSolver(1000)

# =============================================================================
# Protocol calls
# =============================================================================

SUITE["protocol"] = BenchmarkGroup()

SUITE["protocol"]["init"] = @benchmarkable CommonSolve.init($prob, $alg)
SUITE["protocol"]["solve"] = @benchmarkable CommonSolve.solve($prob, $alg)

it = CommonSolve.init(prob, alg)
SUITE["protocol"]["step!"] = @benchmarkable CommonSolve.step!($it)
