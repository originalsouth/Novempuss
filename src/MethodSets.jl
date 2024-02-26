module MethodSets

name(met::Method) = met.name
mod(met::Method) = met.module
args(met::Method) = fieldcount(met.sig) - 1

Base.sign(met::Method) = Tuple{fieldtypes(met.sig)[2:end]...}
Base.run(met::Method) = getfield(mod(met), name(met))
Base.run(met::Method, args::T) where T <: Tuple = run(met)(args...)

export MethodSet

struct MethodSet
    methodindex::Dict{DataType, Set{Method}}
end
MethodSet() = MethodSet(Dict{DataType, Set{Method}}())
MethodSet(method::Method) = push!(MethodSet(), method)
MethodSet(func::Function) = push!(MethodSet(), func)

for FM in [Function, Method]
    @eval begin
        function MethodSet(fms::AbstractVector{$FM})
            ms = MethodSet()
            for fm in fms
                push!(ms, fm)
            end
            return ms
        end
    end
end

methodset(ms::MethodSet) = union(Set{Method}(), values(ms.methodindex)...)
methodset(ms::MethodSet, dims::Int) = union(Set{Method}(), values(filter(x -> fieldcount(x[1]) == dims, ms.methodindex))...)
methodset(ms::MethodSet, dims::Vector{Int}) = union(Set{Method}(), map(x -> methodset(ms, x), dims)...)

Base.getindex(ms::MethodSet, T::DataType) = haskey(ms.methodindex, T) ? ms.methodindex[T] : Set{Method}()
Base.merge(ms1::MethodSet, ms2::MethodSet) = MethodSet(mergewith(union, ms1.methodindex, ms2.methodindex))
Base.sign(ms::MethodSet) = Set{DataType}(keys(ms.methodindex))
Base.sign(ms::MethodSet, dims::Int) = filter(x -> fieldcount(x) == dims, sign(ms))

function Base.push!(ms::MethodSet, method::Method)
	if haskey(ms.methodindex, sign(method))
		push!(ms.methodindex[sign(method)], method)
	else
		push!(ms.methodindex, sign(method) => Set{Method}([method]))
	end
	return ms
end

function Base.push!(ms::MethodSet, f::Function)
	for method in methods(f)
		push!(ms, method)
	end
	return ms
end

function Base.delete!(ms::MethodSet, method::Method)
	if haskey(ms.methodindex, sign(method))
		delete!(ms.methodindex[sign(method)], method)
        if isempty(ms.methodindex[sign(method)])
            delete!(ms.methodindex, sign(method))
        end
	end
	return ms
end

function Base.delete!(ms::MethodSet, f::Function)
	for method in methods(f)
		delete!(ms, method)
	end
	return ms
end

Base.run(ms::MethodSet, arg::T) where T<:Tuple = collect(Iterators.map(x -> run(x, arg), ms[T]))
Base.run(ms::MethodSet, args::Vector{T}) where T<:Tuple = [run(ms, arg) for arg in args]

end
