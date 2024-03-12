function find(s::Set{T}, target::U) where {T, U<:T}
    for (i, value) in Iterators.Enumerate(s)
       if value == target
           return i
       end
    end
    BoundsError(s, target)
end

function yield(s::Set{T}, target::Int) where T
    for (i, value) in Iterators.Enumerate(s)
       if i == target
           return value
       end
    end
    BoundsError(s, target)
end

struct Graphlet{T} <: AbstractGraph{T}
    nodes::Set{T}
    links::Dict{Tuple{T, T}, Set{Tuple{Symbol, DataType}}}
end
Graphlet{T}() where T = Graphlet{T}(Set{T}(), Dict{Tuple{T, T}, Set{Tuple{Symbol, DataType}}}())
Graphlet{T}(x::U, ms::MethodSet) where {T, U<:T} = _construct!(Graphlet{T}(), x, ms)
Graphlet{T}(x::Vector{U}, ms::MethodSet) where {T, U<:T} = _construct!(Graphlet{T}(), x, ms)
Graphlet{T}(x::Set{U}, ms::MethodSet) where {T, U<:T} = _construct!(Graphlet{T}(), collect(x), ms)

nodes(gl::Graphlet) = gl.nodes
nodes(x::Vector{T}) where T<:Tuple{Vararg} = unique(collect(Iterators.flatten(x)))
links(gl::Graphlet) = gl.links

find(gl::Graphlet{T}, target::U) where {T, U<:T} = find(nodes(gl), target)
edge(gl::Graphlet{T}, node1::U, node2::V) where {T, U<:T, V<:T} = links(gl)[(node1, node2)]
yield(gl::Graphlet, i::Int) = yield(nodes(gl), i)
yield(gl::Graphlet, edge::Edge) = (yield(nodes(gl), edge.src), yield(nodes(gl), edge.dst))
graph(gl::Graphlet) = SimpleDiGraph(isempty(links(gl)) ? length(gl) : Edge.([find.(Ref(nodes(gl)), ekey) for ekey in keys(links(gl))]))
shortest(gl::Graphlet{T}, node1::U, node2::V) where {T, U<:T, V<:T} = map(x -> yield(gl, x), a_star(graph(gl), find(gl, node1), find(gl, node2)))

Base.length(gl::Graphlet) = length(nodes(gl))
Base.size(gl::Graphlet) = (nv(gl), ne(gl))
Base.:(==)(gl1::Graphlet{T}, gl2::Graphlet{T}) where T = nodes(gl1) == nodes(gl2) && links(gl1) == links(gl2)
Base.:(+)(gl1::Graphlet{T}, gl2::Graphlet{T}) where T = _simple_merge(gl1, gl2)
Base.:(-)(gl1::Graphlet{T}, gl2::Graphlet{T}) where T = _simple_diff(gl1, gl2)
Base.zero(::Type{Graphlet{T}}) where T = Graphlet{T}()
Base.zero(_::Graphlet{T}) where T = zero(Graphlet{T})
Base.isempty(gl::Graphlet) = isempty(nodes(gl))

Graphs.is_directed(_::Graphlet) = true
Graphs.edgetype(_::Graphlet{T}) where T = Tuple{T, T}
Graphs.vertices(gl::Graphlet) = collect(nodes(gl))
Graphs.edges(gl::Graphlet) = collect(keys(links(gl)))
Graphs.has_vertex(gl::Graphlet{T}, node::U) where {T, U<:T} = node in nodes(gl)
Graphs.has_edge(gl::Graphlet{T}, node1::U, node2::V) where {T, U<:T, V<:T} = haskey(links(gl), (node1, node2))
Graphs.nv(gl::Graphlet) = length(nodes(gl))
Graphs.ne(gl::Graphlet) = length(links(gl))
Graphs.neighbors(gl::Graphlet{T}, node::U) where {T, U<:T} = outneighbors(gl, node)
Graphs.inneighbors(gl::Graphlet{T}, node::U) where {T, U<:T} = first.(filter(x -> last(x) == node, keys(links(gl))))
Graphs.outneighbors(gl::Graphlet{T}, node::U) where {T, U<:T} = last.(filter(x -> first(x) == node, keys(links(gl))))
Graphs.all_neighbors(gl::Graphlet{T}, node::U) where {T, U<:T} = union(outneighbors(gl, node), inneighbors(gl, node))
Graphs.common_neighbors(gl::Graphlet{T}, node1::U, node2::V) where {T, U<:T, V<:T} = intersect(neighbors(gl, node1), neighbors(node2))

