using CommonSolve, EnzymeCore, Test

@testset "EnzymeCore inactive_kwarg extension" begin
    # The extension installs `inactive_kwarg` methods on CommonSolve's three
    # terminal solver functions, declaring their kwargs Enzyme-inactive.
    # `step!` is intentionally not in this list — its kwargs (e.g. `dt`) can
    # legitimately carry derivative data.
    for f in (CommonSolve.init, CommonSolve.solve!, CommonSolve.solve)
        ms = methods(EnzymeCore.EnzymeRules.inactive_kwarg, Tuple{typeof(f)})
        @test length(ms) == 1
        @test only(ms).module ===
            Base.get_extension(CommonSolve, :CommonSolveEnzymeCoreExt)
    end
    # And `step!` should NOT have an inactive_kwarg declaration installed.
    @test isempty(methods(EnzymeCore.EnzymeRules.inactive_kwarg,
                          Tuple{typeof(CommonSolve.step!)}))
end
