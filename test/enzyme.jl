using CommonSolve, EnzymeCore, Test

@testset "EnzymeCore inactive_kwarg extension" begin
    # The extension installs `inactive_kwarg` methods on CommonSolve's four
    # generic solver functions, declaring their kwargs Enzyme-inactive.
    for f in (CommonSolve.init, CommonSolve.solve!, CommonSolve.solve, CommonSolve.step!)
        ms = methods(EnzymeCore.EnzymeRules.inactive_kwarg, Tuple{typeof(f)})
        @test length(ms) == 1
        @test only(ms).module ===
            Base.get_extension(CommonSolve, :CommonSolveEnzymeCoreExt)
    end
end