function _connect!(gl::Graphlet{T}, target::Tuple{Vararg{T}}, result::U, mnames::Vector{Symbol}) where {T, U<:T}
    for mname in mnames
        edgedata = (mname, typeof(target))
        for targ in target
            idxs = (targ, result)
            if haskey(links(gl), idxs)
                push!(links(gl)[idxs], edgedata)
            else
                push!(links(gl), idxs => Set{Tuple{Symbol, DataType}}([edgedata]))
            end
        end
    end
end

function _get_targets(obj::Set{T}, parent::U, ms::MethodSet) where {T, U<:T}
    retval = Tuple{Vararg{T}}[]
    for sgn in Iterators.map(fieldtypes, sign(ms))
        radix = [filter(x -> typeof(x) == sgn[i], obj) for i in 1:length(sgn)]
        target = filter(x -> parent in x, vec(collect(Iterators.product(radix...))))
        append!(retval, target)
    end
    return retval
end

function _infer!(gl::Graphlet{T}, stack::Vector{T}, ms::MethodSet) where T
    while !isempty(stack)
        targets = _get_targets(nodes(gl), pop!(stack), ms)
        results = Vector{Vector{T}}(map(x -> filter(!isnothing, vcat(x...)), run(ms, targets)))
        for (target, resultset) in zip(targets, results)
            mnames = MethodSets.name.(ms[typeof(target)])
            for result in resultset
                if result in nodes(gl)
                    _connect!(gl, target, result, mnames)
                else
                    push!(stack, result)
                    push!(nodes(gl), result)
                    _connect!(gl, target, result, mnames)
                end
            end
        end
    end
    return gl
end

function _construct!(gl::Graphlet{T}, root::U, ms::MethodSet) where {T, U<:T}
    push!(nodes(gl), root)
    return _infer!(gl, T[root], ms)
end

function _construct!(gl::Graphlet{T}, roots::Vector{T}, ms::MethodSet) where T
    for root in roots
        push!(nodes(gl), root)
    end
    return _infer!(gl, T[roots...], ms)
end

function _simple_merge(gs::Vector{Graphlet{T}}) where T
    newnodes = mapreduce(nodes, union, gs)
    newlinks = mapreduce(links, (x, y) -> mergewith(union, x, y), gs)
    return Graphlet{T}(newnodes, newlinks)
end

function _simple_diff(gs::Vector{Graphlet{T}}) where T
    newnodes = mapreduce(nodes, setdiff, gs)
    newlinks = filter(x -> all(in.(x[1], Ref(newnodes))), Dict(mapfoldr(links, setdiff, gs)))
    return Graphlet{T}(newnodes, newlinks)
end

for (nm, snm, mt) in [(:_merge, :_simple_merge, union), (:_diff, :_simple_diff, setdiff)]
    @eval begin
        function $nm(gs::Vector{Graphlet{T}}, ms::MethodSet) where T
            gl = $snm(gs)
            _infer!(gl, collect(nodes(gl)), ms)
            return gl
        end
        $snm(g1::Graphlet{T}, g2::Graphlet{T}) where T = $snm(Graphlet{T}[g1, g2])
        $nm(g1::Graphlet{T}, g2::Graphlet{T}, ms::MethodSet) where T = $nm(Graphlet{T}[g1, g2], ms)
    end
end
