using CommonSolve
using Test

module GenericSolverInterfaceTest

using CommonSolve

struct Problem
    initial_value::Int
end

struct IterativeAlgorithm end
struct DirectAlgorithm end

mutable struct Iterator
    value::Int
end

CommonSolve.init(problem::Problem, ::IterativeAlgorithm; offset = 0) =
    Iterator(problem.initial_value + offset)
CommonSolve.solve!(iter::Iterator) = iter.value
function CommonSolve.step!(iter::Iterator; increment = 1)
    iter.value += increment
    return iter
end
CommonSolve.solve(problem::Problem, ::DirectAlgorithm; offset = 0) =
    problem.initial_value + offset

end

@testset "CommonSolve.jl" begin
    # CommonSolve is a pure interface package. There is no behavior to exercise
    # beyond confirming the package loads and its public interface is declared
    # and documented.
    @test isdefined(CommonSolve, :solve)
    @test isdefined(CommonSolve, :solve!)
    @test isdefined(CommonSolve, :init)
    @test isdefined(CommonSolve, :step!)

    public_api = (:CommonSolve, :solve, :solve!, :init, :step!)
    for name in public_api
        binding = Base.Docs.Binding(CommonSolve, name)
        @test haskey(Base.Docs.meta(CommonSolve), binding)
    end

    @static if VERSION >= v"1.11.0-DEV.469"
        for name in public_api
            @test Base.ispublic(CommonSolve, name)
        end
    end
end

@testset "Generic solver interface" begin
    problem = GenericSolverInterfaceTest.Problem(2)
    iterative_algorithm = GenericSolverInterfaceTest.IterativeAlgorithm()

    # `solve`'s generic fallback composes only the public `init` and `solve!` functions.
    @test CommonSolve.solve(problem, iterative_algorithm; offset = 3) == 5

    iter = CommonSolve.init(problem, iterative_algorithm; offset = 1)
    @test CommonSolve.step!(iter; increment = 4) === iter
    @test CommonSolve.solve!(iter) == 7

    direct_algorithm = GenericSolverInterfaceTest.DirectAlgorithm()
    @test CommonSolve.solve(problem, direct_algorithm; offset = 3) == 5
end
