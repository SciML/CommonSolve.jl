module CommonSolveEnzymeCoreExt

using CommonSolve
using EnzymeCore

# Every SciML solver's `init`, `solve!`, `solve`, and `step!` accepts solver-
# configuration kwargs (e.g. `abstol`, `reltol`, `verbose`, `alias`, `assumptions`,
# `Pl`, `Pr`, …). None of these carry derivative data — they are scalar tolerances,
# booleans, or non-numeric configuration. Declaring them inactive lets the custom
# Enzyme rules downstream solver packages register on these generic functions
# avoid `NonConstantKeywordArgException` when callers reach them through
# `Enzyme.gradient(set_runtime_activity(Reverse), Const(loss), …)`.
#
# See SciML/CommonSolve.jl#68 and the upstream Enzyme guidance at
# https://github.com/JuliaDiff/DifferentiationInterface.jl/issues/1020#issuecomment-4513384472.
EnzymeCore.EnzymeRules.inactive_kwarg(::typeof(CommonSolve.init), args...; kwargs...) = nothing
EnzymeCore.EnzymeRules.inactive_kwarg(::typeof(CommonSolve.solve!), args...; kwargs...) = nothing
EnzymeCore.EnzymeRules.inactive_kwarg(::typeof(CommonSolve.solve), args...; kwargs...) = nothing
EnzymeCore.EnzymeRules.inactive_kwarg(::typeof(CommonSolve.step!), args...; kwargs...) = nothing

end # module
