module CommonSolve

solve(args...; kwargs...) = solve!(init(args...; kwargs...))
function solve! end
function init end

end # module
