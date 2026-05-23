module CommonSolveEnzymeCoreExt

using CommonSolve
using EnzymeCore

# `init`, `solve!`, and `solve` accept solver-configuration kwargs
# (e.g. `abstol`, `reltol`, `verbose`, `alias`, `assumptions`, `Pl`, `Pr`, …).
# None of these carry derivative data — they are scalar tolerances, booleans,
# or non-numeric configuration. Declaring them inactive lets the custom
# Enzyme rules downstream solver packages register on these generic functions
# avoid `NonConstantKeywordArgException` when callers reach them through
# `Enzyme.gradient(set_runtime_activity(Reverse), Const(loss), …)`.
#
# `step!` is intentionally excluded: its kwargs (e.g. `dt`) can legitimately
# carry derivative data, so blanket-inactivating them would silently zero
# real gradients.
#
# See SciML/CommonSolve.jl#68 and the upstream Enzyme guidance at
# https://github.com/JuliaDiff/DifferentiationInterface.jl/issues/1020#issuecomment-4513384472.
EnzymeCore.EnzymeRules.inactive_kwarg(::typeof(CommonSolve.init), args...; kwargs...) = nothing
EnzymeCore.EnzymeRules.inactive_kwarg(::typeof(CommonSolve.solve!), args...; kwargs...) = nothing
EnzymeCore.EnzymeRules.inactive_kwarg(::typeof(CommonSolve.solve), args...; kwargs...) = nothing

end # module
