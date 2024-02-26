struct Transaction{T}
    func::Symbol
    argm::Vector{T}
    when::DateTime
end
Transaction(f::Symbol, argm::Vector{T}) where T = Transaction{T}(f, argm, now())

func(tx::Transaction) = tx.func
argm(tx::Transaction) = tx.argm
when(tx::Transaction) = tx.when

struct LogicalGraph{T} <: AbstractGraph{T}
    ms::MethodSet
    store::Dict{Vector{T}, Graphlet{T}}
    heads::Vector{Tuple{Graphlet{T}, Transaction}}
end
LogicalGraph{T}() where T = LogicalGraph{T}(MethodSet(), Dict{Vector{T}, Graphlet{T}}(), Tuple{Graphlet{T}, Symbol, Vector}[])

ms(lg::LogicalGraph) = lg.ms
store(lg::LogicalGraph) = lg.store
graphlets(lg::LogicalGraph) = collect(values(store(lg)))
heads(lg::LogicalGraph) = lg.heads
current(lg::LogicalGraph) = first(last(heads(lg)))
previous(lg::LogicalGraph, i::Int) = first(heads(lg)[end-i])
graph(lg::LogicalGraph) = graph(current(lg))

_merge(lg::LogicalGraph{T}) where T = _merge(isempty(store(lg)) ? [Graphlet{T}()] : graphlets(lg), ms(lg))

for FM in [Function, Method]
    @eval begin
        LogicalGraph{T}(fms::Vector{$FM}) where T = push!(LogicalGraph{T}(), fms)
        LogicalGraph{T}(fm::$FM) where T = LogicalGraph{T}($FM[fm])

        function Base.push!(lg::LogicalGraph{T}, fms::Vector{$FM}) where T
            for fm in fms
                push!(ms(lg), fm)
            end
            for key in keys(store(lg))
                push!(store(lg), key => Graphlet{T}(key, ms(lg)))
            end
            push!(heads(lg), (_merge(lg), Transaction(:fmpush, fms)))
            return lg
        end
        Base.push!(lg::LogicalGraph{T}, fm::$FM) where T = push!(lg, $FM[fm])

        function Base.delete!(lg::LogicalGraph{T}, fms::Vector{$FM}) where T
            for fm in fms
                delete!(ms(lg), fm)
            end
            for key in keys(store(lg))
                push!(store(lg), key => Graphlet{T}(key, ms(lg)))
            end
            push!(heads(lg), (_merge(lg), Transaction(:fmdelete, fms)))
            return lg
        end
        Base.delete!(lg::LogicalGraph{T}, fm::$FM) where T = delete!(lg, $FM[fm])
    end
end

function Base.push!(lg::LogicalGraph{T}, roots::Vector{T}) where T
    push!(store(lg), roots => Graphlet{T}(roots, ms(lg)))
    push!(heads(lg), (_merge(lg), Transaction(:rootpush, roots)))
    return lg
end

function Base.delete!(lg::LogicalGraph{T}, roots::Vector{T}) where T
    delete!(store(lg), roots)
    push!(heads(lg), (_merge(lg), Transaction(:rootdelete, roots)))
    return lg
end

Base.getindex(lg::LogicalGraph{T}, roots::Vector{T}) where T = store(lg)[roots]

ingraphlets(node::U, lg::LogicalGraph{T}) where {T, U<:T} = in.(Ref(node), nodes(values(store(lg))))
rootfind(lg::LogicalGraph{T}, node::U) where {T, U<:T} = collect(keys(filter(x -> node in nodes(last(x)), store(lg))))
isroot(lg::LogicalGraph{T}, node::U) where {T, U<:T} = any(in.(node, keys(store(lg))))

Graphs.is_directed(_::LogicalGraph) = true
Graphs.edgetype(_::LogicalGraph{T}) where T = Tuple{T, T}
Graphs.vertices(lg::LogicalGraph) = vertices(current(lg))
Graphs.edges(lg::LogicalGraph) = edges(current(lg))
Graphs.has_vertex(lg::LogicalGraph{T}, node::U) where {T, U<:T} = has_vertex(current(lg), node)
Graphs.has_edge(lg::LogicalGraph{T}, node1::U, node2::V) where {T, U<:T, V<:T} = has_vertex(current(lg), node1, node2)
Graphs.nv(lg::LogicalGraph) = nv(current(lg))
Graphs.ne(lg::LogicalGraph) = ne(current(lg))
Graphs.neighbors(lg::LogicalGraph{T}, node::U) where {T, U<:T} = neighbors(current(lg), node)
Graphs.inneighbors(lg::LogicalGraph{T}, node::U) where {T, U<:T} = inneighbors(current(lg), node)
Graphs.outneighbors(lg::LogicalGraph{T}, node::U) where {T, U<:T} = outneighbors(current(lg), node)
Graphs.all_neighbors(lg::LogicalGraph{T}, node::U) where {T, U<:T} = all_neighbors(current(lg), node)
