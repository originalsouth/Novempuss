struct Transaction{T}
    func::Symbol
    argm::Set{T}
    when::DateTime
end
Transaction(f::Symbol, argm::Set{T}) where T = Transaction{T}(f, argm, now())

func(tx::Transaction) = tx.func
argm(tx::Transaction) = tx.argm
when(tx::Transaction) = tx.when

struct LogicalGraph{T} <: AbstractGraph{T}
    ms::MethodSet
    store::Dict{Set{T}, Graphlet{T}}
    heads::Vector{Tuple{Graphlet{T}, Transaction}}
end
LogicalGraph{T}() where T = LogicalGraph{T}(MethodSet(), Dict{Set{T}, Graphlet{T}}(), Tuple{Graphlet{T}, Transaction}[])

ms(lg::LogicalGraph) = lg.ms
store(lg::LogicalGraph) = lg.store
graphlets(lg::LogicalGraph) = collect(values(store(lg)))
heads(lg::LogicalGraph) = lg.heads
current(lg::LogicalGraph, i::Int = 0) = first(heads(lg)[end-i])
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
            push!(heads(lg), (_merge(lg), Transaction(:fmpush, Set(fms))))
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
            push!(heads(lg), (_merge(lg), Transaction(:fmdelete, Set(fms))))
            return lg
        end
        Base.delete!(lg::LogicalGraph{T}, fm::$FM) where T = delete!(lg, $FM[fm])
    end
end

function Base.push!(lg::LogicalGraph{T}, roots::Set{U}) where {T, U<:T}
    push!(store(lg), roots => Graphlet{T}(roots, ms(lg)))
    push!(heads(lg), (_merge(lg), Transaction(:rootpush, roots)))
    return lg
end
Base.push!(lg::LogicalGraph{T}, roots::Vector{U}) where {T, U<:T} = push!(lg, Set{U}(roots))

function Base.delete!(lg::LogicalGraph{T}, roots::Set{U}) where {T, U<:T}
    delete!(store(lg), roots)
    push!(heads(lg), (_merge(lg), Transaction(:rootdelete, roots)))
    return lg
end
Base.delete!(lg::LogicalGraph{T}, roots::Vector{U}) where {T, U<:T} = delete!(lg, Set{U}(roots))

Base.getindex(lg::LogicalGraph{T}, roots::Set{U}) where {T, U<:T} = store(lg)[roots]
Base.getindex(lg::LogicalGraph{T}, roots::Vector{U}) where {T, U<:T} = lg[Set{U}(roots)]
Base.zero(::Type{LogicalGraph{T}}) where T = LogicalGraph{T}()
Base.zero(_::LogicalGraph{T}) where T = zero(LogicalGraph{T})
Base.isempty(lg::LogicalGraph) = isempty(store(lg))

shortest(lg::LogicalGraph{T}, node1::U, node2::V) where {T, U<:T, V<:T} = shortest(current(lg), node1, node2)
isroot(lg::LogicalGraph{T}, node::U) where {T, U<:T} = !isempty(filter(x -> node in first(x), store(lg)))
isroot(lg::LogicalGraph{T}, key::Set{U}) where {T, U<:T} = haskey(store(lg), key)
isroot(lg::LogicalGraph{T}, key::Vector{U}) where {T, U<:T} = isroot(lg, Set{U}(key))
rootfind(lg::LogicalGraph{T}, node::U) where {T, U<:T} = collect(keys(filter(x -> node in nodes(last(x)), store(lg))))

function rootfindall(lg::LogicalGraph{T}, node::U) where {T, U<:T}
    stack = T[node]
    blocklist = T[node]
    retval = Set{T}[]
    while !isempty(stack)
        target = pop!(stack)
        roots = filter(x -> x ∉ retval, rootfind(lg, target))
        if isempty(roots)
            for inn in inneighbors(lg, target)
                if inn ∉ blocklist
                    push!(blocklist, inn)
                    push!(stack, inn)
                end
            end
        else
            union!(retval, roots)
        end
    end
    return retval
end

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
Graphs.common_neighbors(lg::LogicalGraph{T}, node1::U, node2::V) where {T, U<:T, V<:T} = common_neighbors(current(lg), node1, node2)
