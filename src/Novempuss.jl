module Novempuss

include("MethodSets.jl")
using .MethodSets

using Graphs
include("Graphlets.jl")

using Dates
include("LogicalGraph.jl")

export LogicalGraph

end
