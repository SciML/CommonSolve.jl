"""
```julia
module CommonSolve
```

Defines the shared solver interface functions used by solver packages that need
common names without exporting them into downstream user namespaces. The public
API is the set of generic functions [`CommonSolve.solve`](@ref),
[`CommonSolve.solve!`](@ref), [`CommonSolve.init`](@ref), and
[`CommonSolve.step!`](@ref).

## Interface

Downstream packages extend these functions on problem, algorithm, iterator, or
cache types that they own. This keeps independent solver ecosystems compatible
without introducing type piracy or method ambiguities.

## Example

```julia
using CommonSolve

struct MyProblem end
struct MyAlg end

CommonSolve.solve(::MyProblem, ::MyAlg) = :solution

CommonSolve.solve(MyProblem(), MyAlg())
```
"""
module CommonSolve

"""
```julia
CommonSolve.solve(args...; kwargs...)
```

Solve an equation or other mathematical problem using the algorithm specified
in the arguments. Generally, downstream packages extend:

```julia
CommonSolve.solve(prob::ProblemType, alg::SolverType; kwargs...)::SolutionType
```

If a package only defines the iterator interface, `solve` falls back to:

```julia
solve(args...; kwargs...) = solve!(init(args...; kwargs...))
```

## Arguments

  - `args...`: Problem, algorithm, and implementation-specific positional arguments.
  - `kwargs...`: Implementation-specific solver options.

## Returns

The solution object defined by the downstream solver implementation.

## Example

```julia
struct MyProblem end
struct MyAlg end

CommonSolve.solve(::MyProblem, ::MyAlg; kwargs...) = :solution

CommonSolve.solve(MyProblem(), MyAlg())
```
"""
solve(args...; kwargs...) = solve!(init(args...; kwargs...))

"""
```julia
CommonSolve.solve!(iter)
```

Complete the solve using an iterator or cache object created by
[`CommonSolve.init`](@ref). Generally, downstream packages extend:

```julia
iter = CommonSolve.init(prob::ProblemType, alg::SolverType; kwargs...)::IterType
CommonSolve.solve!(iter)::SolutionType
```

## Arguments

  - `iter`: Solver state returned by `CommonSolve.init`.

## Returns

The solution object defined by the downstream solver implementation.

## Example

```julia
struct MyIterator end

CommonSolve.solve!(::MyIterator) = :solution

CommonSolve.solve!(MyIterator())
```
"""
function solve! end

"""
```julia
iter = CommonSolve.init(args...; kwargs...)
```

Create an iterator or cache object that can be passed to
[`CommonSolve.solve!`](@ref) or [`CommonSolve.step!`](@ref). Generally,
downstream packages extend:

```julia
iter = CommonSolve.init(prob::ProblemType, alg::SolverType; kwargs...)::IterType
CommonSolve.solve!(iter)::SolutionType
```

## Arguments

  - `args...`: Problem, algorithm, and implementation-specific positional arguments.
  - `kwargs...`: Implementation-specific solver options.

## Returns

An implementation-defined iterator or cache object that stores solver state.

## Example

```julia
struct MyProblem end
struct MyAlg end
struct MyIterator end

CommonSolve.init(::MyProblem, ::MyAlg; kwargs...) = MyIterator()

iter = CommonSolve.init(MyProblem(), MyAlg())
```
"""
function init end

"""
```julia
CommonSolve.step!(iter, args...; kwargs...)
```

Progress an iterator or cache object returned by [`CommonSolve.init`](@ref).
The additional arguments typically describe how far to advance the solve and
are implementation-specific.

## Arguments

  - `iter`: Solver state returned by `CommonSolve.init`.
  - `args...`: Implementation-specific step controls.
  - `kwargs...`: Implementation-specific step options.

## Returns

An implementation-defined value, commonly the updated iterator, a step result,
or `nothing`.

## Example

```julia
mutable struct MyIterator
    steps::Int
end

function CommonSolve.step!(iter::MyIterator)
    iter.steps += 1
    return iter
end

iter = CommonSolve.step!(MyIterator(0))
```
"""
function step! end

# `solve`, `solve!`, `init`, `step!` are CommonSolve's entire public API — each is
# documented above and is the canonical interface downstream solvers import and
# extend. They are intentionally NOT exported (to avoid `using`-scope clashes with
# the many packages that define their own `solve`/`init`/...), so mark them
# `public` so tooling (ExplicitImports) and users recognize them as API.
# `eval(Expr(:public, ...))` keeps this file parsing on the pre-1.11 floor where
# the `public` keyword does not yet exist.
@static if VERSION >= v"1.11.0-DEV.469"
    eval(Expr(:public, :solve, :solve!, :init, :step!))
end

end # module
